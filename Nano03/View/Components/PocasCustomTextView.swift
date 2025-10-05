//
//  PocasCustomTextView.swift
//  Nano03
//
//  Created by Tiago Camargo Maciel dos Santos on 02/10/25.
//

import UIKit

class PocasCustomTextView: UITextView {
    var edgeInsets: UIEdgeInsets = .zero
    
    // MARK: - Initializers
    init(placeholderText: String) {
        super.init(frame: .zero, textContainer: nil)
        translatesAutoresizingMaskIntoConstraints = false
        
        autocapitalizationType = .none
        keyboardType = .default
        autocorrectionType = .no
        text = placeholderText
        
        textColor = .pocasSuperDarkCrimson
        backgroundColor = .systemBackground
        layer.cornerRadius = 12
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.pocasSuperDarkCrimson.cgColor
        edgeInsets = .init(vertical: 10, horizontal: 10)
        font = .systemFont(ofSize: 17)
        
        textContainerInset = edgeInsets
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup
    private func insetBounds(_ bounds: CGRect) -> CGRect {
        return bounds.inset(by: edgeInsets)
    }
}
