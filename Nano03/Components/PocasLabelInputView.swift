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
    private var systemImageView: UIImageView? = nil
    private var inputTextField: UITextField? = nil
    private var inputImageButton: PocasCustomButton? = nil
    private var inputSlider: UISlider? = nil
    
    // MARK: - Initializers
    init(type: LabelInputViewType, labelText: String, imageSystemName: String? = nil) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        textLabel.text = labelText
        
        if let imageSystemName {
            systemImageView = UIImageView(image: UIImage(systemName: imageSystemName))
            systemImageView?.contentMode = .scaleAspectFit
            systemImageView?.preferredSymbolConfiguration = .init(pointSize: 24, weight: .regular)
        }
        
        switch type {
        case .text:
            inputTextField = UITextField()
        case .photo:
            break
        case .slider:
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
        //
    }
    
    private func setupConstraints() {
        //
    }
}

enum LabelInputViewType {
    case text, photo, slider
}
