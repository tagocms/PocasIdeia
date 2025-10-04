//
//  MainListView.swift
//  Nano03
//
//  Created by Tiago Camargo Maciel dos Santos on 02/10/25.
//

import UIKit

class MainListView: UIView {
    
    // MARK: - UI Elements
    let listView = PocasTableView()
    let newItemButton = PocasNewItemButton()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .pocasWhite
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        addSubview(listView)
        addSubview(newItemButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            listView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            listView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            listView.leadingAnchor.constraint(equalTo: leadingAnchor),
            listView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            newItemButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            newItemButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }
    
}
