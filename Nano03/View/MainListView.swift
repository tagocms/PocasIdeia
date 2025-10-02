//
//  MainListView.swift
//  Nano03
//
//  Created by Tiago Camargo Maciel dos Santos on 02/10/25.
//

import UIKit

class MainListView: UIView {
    
    // MARK: - UI Elements
    let titleNameView = PocasCustomTitle(type: .name, title: "POCAS IDEIA")
    let largeTitleView = PocasCustomTitle(type: .large, title: "Coisa Ruim")
    let mediumTitleView = PocasCustomTitle(type: .medium, title: "Coisa Ruim")
    let smallTitleView = PocasCustomTitle(type: .small, title: "Coisa Ruim")
    let inputViewTest = PocasCustomTextField(type: .textarea, placeholderText: "Test")
    
    private(set) lazy var customButton = PocasCustomButton(
        type: .primary,
        text: "HDAUIDHAUIWD",
        systemName: "square.and.pencil"
    )

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
        addSubview(titleNameView)
        addSubview(largeTitleView)
        addSubview(mediumTitleView)
        addSubview(smallTitleView)
        addSubview(inputViewTest)

        addSubview(customButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleNameView.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleNameView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            largeTitleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            largeTitleView.topAnchor.constraint(equalTo: titleNameView.bottomAnchor, constant: 12),
            
            mediumTitleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mediumTitleView.topAnchor.constraint(equalTo: largeTitleView.bottomAnchor, constant: 12),
            
            smallTitleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            smallTitleView.topAnchor.constraint(equalTo: mediumTitleView.bottomAnchor, constant: 12),
            
            inputViewTest.centerXAnchor.constraint(equalTo: centerXAnchor),
            inputViewTest.topAnchor.constraint(equalTo: smallTitleView.bottomAnchor, constant: 12),
            inputViewTest.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            
            customButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            customButton.heightAnchor.constraint(equalToConstant: 42),
            customButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            customButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
}
