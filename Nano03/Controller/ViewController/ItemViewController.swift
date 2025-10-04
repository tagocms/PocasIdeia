//
//  ItemViewController.swift
//  Nano03
//
//  Created by Tiago Camargo Maciel dos Santos on 03/10/25.
//

import UIKit

class ItemViewController: UIViewController {
    let itemView = ItemView()

    // MARK: - Lifecycle
    override func loadView() {
        super.loadView( )
        view = itemView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension ItemViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == itemView.inputViewTest.inputTags {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PocasTagCollectionViewCell.identifier, for: indexPath) as? PocasTagCollectionViewCell else {
                fatalError("Unable to dequeue reusable cell for Tag.")
            }
            let button = PocasTagButton(type: .medium, tagName: "Title \(indexPath.row)", onButtonPressed: {_ in })
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
        if collectionView == itemView.inputViewTest.inputTags {
            let button = PocasTagButton(type: .medium, tagName: "Title \(indexPath.row)", onButtonPressed: { _ in })
            let buttonSize = button.intrinsicContentSize
            return CGSize(width: buttonSize.width, height: buttonSize.height)
        } else {
            return CGSize(width: 60, height: 60)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        if collectionView != itemView.inputViewTest.inputTags {
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
