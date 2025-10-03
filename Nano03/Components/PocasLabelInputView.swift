//
//  PocasLabelInputView.swift
//  Nano03
//
//  Created by Tiago Camargo Maciel dos Santos on 02/10/25.
//

import UIKit

class PocasLabelInputView: UIView {
    // MARK: - UI Elements
    private let textLabel: PocasCustomTitle = PocasCustomTitle(type: .medium, title: "")
    private var systemImageButton: UIButton? = nil
    private var inputTextField: PocasCustomTextField? = nil
    private var inputTextView: PocasCustomTextView? = nil
    private var inputImagesButton: PocasCustomButton? = nil
    private var inputImages: PocasImageCollectionView? = nil
    private var inputSlider: UISlider? = nil
    private let type: LabelInputViewType
    
    // MARK: - Initializers
    init(type: LabelInputViewType, labelText: String, placeholderText: String? = nil, imageSystemName: String? = nil) {
        self.type = type
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        textLabel.text = labelText
        
        switch self.type {
        case .textView:
            inputTextView = PocasCustomTextView(placeholderText: placeholderText ?? "...")
        case .textField:
            inputTextField = PocasCustomTextField(placeholderText: placeholderText ?? "Nova etiqueta")
            if let imageSystemName {
                let image = UIImage(systemName: imageSystemName)
                systemImageButton = UIButton()
                systemImageButton?.setImage(image, for: .normal)
                systemImageButton?.imageView?.tintColor = .pocasDarkCrimson
                systemImageButton?.setPreferredSymbolConfiguration(.init(pointSize: 24, weight: .regular), forImageIn: .normal)
                systemImageButton?.translatesAutoresizingMaskIntoConstraints = false
            }
        case .photo:
            inputImagesButton = PocasCustomButton(type: .secondary, text: "Adicione uma imagem", systemName: "photo")
            inputImagesButton?.contentHorizontalAlignment = .leading
            // TODO: - Image CollectionView, setup and constraints
        case .slider:
            inputSlider = UISlider()
            inputSlider?.translatesAutoresizingMaskIntoConstraints = false
            
            inputSlider?.minimumValueImage = UIImage(resource: .flame1).alpha(0.5)
            inputSlider?.minimumValue = 1
            
            
            inputSlider?.maximumValueImage = UIImage(resource: .flame3).alpha(0.5)
            inputSlider?.maximumValue = 3
            inputSlider?.tintColor = .pocasCrimson
        case .tags:
            // TODO: - Tag CollectionView, setup and constraints
            break
        }
        
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        addSubview(textLabel)
        
        if let inputTextView {
            addSubview(inputTextView)
        }
        if let inputTextField {
            addSubview(inputTextField)
        }
        if let systemImageButton {
            addSubview(systemImageButton)
        }
        if let inputImagesButton {
            addSubview(inputImagesButton)
        }
        if let inputSlider {
            addSubview(inputSlider)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
        ])
        
        if let systemImageButton {
            NSLayoutConstraint.activate([
                systemImageButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
                systemImageButton.centerYAnchor.constraint(equalTo: textLabel.centerYAnchor),
            ])
        }
        
        if let inputTextView {
            NSLayoutConstraint.activate([
                inputTextView.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor),
                inputTextView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 10),
                inputTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
                inputTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
                ])
        }
        
        if let inputTextField {
            NSLayoutConstraint.activate([
                inputTextField.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor),
                inputTextField.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 10),
                inputTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
                inputTextField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
                ])
        }
        
        if let inputImagesButton {
            NSLayoutConstraint.activate([
                inputImagesButton.leadingAnchor.constraint(equalTo: leadingAnchor),
                inputImagesButton.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 10),
                inputImagesButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
                inputImagesButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
                ])
        }
        
        if let inputSlider {
            NSLayoutConstraint.activate([
                inputSlider.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor),
                inputSlider.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 10),
                inputSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
                inputSlider.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
                ])
        }
    }
}

enum LabelInputViewType {
    case textView, textField, photo, slider, tags
}
