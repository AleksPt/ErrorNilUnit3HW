//
//  Photo.swift
//  Unsplash+Realm
//
//  Created by Алексей on 25.03.2024.
//

import Foundation
import RealmSwift

class Folder: Object {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var name = String()
    @Persisted var notes: List<Note>
}

class Note: Object {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var header: String? = String()
    @Persisted var photoUrl = String()
}
