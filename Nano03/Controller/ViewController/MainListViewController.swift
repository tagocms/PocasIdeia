//
//  MainListViewController.swift
//  Nano03
//
//  Created by Tiago Camargo Maciel dos Santos on 02/10/25.
//

import UIKit
import SwiftData

class MainListViewController: UIViewController {
    // MARK: - Properties
    let mainListView = MainListView()
    let alertController = UIAlertController(title: "Excluir item", message: "Se você excluir este item, não poderá recuperá-lo.", preferredStyle: .alert)
    var container: ModelContainer?
    var items: [Item] = [] {
        didSet {
            setupUIElements()
        }
    }
    var tags: [Tag] = []
    var predicate: Predicate<Item>? = nil
    var predicateTagList: [Tag] = [] {
        didSet {
            updatePredicate()
            loadItemsAndReloadTable()
        }
    }
    var sortOrder = [
        SortDescriptor(\Item.title, order: .forward),
        SortDescriptor(\Item.irritationLevel, order: .forward),
        SortDescriptor(\Item.createdDate, order: .forward)
    ]
    
    var indexPathToDelete: IndexPath? = nil
    
    // MARK: - Initializers
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        view = mainListView
        
        mainListView.listView.delegate = self
        mainListView.listView.dataSource = self
        mainListView.tagsCollectionView.delegate = self
        mainListView.tagsCollectionView.dataSource = self
        
        mainListView.newItemButton.onButtonPressed = createNewItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAlert()
        container = try? ModelContainer(for: Item.self)
        
        loadItemsAndReloadTable()
        loadTagsAndReloadCollection()
        setupUIElements()
    }
    
    // MARK: - Data functions
    func loadItemsFromContext() {
        var descriptor = FetchDescriptor<Item>()
        descriptor.predicate = predicate
        descriptor.sortBy = sortOrder
        items = (try? container?.mainContext.fetch(descriptor)) ?? []
    }
    
    func loadTagsFromContext() {
        var descriptor = FetchDescriptor<Tag>()
        descriptor.sortBy = [SortDescriptor(\Tag.name, order: .forward)]
        tags = (try? container?.mainContext.fetch(descriptor)) ?? []
    }
    
    func loadItemsAndReloadTable() {
        loadItemsFromContext()
        mainListView.listView.reloadData()
    }
    
    func loadTagsAndReloadCollection() {
        loadTagsFromContext()
        mainListView.tagsCollectionView.reloadData()
    }
    
    func confirmDeletion(at indexPath: IndexPath) {
        let item = items[indexPath.row]
        container?.mainContext.delete(item)
        items.remove(at: indexPath.row)
        mainListView.listView.deleteRows(at: [indexPath], with: .left)
    }
    
    func createNewItem() {
        let tag1 = Tag(id: UUID(), name: "Test1")
        let tag2 = Tag(id: UUID(), name: "Test2")
        let tag3 = Tag(id: UUID(), name: "Test3")
        let tag4 = Tag(id: UUID(), name: "Test4")
        let tag5 = Tag(id: UUID(), name: "Test5")
        
        let item1 = Item(id: UUID(), title: "Test1", irritationLevel: 2, summary: "lalalalla", images: [], tags: [tag1, tag2], createdDate: Date.now)
        let item2 = Item(id: UUID(), title: "Test2", irritationLevel: 1, summary: "lalalalla", images: [], tags: [tag1, tag2, tag3, tag4, tag5], createdDate: Date.now)
        let item3 = Item(id: UUID(), title: "Test3", irritationLevel: 3, summary: "lalalalla", images: [], tags: [tag5], createdDate: Date.now)

        
        for tag in tags {
            container?.mainContext.delete(tag)
        }
        
        container?.mainContext.insert(item1)
        container?.mainContext.insert(item2)
        container?.mainContext.insert(item3)
        let insertedItems = [item1, item2, item3]
        
        loadItemsFromContext()
        
        var indexPaths: [IndexPath] = [ ]
        for item in insertedItems {
            if let index = items.firstIndex(where: { $0.id == item.id }) {
                indexPaths.append(IndexPath(row: index, section: 0))
            }
        }
        
        mainListView.listView.insertRows(at: indexPaths, with: .right)
        
        if let cells = mainListView.listView.visibleCells as? [PocasTableViewCell] {
            for cell in cells {
                cell.tagsCollection.reloadData()
            }
        }
        
        loadTagsAndReloadCollection()
    }
    
    private func updatePredicate() {
        if predicateTagList.isEmpty {
            predicate = nil
        } else {
            let selectedTagNames = predicateTagList.map { $0.name }
            predicate = #Predicate<Item> { item in
                item.tags?.contains { tag in
                    selectedTagNames.contains(tag.name)
                } == true
            }
        }
    }
    
    // MARK: - Setup Functions
    func setupUIElements() {
        UIView.transition(with: mainListView.contentUnavailableView, duration: 0.5, options: .transitionCrossDissolve) { [weak self] in
            if self?.items.isEmpty == true {
                self?.mainListView.stackView.layer.opacity = 0
                self?.mainListView.contentUnavailableView.layer.opacity = 1
            } else {
                self?.mainListView.contentUnavailableView.layer.opacity = 0
                self?.mainListView.stackView.layer.opacity = 1
            }
        }
    }
    
    func setupAlert() {
        let confirmDeletion = UIAlertAction(title: "Exluir", style: .destructive) { [weak self] _ in
            if let indexPathToDelete = self?.indexPathToDelete {
                self?.confirmDeletion(at: indexPathToDelete)
            }
            self?.indexPathToDelete = nil
        }
        alertController.addAction(confirmDeletion)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true)
        }
        alertController.addAction(cancelAction)
    }

}

extension MainListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PocasTableViewCell.identifier) as? PocasTableViewCell else {
            fatalError("Unable to dequeue PocasTableViewCell")
        }
        
        let item = items[indexPath.row]
        cell.configure(with: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
            if let alertController = self?.alertController {
                self?.indexPathToDelete = indexPath
                self?.present(alertController, animated: true)
            }
            completion(true)
        }
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash")
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return configuration
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let deleteAction = UIAction(title: "Excluir item", image: UIImage(systemName: "trash"), attributes: [.destructive]) { [weak self] action in
                if let alertController = self?.alertController {
                    self?.indexPathToDelete = indexPath
                    self?.present(alertController, animated: true)
                }
            }
            return UIMenu(title: "", children: [deleteAction])
        }
        return configuration
    }
}

extension MainListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PocasTagCollectionViewCell.identifier, for: indexPath) as? PocasTagCollectionViewCell else {
            fatalError("Unable to dequeue reusable cell for Tag.")
        }
        let buttonName = tags[indexPath.row].name
        let button = PocasTagButton(type: .medium, tagName: buttonName, isTagSelected: false, isUserInteractionEnabled: true) { [weak self] button in
            if let tag = self?.tags[indexPath.row] {
                if button.isTagSelected {
                    self?.predicateTagList.removeAll { $0.name == tag.name }
                } else {
                    self?.predicateTagList.append(tag)
                }
            }
        }
        cell.tagButton = button
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let buttonName = tags[indexPath.row].name
        let button = PocasTagButton(type: .medium, tagName: buttonName, isTagSelected: false, isUserInteractionEnabled: true, onButtonPressed: {_ in })
        
        return button.intrinsicContentSize
    }
}
