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
        return Array(allPhoto)
    }
}
