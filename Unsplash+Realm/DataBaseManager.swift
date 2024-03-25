//
//  DataBaseManager.swift
//  Unsplash+Realm
//
//  Created by Алексей on 25.03.2024.
//

import Foundation
import RealmSwift

final class DataBaseManager {
    let realm = try! Realm()
    
    var folders = [Folder]()
    
    init() {
        getFolder()
    }
    
    func createFolder(folder: Folder) {
        try! realm.write({
            realm.add(folder)
        })
        getFolder()
    }
    
    func createNote(folder: Folder, note: Note) {
        try! realm.write({
            folder.notes.append(note)
        })
    }
    
    func getFolder(){
        let allFolder = realm.objects(Folder.self)
        self.folders = Array(allFolder)
    }
    
    func updateNote(id: String, header: String) {
        if let note = realm.object(ofType: Note.self, forPrimaryKey: id) {
            try! realm.write({
                note.header = header
            })
        }
    }
    
    func deleteNote(id: String) {
        if let note = realm.object(ofType: Note.self, forPrimaryKey: id) {
            try! realm.write({
                realm.delete(note)
            })
        }
    }
    
    func deleteFolder(id: String) {
        if let folder = realm.object(ofType: Folder.self, forPrimaryKey: id) {
            
            folder.notes.forEach { note in
                deleteNote(id: note.id)
            }
            
            try! realm.write({
                realm.delete(folder)
            })
        }
        getFolder()
    }
}
