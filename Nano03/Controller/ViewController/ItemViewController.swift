//
//  ItemViewController.swift
//  Nano03
//
//  Created by Tiago Camargo Maciel dos Santos on 03/10/25.
//

import UIKit
import SwiftData

class ItemViewController: UIViewController {
    let itemView = ItemView()
    let item: Item?
    let listViewController: MainListViewController
    let container: ModelContainer?
    
    let alertController: UIAlertController = {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancelar", style: .cancel) { _ in
            alertController.dismiss(animated: true)
        }
        alertController.addAction(action)
        
        return alertController
    }()
    
    var totalTags: [Tag] = [ ]
    
    var itemTitle: String = ""
    var itemIrritationLevel: Int = 1
    var itemSummary: String = ""
    var itemSelectedImages: [Data] = []
    var itemSelectedTags: [Tag] = []

    // MARK: - Lifecycle
    override func loadView() {
        super.loadView( )
        view = itemView
        title = item?.title
        navigationItem.largeTitleDisplayMode = .never
        
        itemView.largeTitleInputField.text = item?.title
        itemView.irritationSelection.inputSlider?.value = Float(item?.irritationLevel ?? 1)
        itemView.summaryInput.inputTextView?.text = item?.summary
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemView.largeTitleInputField.delegate = self
        itemView.summaryInput.inputTextView?.delegate = self
        itemView.imageSelection.inputImages?.delegate = self
        itemView.tagSelection.inputTags?.delegate = self
        
        itemView.imageSelection.inputImages?.dataSource = self
        itemView.tagSelection.inputTags?.dataSource = self
        
        itemView.onSliderChanged = updateSliderValue
        itemView.saveItemButton.onButtonPressed = saveItemToContext
        
        loadTotalTagsAndReloadCollection()
    }
    
    // MARK: - Initializers
    init(container: ModelContainer? = nil, item: Item? = nil, listViewController: MainListViewController) {
        self.item = item
        self.container = container
        self.listViewController = listViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Data functions
    func loadTotalTags() {
        var descriptor = FetchDescriptor<Tag>()
        descriptor.sortBy = [SortDescriptor(\Tag.name, order: .forward)]
        totalTags = (try? container?.mainContext.fetch(descriptor)) ?? [ ]
    }
    
    func loadTotalTagsAndReloadCollection(completion: (() -> Void)? = nil) {
        loadTotalTags()
        itemView.tagSelection.inputTags?.reloadData()
        
        // Execute completion after the next run loop cycle
        DispatchQueue.main.async {
            completion?()
        }
    }
    
    // MARK: - Callback functions
    func updateSliderValue() {
        itemIrritationLevel = Int(itemView.irritationSelection.inputSlider?.value ?? 1)
    }
    
    func saveItemToContext() {
        if let item {
            alertController.title = "Salvar o item"
            alertController.message = "Ao salvar o item, os conteúdos anteriores serão sobrescritos. Deseja continuar?"
            if alertController.actions.count == 1 {
                let action = UIAlertAction(title: "Salvar", style: .default) { [weak self] _ in
                    if let itemTitle = self?.itemTitle,
                       let itemIrritationLevel = self?.itemIrritationLevel,
                       let itemSummary = self?.itemSummary,
                       let itemSelectedImages = self?.itemSelectedImages,
                       let itemSelectedTags = self?.itemSelectedTags {
                        item.title = itemTitle
                        item.irritationLevel = itemIrritationLevel
                        item.summary = itemSummary
                        item.images = itemSelectedImages
                        item.tags = itemSelectedTags
                    }
                }
                alertController.addAction(action)
            }
            present(alertController, animated: true)
        } else {
            if !itemTitle.isEmpty {
                let item = Item(title: itemTitle, irritationLevel: itemIrritationLevel, summary: itemSummary, images: itemSelectedImages, tags: itemSelectedTags)
                container?.mainContext.insert(item)
            } else {
                alertController.title = "Item sem título"
                alertController.message = "Não é possível salvar um item sem um título."
                present(alertController, animated: true)
                return
            }
        }
        
        listViewController.loadItemsAndReloadTable()
        listViewController.loadTagsAndReloadCollection()
        dismiss(animated: true)
    }
    
}

extension ItemViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        itemTitle = textField.text ?? ""
    }
}

extension ItemViewController: UITextViewDelegate {
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        itemSummary = textView.text ?? ""
    }
}

extension ItemViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == itemView.imageSelection.inputImages {
            return itemSelectedImages.count
        } else if collectionView == itemView.tagSelection.inputTags {
            return totalTags.count + 1
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == itemView.tagSelection.inputTags {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PocasTagCollectionViewCell.identifier, for: indexPath) as? PocasTagCollectionViewCell else {
                fatalError("Unable to dequeue reusable cell for Tag.")
            }
            guard indexPath.item < totalTags.count else {
                let add = PocasTagButton(type: .add, tagName: "", isTagSelected: false, isUserInteractionEnabled: true) { [weak self] _ in
                    let tagCreationViewController = TagCreationViewController(container: self?.container, itemViewController: self)
                    let sheet = tagCreationViewController.sheetPresentationController
                    sheet?.detents = [
                        .custom(resolver: { context in
                            return context.maximumDetentValue * 0.2
                    })
                    ]
                    self?.present(tagCreationViewController, animated: true)
                }
                cell.tagButton = add
                return cell
            }
                    
            let tag = totalTags[indexPath.item]
            let button = PocasTagButton(type: .medium, tagName: tag.name, isTagSelected: false, isUserInteractionEnabled: true) { [weak self] button in
                if self?.itemSelectedTags.contains(tag) == true {
                    self?.itemSelectedTags.removeAll { $0.name == tag.name }
                } else {
                    self?.itemSelectedTags.append(tag)
                }
            }
            cell.tagButton = button
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PocasImageCollectionViewCell.identifier, for: indexPath) as? PocasImageCollectionViewCell else {
                fatalError("Unable to dequeue reusable cell for Tag.")
            }
            let image = UIImage(resource: .flame3)
            cell.customImageView.image = image
            return cell
        }
    }
}

extension ItemViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == itemView.tagSelection.inputTags {
            guard indexPath.item < totalTags.count else {
                let add = PocasTagButton(type: .add, tagName: "", isTagSelected: false, isUserInteractionEnabled: true) { _ in }
                let buttonSize = add.intrinsicContentSize
                return CGSize(width: buttonSize.width, height: buttonSize.height)
            }
            let tag = totalTags[indexPath.item]
            let button = PocasTagButton(type: .medium, tagName: tag.name, onButtonPressed: { _ in })
            let buttonSize = button.intrinsicContentSize
            return CGSize(width: buttonSize.width, height: buttonSize.height)
        } else {
            return CGSize(width: 60, height: 60)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        if collectionView == itemView.imageSelection.inputImages {
            let contextMenuConfiguration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
                let deleteImageAction = UIAction(title: "Excluir imagem", image: UIImage(systemName: "trash"), attributes: [.destructive]) { action in
                    // TODO: - Implement the deletion of the image
                }
                return UIMenu(title: "", children: [deleteImageAction])
            }
            return contextMenuConfiguration
        }
        
        return nil
    }
}
