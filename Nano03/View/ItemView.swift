//
//  ItemView.swift
//  Nano03
//
//  Created by Tiago Camargo Maciel dos Santos on 03/10/25.
//

import UIKit

class ItemView: UIView {
    // MARK: - Properties
    let itemViewType: ItemViewType
    
    // MARK: - UI Elements
    let largeTitleInputField = PocasTitleTextField(placeholderText: "O que te irritou...")
    let irritationSelection = PocasLabelInputView(type: .slider, labelText: "O quanto te irrita")
    let summaryInput = PocasLabelInputView(type: .textView, labelText: "O porquê te irrita")
    let imageSelection = PocasLabelInputView(type: .images, labelText: "Imagens do que te irrita")
    let tagSelection = PocasLabelInputView(type: .tags, labelText: "Etiquetas")
    let saveItemButton = PocasCustomButton(type: .primary, text: "Salvar o item", systemName: "square.and.pencil")
    let deleteItemButton = PocasCustomButton(type: .destructive, text: "Excluir o item", systemName: "trash")
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fill
        return stackView
    }()
    
    // MARK: - Callbacks
    var onSliderChanged: () -> Void = { }

    // MARK: - Initializers
    init(itemViewType: ItemViewType) {
        self.itemViewType = itemViewType
        super.init(frame: .zero)
        
        backgroundColor = .pocasWhite
        
        irritationSelection.inputSlider?.addTarget(self, action: #selector(didChangeSlider), for: .valueChanged)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        addSubview(stackView)
        stackView.addArrangedSubview(largeTitleInputField)
        stackView.addArrangedSubview(irritationSelection)
        stackView.addArrangedSubview(summaryInput)
        stackView.addArrangedSubview(imageSelection)
        stackView.addArrangedSubview(tagSelection)
        
        tagSelection.setContentHuggingPriority(.required, for: .vertical)
        tagSelection.setContentCompressionResistancePriority(.required, for: .vertical)
        
        let tagsLayout = tagSelection.inputTags?.collectionViewLayout as? UICollectionViewFlowLayout
        tagsLayout?.scrollDirection = .vertical
        
        addSubview(saveItemButton)
        if itemViewType == .edit {
            addSubview(deleteItemButton)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: saveItemButton.topAnchor, constant: -12),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
        ])
        
        if itemViewType == .new {
            NSLayoutConstraint.activate([
                saveItemButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
                saveItemButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
                saveItemButton.heightAnchor.constraint(equalToConstant: 42),
                saveItemButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                saveItemButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -12),
            ])
        } else {
            NSLayoutConstraint.activate([
                saveItemButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
                saveItemButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
                saveItemButton.heightAnchor.constraint(equalToConstant: 42),
                saveItemButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                saveItemButton.bottomAnchor.constraint(equalTo: deleteItemButton.topAnchor, constant: -12),
                
                deleteItemButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
                deleteItemButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
                deleteItemButton.heightAnchor.constraint(equalToConstant: 42),
                deleteItemButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                deleteItemButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -12),
            ])
        }
    }
    
    // MARK: - Selectors
    @objc func didChangeSlider() {
        onSliderChanged()
    }
}

enum ItemViewType {
    case new, edit
}
