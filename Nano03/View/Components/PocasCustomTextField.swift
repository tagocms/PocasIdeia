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
    init(placeholderText: String) {
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
        clearButtonMode = .whileEditing
        returnKeyType = .done
        font = .systemFont(ofSize: 17)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup
    private func insetBounds(_ bounds: CGRect) -> CGRect {
        return bounds.inset(by: edgeInsets)
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: insetBounds(bounds))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return super.editingRect(forBounds: insetBounds(bounds))
    }
}
