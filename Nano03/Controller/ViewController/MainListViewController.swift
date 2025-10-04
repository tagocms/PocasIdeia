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
    var container: ModelContainer?
    var items: [Item] = []
    
    // MARK: - Initializers
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView( )
        view = mainListView
        
        mainListView.listView.delegate = self
        mainListView.listView.dataSource = self
        
        mainListView.newItemButton.onButtonPressed = createNewItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        container = try? ModelContainer(for: Item.self)
        loadItemsFromContext()
        mainListView.listView.reloadData()
    }
    
    // MARK: - Data functions
    func loadItemsFromContext() {
        var descriptor = FetchDescriptor<Item>()
        descriptor.sortBy = [SortDescriptor(\Item.title, order: .forward)]
        items = (try? container?.mainContext.fetch(descriptor)) ?? []
    }
    
    // MARK: - Intent functions
    func createNewItem() {
        let item1 = Item(id: UUID(), title: "Test1", irritationLevel: 2, summary: "lalalalla", images: [], tags: [Tag(id: UUID(), name: "Test1"), Tag(id: UUID(), name: "Test2"), Tag(id: UUID(), name: "Test3"), Tag(id: UUID(), name: "Test4"), Tag(id: UUID(), name: "Test5")], createdDate: Date.now)
        let item2 = Item(id: UUID(), title: "Test2", irritationLevel: 1, summary: "lalalalla", images: [], tags: [Tag(id: UUID(), name: "Test1"), Tag(id: UUID(), name: "Test2"), Tag(id: UUID(), name: "Test3"), Tag(id: UUID(), name: "Test4"), Tag(id: UUID(), name: "Test5")], createdDate: Date.now)
        let item3 = Item(id: UUID(), title: "Test3", irritationLevel: 3, summary: "lalalalla", images: [], tags: [Tag(id: UUID(), name: "Test1"), Tag(id: UUID(), name: "Test2"), Tag(id: UUID(), name: "Test3"), Tag(id: UUID(), name: "Test4"), Tag(id: UUID(), name: "Test5")], createdDate: Date.now)
        
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
            // TODO: - Implement row deletion logic
            let item = self?.items[indexPath.row]
            if let item {
                self?.container?.mainContext.delete(item)
                self?.items.remove(at: indexPath.row)
                self?.mainListView.listView.deleteRows(at: [indexPath], with: .left)
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
                // TODO: - Implement row deletion logic
                let item = self?.items[indexPath.row]
                if let item {
                    self?.container?.mainContext.delete(item)
                    self?.items.remove(at: indexPath.row)
                    self?.mainListView.listView.deleteRows(at: [indexPath], with: .left)
                }
            }
            return UIMenu(title: "", children: [deleteAction])
        }
        return configuration
    }
}
