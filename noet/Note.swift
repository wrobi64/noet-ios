//
//  Note.swift
//  noet
//
//  Created by wrobot on 1/14/25.
//

import Foundation

struct Note: Codable, Identifiable {
    let id: UUID
    var title: String
    var content: String
    var lastModified: Date
    
    init(id: UUID = UUID(), title: String, content: String, lastModified: Date = Date()) {
        self.id = id
        self.title = title
        self.content = content
        self.lastModified = lastModified
    }
}
