//
//  NotesManager.swift
//  noet
//
//  Created by wrobot on 1/14/25.
//
import Foundation

class NotesManager {
    static let shared = NotesManager()
    private let notesKey = "savedNotes"
    
    private init() {}
    
    func saveNotes(_ notes: [Note]) {
        if let encoded = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(encoded, forKey: notesKey)
        }
    }
    
    func loadNotes() -> [Note] {
        guard let data = UserDefaults.standard.data(forKey: notesKey),
              let notes = try? JSONDecoder().decode([Note].self, from: data) else {
            return []
        }
        return notes
    }
}
