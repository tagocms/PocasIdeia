//
//  MainListViewController.swift
//  Nano03
//
//  Created by Tiago Camargo Maciel dos Santos on 02/10/25.
//

import UIKit

class MainListViewController: UIViewController {
    let mainListView = MainListView()
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView( )
        view = mainListView
        
        mainListView.listView.delegate = self
        mainListView.listView.dataSource = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

extension MainListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PocasTableViewCell.identifier) as? PocasTableViewCell else {
            fatalError("Unable to dequeue PocasTableViewCell")
        }
        
        let tags = ["tag1", "tag2", "tag3", "tag4", "tag5", "tag6", "tag7", "tag8", "tag9", "tag10", "tag11", "tag12", "tag13", "tag14", "tag15"]
        cell.configure(with: tags, label: "Custom Label \(indexPath.row)", image: UIImage(resource: .flame3))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, completion in
            // TODO: - Implement row deletion logic
            
            completion(true)
        }
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash")
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return configuration
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let deleteAction = UIAction(title: "Excluir item", image: UIImage(systemName: "trash"), attributes: [.destructive]) { action in
                // TODO: - Implement row deletion logic
            }
            return UIMenu(title: "", children: [deleteAction])
        }
        return configuration
    }
}
