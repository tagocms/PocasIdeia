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
    var tagButtons: [PocasTagButton] = []
    var predicate: Predicate<Item>? = nil
    var predicateTagList: [Tag] = [] {
        didSet {
            updatePredicate()
            animateFilterChanges()
        }
    }
    var searchText: String = "" {
        didSet {
            mainListView.searchBar.text = searchText
            updatePredicate()
            animateFilterChanges()
        }
    }
    var sortOrder = [
        SortDescriptor(\Item.title, order: .forward),
        SortDescriptor(\Item.irritationLevel, order: .forward),
        SortDescriptor(\Item.createdDate, order: .forward)
    ] {
        didSet {
            animateSortChanges()
        }
    }
    
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
        navigationController?.navigationBar.tintColor = .pocasSuperDarkCrimson
        navigationItem.title = "Voltar"
        
        mainListView.listView.delegate = self
        mainListView.listView.dataSource = self
        mainListView.tagsCollectionView.delegate = self
        mainListView.tagsCollectionView.dataSource = self
        mainListView.searchBar.delegate = self
        
        mainListView.newItemButton.onButtonPressed = createNewItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAlert()
        container = try? ModelContainer(for: Item.self)
        
        loadItemsAndReloadTable()
        loadTagsAndReloadCollection()
        setupOrderByButton()
        setupFilterButton()
        setupUIElements()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(tapGesture)
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
        let itemViewController = ItemViewController(container: container, listViewController: self)
        let sheet = itemViewController.sheetPresentationController
        sheet?.detents = [.large()]
        present(itemViewController, animated: true)
    }
    
    private func updatePredicate() {
        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var tempPredicate: Predicate<Item>?
        if predicateTagList.isEmpty && trimmedSearchText.isEmpty {
            tempPredicate = nil
        } else if predicateTagList.isEmpty {
            tempPredicate = #Predicate<Item> { item in
                item.title.localizedStandardContains(trimmedSearchText)
            }
        } else if searchText.isEmpty {
            let selectedTagNames = predicateTagList.map { $0.name }
            tempPredicate = #Predicate<Item> { item in
                item.tags?.contains { tag in
                    selectedTagNames.contains(tag.name)
                } == true
            }
        } else {
            let selectedTagNames = predicateTagList.map { $0.name }
            tempPredicate = #Predicate<Item> { item in
                item.tags?.contains { tag in
                    selectedTagNames.contains(tag.name)
                } == true
                && item.title.localizedStandardContains(trimmedSearchText)
            }
        }
        
        predicate = tempPredicate
    }
    
    private func animateSortChanges() {
        var indexPathsToUpdate: [IndexPath] = []
        for index in items.indices {
            indexPathsToUpdate.append(IndexPath(row: index, section: 0))
        }
        
        loadItemsFromContext()
        mainListView.listView.reloadRows(at: indexPathsToUpdate, with: .automatic)
    }
    
    private func animateFilterChanges() {
        let oldItems = items
        loadItemsFromContext()
        
        let oldCount = oldItems.count
        let newCount = items.count
        
        mainListView.listView.performBatchUpdates {
            if newCount < oldCount {
                var indexPathsToDelete: [IndexPath] = []
                for i in 0..<oldCount {
                    let oldItem = oldItems[i]
                    if !items.contains(where: { $0.id == oldItem.id }) {
                        indexPathsToDelete.append(IndexPath(row: i, section: 0))
                    }
                }
                if !indexPathsToDelete.isEmpty {
                    mainListView.listView.deleteRows(at: indexPathsToDelete, with: .fade)
                }
            } else if newCount > oldCount {
                var indexPathsToInsert: [IndexPath] = []
                for i in 0..<newCount {
                    let newItem = items[i]
                    if !oldItems.contains(where: { $0.id == newItem.id }) {
                        indexPathsToInsert.append(IndexPath(row: i, section: 0))
                    }
                }
                if !indexPathsToInsert.isEmpty {
                    mainListView.listView.insertRows(at: indexPathsToInsert, with: .fade)
                }
            }
            // If counts are equal but items changed, we need a more complex diff
            else if oldCount == newCount {
                // Check if the items are actually different
                let itemsChanged = !zip(oldItems, items).allSatisfy { $0.id == $1.id }
                if itemsChanged {
                    // Fallback to reload data for complex changes
                    mainListView.listView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Setup Functions
    func setupOrderByButton() {
        let byTitle = UIAction(title: "Título", selectedImage: UIImage(systemName: "arrow.down")) { [weak self] action in
            self?.sortOrder = [
                SortDescriptor(\Item.title, order: .forward),
                SortDescriptor(\Item.irritationLevel, order: .forward),
                SortDescriptor(\Item.createdDate, order: .forward),
            ]
        }
        let byIrritation = UIAction(title: "Irritação", selectedImage: UIImage(systemName: "arrow.down")) { [weak self] action in
            self?.sortOrder = [
                SortDescriptor(\Item.irritationLevel, order: .forward),
                SortDescriptor(\Item.title, order: .forward),
                SortDescriptor(\Item.createdDate, order: .forward),
            ]
        }
        let byCreationDate = UIAction(title: "Date", selectedImage: UIImage(systemName: "arrow.down")) { [weak self] action in
            self?.sortOrder = [
                SortDescriptor(\Item.createdDate, order: .forward),
                SortDescriptor(\Item.title, order: .forward),
                SortDescriptor(\Item.irritationLevel, order: .forward),
            ]
        }
        let menu = UIMenu(title: "Ordenamento", options: .singleSelection, children: [byTitle, byIrritation, byCreationDate])
        mainListView.orderByButton.menu = menu
        mainListView.orderByButton.showsMenuAsPrimaryAction = true
    }
    
    func setupFilterButton() {
        let clearFilter = UIAction(title: "Limpar filtro", image: UIImage(systemName: "line.3.horizontal")) { [weak self] _ in
            self?.searchText = ""
            self?.predicateTagList.removeAll()
            for button in self?.tagButtons ?? [] {
                button.isTagSelected = false
            }
        }
        let menu = UIMenu(title: "Filtros", children: [clearFilter])
        mainListView.filterButton.menu = menu
        mainListView.filterButton.showsMenuAsPrimaryAction = true
    }
    
    func setupUIElements() {
        mainListView.stackView.isHidden = true
        mainListView.contentUnavailableView.isHidden = true
        
        UIView.transition(with: mainListView.contentUnavailableView, duration: 0.5, options: .transitionCrossDissolve) { [weak self] in
            let itemsTotal: [Item] = (try? self?.container?.mainContext.fetch(FetchDescriptor<Item>())) ?? []
            
            if itemsTotal.isEmpty {
                self?.mainListView.stackView.isHidden = true
                self?.mainListView.contentUnavailableView.isHidden = false
            } else {
                self?.mainListView.contentUnavailableView.isHidden = true
                self?.mainListView.stackView.isHidden = false
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
    
    // MARK: - Auxiliary functions
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemViewController = ItemViewController(container: container, item: items[indexPath.row], listViewController: self)
        navigationController?.pushViewController(itemViewController, animated: true)
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
        tagButtons.append(button)
        cell.tagButton = button
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let buttonName = tags[indexPath.row].name
        let button = PocasTagButton(type: .medium, tagName: buttonName, isTagSelected: false, isUserInteractionEnabled: true, onButtonPressed: {_ in })
        
        return button.intrinsicContentSize
    }
}

extension MainListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchBar.text ?? ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchText = ""
        searchBar.resignFirstResponder()
    }
}
