//
//  TagCreationViewController.swift
//  Nano03
//
//  Created by Tiago Camargo Maciel dos Santos on 05/10/25.
//

import UIKit
import SwiftData

class TagCreationViewController: UIViewController {
    // MARK: - Properties
    let container: ModelContainer?
    let itemViewController: ItemViewController?
    let alertViewController: UIAlertController = {
        let alertController = UIAlertController(title: "Etiqueta inválida", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel) { _ in
            alertController.dismiss(animated: true)
        }
        alertController.addAction(action)
        
        return alertController
    }()
    var totalTags: [Tag] = []
    var tagTitle: String = ""
    
    // MARK: UI Elements
    let inputLabel = PocasLabelInputView(type: .textField, labelText: "Nome da etiqueta", placeholderText: "Nova etiqueta", imageSystemName: "plus")
    let createTagFeedbackLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .pocasSuperDarkCrimson
        
        return label
    }()

    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        view.backgroundColor = .pocasWhite
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        
        inputLabel.inputTextField?.delegate = self
        
        inputLabel.onSystemImageButtonPressed = saveTag
    }
    

    // MARK: - Initializers
    init(container: ModelContainer?, itemViewController: ItemViewController?) {
        self.container = container
        self.itemViewController = itemViewController
        super.init(nibName: nil, bundle: nil)
        
        loadTags()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Data functions
    func loadTags() {
        let descriptor = FetchDescriptor<Tag>()
        totalTags = (try? container?.mainContext.fetch(descriptor)) ?? []
    }
    
    func saveTag() {
        createTagFeedbackLabel.text = ""
        
        guard !tagTitle.isEmpty else {
            alertViewController.message = "Nome da etiqueta não pode ser vazio."
            present(alertViewController, animated: true)
            return
        }
        
        guard !totalTags.contains(where: { $0.name == tagTitle }) else {
            alertViewController.message = "Nome da etiqueta não pode ser igual a outro já existente."
            present(alertViewController, animated: true)
            return
        }
        
        guard tagTitle.count <= 30 else {
            alertViewController.message = "Nome da etiqueta não pode ter mais que 30 caracteres."
            present(alertViewController, animated: true)
            return
        }
        
        let newTag = Tag(name: tagTitle)
        tagTitle = ""
        inputLabel.inputTextField?.text = ""
        container?.mainContext.insert(newTag)
        
        itemViewController?.loadTotalTagsAndReloadCollection { [weak self] in
            if let cellIndex = self?.itemViewController?.totalTags.firstIndex(where: { $0.name == newTag.name }) {
                if let cell = self?.itemViewController?.itemView.tagSelection.inputTags?.cellForItem(at: IndexPath(item: cellIndex, section: 0)) as? PocasTagCollectionViewCell {
                    cell.tagButton.isTagSelected = true
                    self?.itemViewController?.itemSelectedTags.append(newTag)
                }
            }
        }
        
        createTagFeedbackLabel.text = "Etiqueta \"\(newTag.name)\" criada com sucesso!"
        
        try? container?.mainContext.save()
    }
    
    // MARK: - Setup UI
    func setupUI() {
        view.addSubview(inputLabel)
        view.addSubview(createTagFeedbackLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            inputLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            inputLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            inputLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            
            createTagFeedbackLabel.topAnchor.constraint(equalTo: inputLabel.bottomAnchor, constant: 4),
            createTagFeedbackLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            createTagFeedbackLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
        ])
    }
}

extension TagCreationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tagTitle = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
}
