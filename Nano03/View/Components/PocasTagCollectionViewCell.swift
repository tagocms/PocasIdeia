//
//  PocasTagCollectionViewCell.swift
//  Nano03
//
//  Created by Tiago Camargo Maciel dos Santos on 03/10/25.
//

import UIKit

class PocasTagCollectionViewCell: UICollectionViewCell {
    static let identifier = "TagCell"
    private var hasSetupConstraints = false
    
    var tagButton = PocasTagButton(type: .medium, tagName: "", onButtonPressed: { _ in }) {
        didSet {
            oldValue.removeFromSuperview()
            if !hasSetupConstraints {
                setupUI()
                setupConstraints()
            }
        }
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    func setupUI() {
        addSubview(tagButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tagButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            tagButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            tagButton.topAnchor.constraint(equalTo: topAnchor),
            tagButton.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
