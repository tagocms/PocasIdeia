//
//  MainListViewController.swift
//  Nano03
//
//  Created by Tiago Camargo Maciel dos Santos on 02/10/25.
//

import UIKit

class MainListViewController: UIViewController {
    let mainListView = MainListView()
    
    override func loadView() {
        super.loadView( )
        view = mainListView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
