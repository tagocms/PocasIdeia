//
//  PocasCustomTitle.swift
//  Nano03
//
//  Created by Tiago Camargo Maciel dos Santos on 02/10/25.
//

import UIKit

class PocasCustomTitle: UILabel {
    
    // MARK: - Initializers
    init(type: CustomTitleType, title: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        text = title
        textColor = .pocasSuperDarkCrimson
        
        switch type {
        case .name:
            font = UIFont(name: "Anton-Regular", size: 34)
        case .large:
            font = UIFont.boldSystemFont(ofSize: 34)
        case .medium:
            font = UIFont.boldSystemFont(ofSize: 22)
        case .small:
            font = UIFont.boldSystemFont(ofSize: 17)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum CustomTitleType {
    case name, large, medium, small
}
