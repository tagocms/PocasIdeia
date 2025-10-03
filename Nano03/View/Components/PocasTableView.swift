//
//  PocasTableView.swift
//  Nano03
//
//  Created by Tiago Camargo Maciel dos Santos on 03/10/25.
//

import UIKit

class PocasTableView: UITableView {
    // MARK: - Initializers
    init() {
        super.init(frame: .zero, style: .plain)
        translatesAutoresizingMaskIntoConstraints = false
        register(PocasTableViewCell.self, forCellReuseIdentifier: PocasTableViewCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
