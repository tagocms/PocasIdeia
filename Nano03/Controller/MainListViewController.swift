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
        
        mainListView.tagCollectionView.dataSource = self
        mainListView.tagCollectionView.delegate = self
    }

}


extension MainListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PocasTagCollectionViewCell.identifier, for: indexPath) as? PocasTagCollectionViewCell else {
            fatalError("Unable to dequeue reusable cell for Tag.")
        }
        let button = PocasTagButton(type: .medium, tagName: "Title \(indexPath.row)", onButtonPressed: {_ in })
        cell.tagButton = button
        return cell
    }
}

extension MainListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let button = PocasTagButton(type: .medium, tagName: "Title \(indexPath.row)", onButtonPressed: { _ in })
        let buttonSize = button.intrinsicContentSize
        return CGSize(width: buttonSize.width, height: buttonSize.height)
    }
}
