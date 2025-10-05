//
//  ItemView.swift
//  Nano03
//
//  Created by Tiago Camargo Maciel dos Santos on 03/10/25.
//

import UIKit

class ItemView: UIView {
    // MARK: - UI Elements
    let largeTitleInputField = PocasTitleTextField(placeholderText: "O que te irritou...")
    let irritationSelection = PocasLabelInputView(type: .slider, labelText: "O quanto te irrita")
    let summaryInput = PocasLabelInputView(type: .textView, labelText: "O porquê te irrita")
    let imageSelection = PocasLabelInputView(type: .images, labelText: "Imagens do que te irrita")
    let tagSelection = PocasLabelInputView(type: .tags, labelText: "Etiquetas")
    let saveItemButton = PocasCustomButton(type: .primary, text: "Salvar o item", systemName: "square.and.pencil")
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
    override init(frame: CGRect) {
        super.init(frame: frame)
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
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: saveItemButton.topAnchor, constant: -12),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            saveItemButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            saveItemButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            saveItemButton.heightAnchor.constraint(equalToConstant: 42),
            saveItemButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            saveItemButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -12),
        ])
    }
    
    // MARK: - Selectors
    @objc func didChangeSlider() {
        onSliderChanged()
    }
}
