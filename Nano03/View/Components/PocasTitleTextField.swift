//
//  PocasTitleTextField.swift
//  Nano03
//
//  Created by Tiago Camargo Maciel dos Santos on 03/10/25.
//

import UIKit

class PocasTitleTextField: UITextField {
    var edgeInsets: UIEdgeInsets = .zero
    
    // MARK: - Initializers
    init(placeholderText: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        autocapitalizationType = .none
        keyboardType = .default
        autocorrectionType = .no
        
        textColor = .pocasSuperDarkCrimson
        attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [.foregroundColor: UIColor.pocasLightCrimson.withAlphaComponent(0.5)])

        edgeInsets = .init(vertical: 4, horizontal: 10)
        returnKeyType = .done
        font = .boldSystemFont(ofSize: 34)
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
