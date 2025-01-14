//
//  ContentView.swift
//  noet
//
//  Created by wrobot on 1/14/25.
//

import SwiftUI

struct ContentView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        let notesListVC = NotesListViewController()
        return UINavigationController(rootViewController: notesListVC)
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // Updates happen automatically
    }
}

#Preview {
    ContentView()
}
