//
//  MainListView.swift
//  Nano03
//
//  Created by Tiago Camargo Maciel dos Santos on 02/10/25.
//

import UIKit

class MainListView: UIView {
    
    // MARK: - UI Elements
    let listView = PocasTableView()
    let tagsCollectionView = PocasTagCollectionView()
    let newItemButton = PocasNewItemButton()
    var contentUnavailableView: UIContentUnavailableView = {
        let view = UIContentUnavailableView(configuration: .empty())
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        
        return stackView
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .pocasWhite
        
        setupStackView()
        setupContentUnavailableView(for: contentUnavailableView)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        addSubview(stackView)
        addSubview(newItemButton)
        addSubview(contentUnavailableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
        ])
        
        NSLayoutConstraint.activate([
            contentUnavailableView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentUnavailableView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            contentUnavailableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            contentUnavailableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
        ])
        
        NSLayoutConstraint.activate([
            newItemButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            newItemButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }
    
    // MARK: - Auxiliary setup functions
    private func setupStackView() {
        stackView.addSubview(tagsCollectionView)
        stackView.addSubview(listView)
        
        NSLayoutConstraint.activate([
            tagsCollectionView.topAnchor.constraint(equalTo: stackView.topAnchor),
            tagsCollectionView.heightAnchor.constraint(equalToConstant: 36),
            tagsCollectionView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            tagsCollectionView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            listView.topAnchor.constraint(equalTo: tagsCollectionView.bottomAnchor, constant: 10),
            listView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            listView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            listView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
        ])
    }
    
    private func setupContentUnavailableView(for view: UIContentUnavailableView) {
        let title = PocasCustomTitle(type: .medium, title: "Você ainda não se irritou com nada!")
        title.textAlignment = .center
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Clique no botão circular abaixo para adicionar um novo item."
        label.textColor = .pocasSuperDarkCrimson
        label.numberOfLines = 0
        label.textAlignment = .center
        
        let imageView = UIImageView(image: UIImage(systemName: "exclamationmark.square"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .pocasSuperDarkCrimson
        imageView.contentMode = .scaleAspectFill
        
        view.addSubview(title)
        view.addSubview(label)
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            title.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            title.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 4),
            label.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.bottomAnchor.constraint(equalTo: title.topAnchor, constant: -4),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120),
        ])
    }
    
}
