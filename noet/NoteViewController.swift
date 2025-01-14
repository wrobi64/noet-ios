//
//  NoteViewController.swift
//  noet
//
//  Created by wrobot on 1/14/25.
//

import UIKit
import Down

protocol NoteViewControllerDelegate: AnyObject {
    func noteViewController(_ controller: NoteViewController, didUpdateNote note: Note, at index: Int)
}

class NoteViewController: UIViewController {
    private var note: Note
    private let index: Int
    weak var delegate: NoteViewControllerDelegate?
    
    private let titleTextField = UITextField()
    private let contentTextView = UITextView()
    private let previewButton = UIBarButtonItem(title: "Preview", style: .plain, target: nil, action: nil)
    private var isPreviewMode = false
    
    init(note: Note, index: Int) {
        self.note = note
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Title TextField
        titleTextField.placeholder = "Note Title"
        titleTextField.text = note.title
        titleTextField.font = .preferredFont(forTextStyle: .headline)
        titleTextField.delegate = self
        
        // Content TextView
        contentTextView.text = note.content
        contentTextView.font = .preferredFont(forTextStyle: .body)
        contentTextView.delegate = self
        
        // Preview Button
        previewButton.target = self
        previewButton.action = #selector(togglePreview)
        navigationItem.rightBarButtonItem = previewButton
        
        // Layout
        let stackView = UIStackView(arrangedSubviews: [titleTextField, contentTextView])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            titleTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func togglePreview() {
        isPreviewMode.toggle()
        
        if isPreviewMode {
            previewButton.title = "Edit"
            showMarkdownPreview()
        } else {
            previewButton.title = "Preview"
            contentTextView.text = note.content
            contentTextView.isEditable = true
        }
    }
    
    private func showMarkdownPreview() {
        contentTextView.isEditable = false
        
        do {
            let down = Down(markdownString: note.content)
            let attributedString = try down.toAttributedString()
            contentTextView.attributedText = attributedString
        } catch {
            contentTextView.text = "Error rendering markdown preview"
        }
    }
    
    private func updateNote() {
        let updatedNote = Note(
            id: note.id,
            title: titleTextField.text ?? "",
            content: contentTextView.text,
            lastModified: Date()
        )
        note = updatedNote
        delegate?.noteViewController(self, didUpdateNote: updatedNote, at: index)
    }
}

extension NoteViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateNote()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateNote()
    }
}
