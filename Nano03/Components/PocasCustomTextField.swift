//
//  PocasCustomTextField.swift
//  Nano03
//
//  Created by Tiago Camargo Maciel dos Santos on 02/10/25.
//

import UIKit

class PocasCustomTextField: UITextField {
    var edgeInsets: UIEdgeInsets = .zero
    
    // MARK: - Initializers
    init(type: CustomTextFieldType, placeholderText: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        autocapitalizationType = .none
        keyboardType = .default
        autocorrectionType = .no
        
        textColor = .pocasSuperDarkCrimson
        attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [.foregroundColor: UIColor.pocasSuperLightCrimson])
        
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.pocasSuperDarkCrimson.cgColor
        edgeInsets = .init(vertical: 10, horizontal: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: bounds.insetBy(dx: edgeInsets.left + edgeInsets.right, dy: edgeInsets.top + edgeInsets.bottom))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return super.editingRect(forBounds: bounds.insetBy(dx: edgeInsets.left + edgeInsets.right, dy: edgeInsets.top + edgeInsets.bottom))
    }
}

enum CustomTextFieldType {
    case textarea, small
}
