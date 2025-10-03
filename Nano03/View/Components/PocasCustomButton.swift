//
//  PocasCustomButton.swift
//  Nano03
//
//  Created by Tiago Camargo Maciel dos Santos on 02/10/25.
//

import UIKit

class PocasCustomButton: UIButton {

    // MARK: - Initializers
    init(type: CustomButtonType, text: String, systemName: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        switch type {
        case .primary:
            configuration = .filled()
            tintColor = .pocasWhite
            configuration?.baseBackgroundColor = .pocasLightCrimson
            configuration?.background.cornerRadius = 12
        case .secondary:
            configuration = .plain()
            tintColor = .pocasLightCrimson
        case .destructive:
            configuration = .plain()
            tintColor = .systemRed
        }
        
        configuration?.image = UIImage(systemName: systemName)
        configuration?.imagePadding = 4
        configuration?.preferredSymbolConfigurationForImage = .init(font: UIFont.systemFont(ofSize: 17))
        
        // Altering the text's font using UIConfigurationTextAttributesTransformer
        let titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 17)
            return outgoing
        }
        
        configuration?.titleTextAttributesTransformer = titleTextAttributesTransformer
        configuration?.title = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setting up the type of the custom button
enum CustomButtonType {
    case primary, secondary, destructive
}
