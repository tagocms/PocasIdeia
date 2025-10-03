//
//  PocasTableViewCell.swift
//  Nano03
//
//  Created by Tiago Camargo Maciel dos Santos on 03/10/25.
//

import UIKit

class PocasTableViewCell: UITableViewCell {
    static let identifier = "TableCell"
    
    // MARK: - Initializers
    init() {
        super.init(style: .default, reuseIdentifier: Self.identifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    func setupUI() {
        //
    }
    
    func setupConstraints() {
        //
    }

}
