//
//  PocasTagButton.swift
//  Nano03
//
//  Created by Tiago Camargo Maciel dos Santos on 02/10/25.
//

import UIKit

class PocasTagButton: UIButton {
    let tagName: String
    var isTagSelected: Bool {
        didSet {
            updateButtonAppearance()
        }
    }
    let onButtonPressed: (PocasTagButton) -> Void
    let type: TagButtonType
    
    // MARK: - Initializers
    init(type: TagButtonType, tagName: String, isTagSelected: Bool = false, isUserInteractionEnabled: Bool = true, onButtonPressed: @escaping (PocasTagButton) -> Void) {
        self.tagName = tagName
        self.isTagSelected = isTagSelected
        self.onButtonPressed = onButtonPressed
        self.type = type
        super.init(frame: .zero)
        self.isUserInteractionEnabled = isUserInteractionEnabled
        translatesAutoresizingMaskIntoConstraints = false
        
        configuration = .filled()
        setTitle(tagName, for: .normal)
        
        configuration?.baseBackgroundColor = isTagSelected ? .pocasCrimson : .pocasLightCrimson
        configuration?.cornerStyle = .fixed
        
        configuration?.contentInsets = .init(top: 4, leading: 8, bottom: 4, trailing: 8)
        
        configuration?.titleTextAttributesTransformer = .init { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: type == .small ? 11 : 15)
            return outgoing
        }
        
        switch type {
        case .small:
            configuration?.background.cornerRadius = 24
        case .medium:
            configuration?.background.cornerRadius = 24
        case .irritation:
            configuration?.background.cornerRadius = 4
            configuration?.baseBackgroundColor = .pocasDarkCrimson
        case .logic:
            configuration?.background.cornerRadius = 4
        case .add:
            configuration?.background.cornerRadius = 24
            configuration?.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
            configuration?.baseBackgroundColor = .pocasSuperDarkCrimson
            setTitle(nil, for: .normal)
            setImage(UIImage(systemName: "plus"), for: .normal)
            configuration?.image?.withTintColor(.pocasWhite)
        }
        
        addTarget(self, action: #selector(didPressButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Update UI
    private func updateButtonAppearance() {
        if type != .add {
            if isTagSelected {
                configuration?.baseBackgroundColor = .pocasCrimson
            } else {
                configuration?.baseBackgroundColor = .pocasLightCrimson
            }
        }
    }
    
    // MARK: - Action function
    @objc func didPressButton() {
        onButtonPressed(self)
        isTagSelected.toggle()
    }
    
}

enum TagButtonType {
    case small, medium, irritation, logic, add
}
