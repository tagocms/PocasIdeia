//
//  MainListViewController.swift
//  Nano03
//
//  Created by Tiago Camargo Maciel dos Santos on 02/10/25.
//

import UIKit

class MainListViewController: UIViewController {
    let mainListView = MainListView()
    
    override func loadView() {
        super.loadView( )
        view = mainListView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    
        mainListView.inputViewTest.inputTags?.dataSource = self
        mainListView.inputViewTest.inputTags?.delegate = self
        mainListView.inputViewTest.inputImages?.dataSource = self
        mainListView.inputViewTest.inputImages?.delegate = self
    }

}


extension MainListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mainListView.inputViewTest.inputTags {
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

extension MainListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == mainListView.inputViewTest.inputTags {
            let button = PocasTagButton(type: .medium, tagName: "Title \(indexPath.row)", onButtonPressed: { _ in })
            let buttonSize = button.intrinsicContentSize
            return CGSize(width: buttonSize.width, height: buttonSize.height)
        } else {
            return CGSize(width: 60, height: 60)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        if collectionView != mainListView.inputViewTest.inputTags {
            let contextMenuConfiguration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
                let deleteImageAction = UIAction(title: "Deletar imagem", image: UIImage(systemName: "trash")) { action in
                    // TODO: - Implement the deletion of the image
                }
                return UIMenu(title: "", children: [deleteImageAction])
            }
            return contextMenuConfiguration
        }
        
        return nil
    }
}
