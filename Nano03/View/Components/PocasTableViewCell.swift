//
//  PocasTableViewCell.swift
//  Nano03
//
//  Created by Tiago Camargo Maciel dos Santos on 03/10/25.
//

import UIKit

class PocasTableViewCell: UITableViewCell {
    static let identifier = "TableCell"
    var tags: [String] = []
    
    // MARK: - UI Elements
    let customImageView: UIImageView = {
        let customImageView = UIImageView()
        customImageView.translatesAutoresizingMaskIntoConstraints = false
        
        return customImageView
    }()
    let customLabel = PocasCustomTitle(type: .small, title: "")
    let tagsCollection = PocasTagCollectionView()
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 4
        
        return stackView
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
        
        tagsCollection.delegate = self
        tagsCollection.dataSource = self
        
        backgroundColor = .pocasWhite
        layer.borderColor = UIColor.pocasSuperDarkCrimson.withAlphaComponent(0.1).cgColor
        layer.borderWidth = 0.5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    func setupUI() {
        addSubview(customImageView)
        stackView.addSubview(customLabel)
        stackView.addSubview(tagsCollection)
        addSubview(stackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            customImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            customImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            customImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            customImageView.widthAnchor.constraint(equalTo: customImageView.heightAnchor),
            
            stackView.centerYAnchor.constraint(equalTo: customImageView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: customImageView.trailingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            stackView.heightAnchor.constraint(equalTo: customImageView.heightAnchor),
            
            customLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            customLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            customLabel.bottomAnchor.constraint(equalTo: stackView.centerYAnchor, constant: -2),
            
            tagsCollection.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            tagsCollection.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            tagsCollection.topAnchor.constraint(equalTo: stackView.centerYAnchor, constant: 2),
            tagsCollection.heightAnchor.constraint(equalToConstant: 21),
        ])
    }
    
    // MARK: - Auxiliary functions
    func configure(with tags: [String], label: String, image: UIImage) {
            self.tags = tags
            customLabel.text = label
            customImageView.image = image
            tagsCollection.reloadData()
        }

}

extension PocasTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PocasTagCollectionViewCell.identifier, for: indexPath) as? PocasTagCollectionViewCell else {
            fatalError("Unable to dequeue reusable cell for Tag.")
        }
        let buttonName = indexPath.row < 3 ? "Title \(indexPath.row)" : "+ \(tags.count - 4)"
        let button = PocasTagButton(type: .small, tagName: buttonName, isTagSelected: true, isUserInteractionEnabled: false, onButtonPressed: {_ in })
        cell.tagButton = button
        return cell
    }
}
