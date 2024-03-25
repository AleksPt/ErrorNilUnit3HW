//
//  DataBaseManager.swift
//  Photo
//
//  Created by Алексей on 14.03.2024.
//

import Foundation
import RealmSwift

class DataBaseManager {
    let realm = try! Realm()
    
    func savePhoto(_ photo: PhotoModel) {
        try! realm.write {
            realm.add(photo)
        }
    }
    
    func getPhotos() -> [PhotoModel] {
        let allPhoto = realm.objects(PhotoModel.self)
        return Array(allPhoto).reversed()
    }
    
    func updatePhoto(id: String, header: String) {
        if let photo = realm.object(ofType: PhotoModel.self, forPrimaryKey: id) {
            try! realm.write {
                photo.header = header
            }
        }
    }
    
    func deleteAllPhoto() {
        try! realm.write({
            realm.deleteAll()
        })
    }
    
    func deletePhoto(id: String) {
        if let photo = realm.object(ofType: PhotoModel.self, forPrimaryKey: id) {
            try! realm.write {
                realm.delete(photo)
            }
        }
    }
}
