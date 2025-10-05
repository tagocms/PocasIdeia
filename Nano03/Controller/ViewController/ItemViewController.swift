//
//  ItemViewController.swift
//  Nano03
//
//  Created by Tiago Camargo Maciel dos Santos on 03/10/25.
//

import PhotosUI
import SwiftData
import UIKit


class ItemViewController: UIViewController {
    // MARK: - Properties
    let itemView: ItemView
    let item: Item?
    let listViewController: MainListViewController
    let container: ModelContainer?
    
    let saveAlertController: UIAlertController = {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancelar", style: .cancel) { _ in
            alertController.dismiss(animated: true)
        }
        alertController.addAction(action)
        
        return alertController
    }()
    let deleteAlertController: UIAlertController = {
        let alertController = UIAlertController(title: "Excluir item", message: "Se você excluir este item, não poderá recuperá-lo.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancelar", style: .cancel) { _ in
            alertController.dismiss(animated: true)
        }
        alertController.addAction(action)
        
        return alertController
    }()
    let imagePickerController: PHPickerViewController = {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 3
        
        
        let imagePickerController = PHPickerViewController(configuration: configuration)
        
        return imagePickerController
    }()
    
    var totalTags: [Tag] = [ ]
    
    var itemTitle: String = "" {
        didSet {
            itemView.largeTitleInputField.text = itemTitle
            title = itemTitle
        }
    }
    var itemIrritationLevel: Int = 1 {
        didSet {
            itemView.irritationSelection.inputSlider?.value = Float(itemIrritationLevel)
        }
    }
    var itemSummary: String = "" {
        didSet {
            itemView.summaryInput.inputTextView?.text = itemSummary
        }
    }
    var itemSelectedImages: [Data] = [] {
        didSet {
            if itemSelectedImages.count > 3 {
                itemSelectedImages = Array(itemSelectedImages[0..<3])
            }
        }
    }
    var itemSelectedTags: [Tag] = []

    // MARK: - Lifecycle
    override func loadView() {
        super.loadView( )
        view = itemView
        title = item?.title
        navigationItem.largeTitleDisplayMode = .never
        
        itemTitle = item?.title ?? ""
        itemIrritationLevel = item?.irritationLevel ?? 1
        itemSummary = item?.summary ?? ""
        itemSelectedImages = item?.images ?? []
        itemSelectedTags = item?.tags ?? []
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemView.largeTitleInputField.delegate = self
        itemView.summaryInput.inputTextView?.delegate = self
        itemView.imageSelection.inputImages?.delegate = self
        itemView.tagSelection.inputTags?.delegate = self
        
        itemView.imageSelection.inputImages?.dataSource = self
        itemView.tagSelection.inputTags?.dataSource = self
        imagePickerController.delegate = self
        
        itemView.onSliderChanged = updateSliderValue
        itemView.imageSelection.onAddImagesButtonPressed = addNewImages
        itemView.saveItemButton.onButtonPressed = saveItemToContext
        itemView.deleteItemButton.onButtonPressed = deleteItemFromContext
        
        loadTotalTagsAndReloadCollection()
    }
    
    // MARK: - Initializers
    init(container: ModelContainer? = nil, item: Item? = nil, listViewController: MainListViewController) {
        self.item = item
        self.container = container
        self.listViewController = listViewController
        if item != nil {
            self.itemView = ItemView(itemViewType: .edit)
        } else {
            self.itemView = ItemView(itemViewType: .new)
        }
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
    
    func addNewImages() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            if status == .authorized {
                print("Photo access authorized.")
            }
        }
        
        if PHPhotoLibrary.authorizationStatus(for: .readWrite) == .authorized {
            present(imagePickerController, animated: true)
        }
    }
    
    func saveItemToContext() {
        if let item {
            saveAlertController.title = "Salvar o item"
            saveAlertController.message = "Ao salvar o item, os conteúdos anteriores serão sobrescritos. Deseja continuar?"
            if saveAlertController.actions.count == 1 {
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
                        
                        self?.listViewController.loadItemsAndReloadTable()
                        self?.listViewController.loadTagsAndReloadCollection()
                        self?.navigationController?.popViewController(animated: true)
                        try? self?.container?.mainContext.save()
                    }
                }
                saveAlertController.addAction(action)
            }
            present(saveAlertController, animated: true)
        } else {
            if !itemTitle.isEmpty && itemTitle.count <= 30 {
                let item = Item(title: itemTitle, irritationLevel: itemIrritationLevel, summary: itemSummary, images: itemSelectedImages, tags: itemSelectedTags)
                container?.mainContext.insert(item)
            } else {
                saveAlertController.title = "Título inválido"
                saveAlertController.message = "Não é possível salvar um item sem um título ou com um título de mais de 30 caracteres."
                present(saveAlertController, animated: true)
                return
            }
            listViewController.loadItemsAndReloadTable()
            listViewController.loadTagsAndReloadCollection()
            dismiss(animated: true)
            try? container?.mainContext.save()
        }
        
    }
    
    func deleteItemFromContext() {
        if deleteAlertController.actions.count == 1 {
            let deleteAction = UIAlertAction(title: "Excluir", style: .destructive) {[weak self] _ in
                if let item = self?.item {
                    self?.container?.mainContext.delete(item)
                }
                self?.listViewController.loadItemsAndReloadTable()
                self?.deleteAlertController.dismiss(animated: true)
                self?.navigationController?.popViewController(animated: true)
                try? self?.container?.mainContext.save()
            }
            
            deleteAlertController.addAction(deleteAction)
        }
        present(deleteAlertController, animated: true)
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
            var isTagSelected: Bool = false
            if itemSelectedTags.contains(tag) {
                isTagSelected = true
            }
            let button = PocasTagButton(type: .medium, tagName: tag.name, isTagSelected: isTagSelected, isUserInteractionEnabled: true) { [weak self] button in
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
            let image = UIImage(data: itemSelectedImages[indexPath.item])
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
            return CGSize(width: 100, height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        if collectionView == itemView.imageSelection.inputImages {
            let contextMenuConfiguration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
                let deleteImageAction = UIAction(title: "Excluir imagem", image: UIImage(systemName: "trash"), attributes: [.destructive]) { [weak self] _ in
                    self?.itemSelectedImages.remove(at: indexPaths[0].item)
                    collectionView.reloadData()
                }
                return UIMenu(title: "", children: [deleteImageAction])
            }
            return contextMenuConfiguration
        }
        
        return nil
    }
}


extension ItemViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
                if let image = object as? UIImage {
                    if let data = image.jpegData(compressionQuality: 0.8) {
                        if self?.itemSelectedImages.contains(data) == false {
                            self?.itemSelectedImages.append(data)
                            print("Image added")
                            DispatchQueue.main.async {
                                self?.itemView.imageSelection.inputImages?.reloadData()
                            }
                        }
                    }
                } else if let error = error {
                    print("Error loading image: \(error.localizedDescription)")
                }
            }
        }
        
        
        dismiss(animated: true)
    }
}
