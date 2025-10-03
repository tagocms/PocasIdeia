//
//  PocasNewItemButton.swift
//  Nano03
//
//  Created by Tiago Camargo Maciel dos Santos on 02/10/25.
//

import UIKit

class PocasNewItemButton: UIButton {
    // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        configuration = .filled()
        
        setImage(UIImage(systemName: "plus"), for: .normal)
        imageView?.tintColor = .pocasWhite
        setPreferredSymbolConfiguration(.init(pointSize: 40, weight: .regular), forImageIn: .normal)
        
        widthAnchor.constraint(equalToConstant: 64).isActive = true
        heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        configuration?.baseBackgroundColor = .pocasDarkCrimson
        configuration?.cornerStyle = .fixed
        configuration?.background.cornerRadius = 32
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
