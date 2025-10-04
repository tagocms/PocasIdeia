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
    let titleLabel = PocasCustomTitle(type: .name, title: "POCAS IDEIA")
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
    var searchBar: UISearchBar = {
       let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Buscar itens"
        searchBar.returnKeyType = .done
        searchBar.autocorrectionType = .no
        searchBar.autocapitalizationType = .none
        searchBar.barTintColor = .pocasWhite
        searchBar.backgroundImage = UIImage()
        
        return searchBar
    }()
    var orderByButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .plain()
        button.setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
        button.tintColor = .pocasDarkCrimson
        button.configuration?.preferredSymbolConfigurationForImage = .init(font: UIFont.systemFont(ofSize: 24))
        
        return button
    }()
    var filterButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .plain()
        button.setImage(UIImage(systemName: "line.3.horizontal.decrease"), for: .normal)
        button.tintColor = .pocasDarkCrimson
        button.configuration?.preferredSymbolConfigurationForImage = .init(font: UIFont.systemFont(ofSize: 24))
        
        return button
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
        titleLabel.textColor = .pocasDarkCrimson
        
        stackView.addSubview(tagsCollectionView)
        stackView.addSubview(listView)
        stackView.addSubview(searchBar)
        stackView.addSubview(titleLabel)
        
        stackView.addSubview(orderByButton)
        stackView.addSubview(filterButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: stackView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            searchBar.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: orderByButton.leadingAnchor, constant: -4),
            
            filterButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -10),
            filterButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            filterButton.widthAnchor.constraint(equalToConstant: filterButton.imageView?.intrinsicContentSize.width ?? 0),
            
            orderByButton.trailingAnchor.constraint(equalTo: filterButton.leadingAnchor, constant: -4),
            orderByButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            orderByButton.widthAnchor.constraint(equalToConstant: orderByButton.imageView?.intrinsicContentSize.width ?? 0),

            
            tagsCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            tagsCollectionView.heightAnchor.constraint(equalToConstant: 36),
            tagsCollectionView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 10),
            tagsCollectionView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            listView.topAnchor.constraint(equalTo: tagsCollectionView.bottomAnchor, constant: 10),
            listView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            listView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 10),
            listView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -10),
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
