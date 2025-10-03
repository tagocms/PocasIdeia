//
//  MainListView.swift
//  Nano03
//
//  Created by Tiago Camargo Maciel dos Santos on 02/10/25.
//

import UIKit

class MainListView: UIView {
    
    // MARK: - UI Elements
    let tagCollectionView = PocasTagCollectionView()
    let imageCollectionView = PocasImageCollectionView()
    let newItemButton = PocasNewItemButton()
    let pocasTagButton = PocasTagButton(type: .medium, tagName: "Title", isUserInteractionEnabled: false, onButtonPressed: {_ in})
    let titleNameView = PocasCustomTitle(type: .name, title: "POCAS IDEIA")
    let largeTitleInputField = PocasTitleTextField(placeholderText: "O que te irritou...")
    let largeTitleView = PocasCustomTitle(type: .large, title: "Coisa Ruim")
    let mediumTitleView = PocasCustomTitle(type: .medium, title: "Coisa Ruim")
    let smallTitleView = PocasCustomTitle(type: .small, title: "Coisa Ruim")
    let inputViewTest = PocasLabelInputView(type: .photo, labelText: "Test", imageSystemName: "plus")
    private(set) lazy var customButton = PocasCustomButton(
        type: .primary,
        text: "Salvar o item",
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
        addSubview(tagCollectionView)
        addSubview(imageCollectionView)
        addSubview(newItemButton)
        addSubview(pocasTagButton)
        addSubview(titleNameView)
        addSubview(largeTitleInputField)
        addSubview(largeTitleView)
        addSubview(mediumTitleView)
        addSubview(smallTitleView)
        addSubview(inputViewTest)

        addSubview(customButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tagCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tagCollectionView.heightAnchor.constraint(equalToConstant: 50),
            tagCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tagCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            imageCollectionView.topAnchor.constraint(equalTo: tagCollectionView.bottomAnchor),
            imageCollectionView.heightAnchor.constraint(equalToConstant: 50),
            imageCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            pocasTagButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            pocasTagButton.bottomAnchor.constraint(equalTo: largeTitleInputField.topAnchor, constant: -12),
            
            largeTitleInputField.centerXAnchor.constraint(equalTo: centerXAnchor),
            largeTitleInputField.bottomAnchor.constraint(equalTo: newItemButton.topAnchor, constant: -12),
            
            newItemButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            newItemButton.bottomAnchor.constraint(equalTo: titleNameView.topAnchor, constant: -12),
            
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
