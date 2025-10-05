//
//  PocasLabelInputView.swift
//  Nano03
//
//  Created by Tiago Camargo Maciel dos Santos on 02/10/25.
//

import UIKit

class PocasLabelInputView: UIView {
    // MARK: Constants
    struct Constants {
        static let horizontalPadding: CGFloat = 10
        static let verticalPadding: CGFloat = 4
        static let verticalSpacing: CGFloat = 10
        static let verticalSpacingBetweenElements: CGFloat = 4
        
    }
    
    // MARK: - UI Elements
    private let textLabel: PocasCustomTitle = PocasCustomTitle(type: .medium, title: "")
    private let type: LabelInputViewType
    
    private(set) var systemImageButton: UIButton? = nil
    private(set) var inputTextField: PocasCustomTextField? = nil
    private(set) var inputTextView: PocasCustomTextView? = nil
    private(set) var inputImagesButton: PocasCustomButton? = nil
    private(set) var inputImages: PocasImageCollectionView? = nil
    private(set) var inputSlider: UISlider? = nil
    private(set) var inputTags: PocasTagCollectionView? = nil
    
    
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
        case .images:
            inputImagesButton = PocasCustomButton(type: .secondary, text: "Adicione uma imagem", systemName: "photo")
            inputImagesButton?.contentHorizontalAlignment = .leading
            
            inputImages = PocasImageCollectionView()
        case .slider:
            inputSlider = UISlider()
            inputSlider?.translatesAutoresizingMaskIntoConstraints = false
            
            inputSlider?.minimumValueImage = UIImage(resource: .flame1).alpha(0.5)
            inputSlider?.minimumValue = 1
            
            
            inputSlider?.maximumValueImage = UIImage(resource: .flame3).alpha(0.5)
            inputSlider?.maximumValue = 3
            inputSlider?.tintColor = .pocasCrimson
        case .tags:
            inputTags = PocasTagCollectionView()
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
        if let inputImages {
            addSubview(inputImages)
        }
        if let inputSlider {
            addSubview(inputSlider)
        }
        if let inputTags {
            addSubview(inputTags)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding),
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.verticalPadding),
            textLabel.heightAnchor.constraint(equalToConstant: textLabel.intrinsicContentSize.height)
        ])
        
        if let systemImageButton {
            NSLayoutConstraint.activate([
                systemImageButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding),
                systemImageButton.centerYAnchor.constraint(equalTo: textLabel.centerYAnchor),
            ])
        }
        
        if let inputTextView {
            NSLayoutConstraint.activate([
                inputTextView.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor),
                inputTextView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: Constants.verticalSpacing),
                inputTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding),
                inputTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.verticalPadding),
                inputTextView.heightAnchor.constraint(equalToConstant: 100),
                ])
        }
        
        if let inputTextField {
            NSLayoutConstraint.activate([
                inputTextField.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor),
                inputTextField.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: Constants.verticalSpacing),
                inputTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
                inputTextField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.verticalPadding),
                ])
        }
        
        if let inputImagesButton, let inputImages {
            NSLayoutConstraint.activate([
                inputImagesButton.leadingAnchor.constraint(equalTo: leadingAnchor),
                inputImagesButton.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: Constants.verticalSpacing),
                inputImagesButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding),
                inputImagesButton.heightAnchor.constraint(equalToConstant: inputImagesButton.intrinsicContentSize.height),
                ])
            
            NSLayoutConstraint.activate([
                inputImages.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor),
                inputImages.topAnchor.constraint(equalTo: inputImagesButton.bottomAnchor, constant: Constants.verticalSpacingBetweenElements),
                inputImages.trailingAnchor.constraint(equalTo: inputImagesButton.trailingAnchor),
                inputImages.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.verticalPadding),
                inputImages.heightAnchor.constraint(equalToConstant: 140),
                ])
        }
        
        if let inputSlider {
            NSLayoutConstraint.activate([
                inputSlider.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor),
                inputSlider.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: Constants.verticalSpacing),
                inputSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding),
                inputSlider.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.verticalPadding),
                ])
        }
        
        if let inputTags {
            NSLayoutConstraint.activate([
                inputTags.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor),
                inputTags.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: Constants.verticalSpacing),
                inputTags.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding),
                inputTags.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.verticalPadding)
                ])
        }
    }
}

enum LabelInputViewType {
    case textView, textField, images, slider, tags
}
