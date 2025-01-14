//
//  NotesListViewController.swift
//  noet
//
//  Created by wrobot on 1/14/25.
//

import UIKit

class NotesListViewController: UIViewController {
    private var notes: [Note] = []
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadNotes()
    }
    
    private func setupUI() {
        title = "Notes"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewNote)
        )
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NoteCell")
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadNotes() {
        notes = NotesManager.shared.loadNotes()
        tableView.reloadData()
    }
    
    @objc private func addNewNote() {
        let newNote = Note(title: "New Note", content: "")
        notes.insert(newNote, at: 0)
        NotesManager.shared.saveNotes(notes)
        
        let noteVC = NoteViewController(note: newNote, index: 0)
        noteVC.delegate = self
        navigationController?.pushViewController(noteVC, animated: true)
    }
}

extension NotesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        let note = notes[indexPath.row]
        
        var config = cell.defaultContentConfiguration()
        config.text = note.title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        config.secondaryText = dateFormatter.string(from: note.lastModified)
        
        cell.contentConfiguration = config
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let noteVC = NoteViewController(note: notes[indexPath.row], index: indexPath.row)
        noteVC.delegate = self
        navigationController?.pushViewController(noteVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
            NotesManager.shared.saveNotes(notes)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension NotesListViewController: NoteViewControllerDelegate {
    func noteViewController(_ controller: NoteViewController, didUpdateNote note: Note, at index: Int) {
        notes[index] = note
        NotesManager.shared.saveNotes(notes)
        tableView.reloadData()
    }
}
