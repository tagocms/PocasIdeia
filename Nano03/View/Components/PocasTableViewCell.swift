//
//  PocasTableViewCell.swift
//  Nano03
//
//  Created by Tiago Camargo Maciel dos Santos on 03/10/25.
//

import UIKit

class PocasTableViewCell: UITableViewCell {
    static let identifier = "TableCell"
    
    // MARK: - UI Elements
    let customImageView: UIImageView = {
        let customImageView = UIImageView()
        customImageView.translatesAutoresizingMaskIntoConstraints = false
        
        return customImageView
    }()
    let customLabel = PocasCustomTitle(type: .small, title: "")
    let tagsCollection = PocasTagCollectionView()
    
    // MARK: - Initializers
    init() {
        super.init(style: .default, reuseIdentifier: Self.identifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    func setupUI() {
        addSubview(customImageView)
        addSubview(customLabel)
        addSubview(tagsCollection)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            customImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            customImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            customImageView.heightAnchor.constraint(equalToConstant: 60),
            customImageView.widthAnchor.constraint(equalTo: customImageView.heightAnchor),
            
            customLabel.leadingAnchor.constraint(equalTo: customImageView.trailingAnchor, constant: 10),
            customLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            customLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.5),
            
            tagsCollection.leadingAnchor.constraint(equalTo: customLabel.leadingAnchor),
            tagsCollection.trailingAnchor.constraint(equalTo: customLabel.trailingAnchor),
            tagsCollection.topAnchor.constraint(equalTo: customLabel.bottomAnchor, constant: 4),
            tagsCollection.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.5),
        ])
    }

}
