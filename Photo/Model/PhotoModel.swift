//
//  PhotoModel.swift
//  Photo
//
//  Created by Алексей on 14.03.2024.
//

import Foundation
import RealmSwift

class PhotoModel: Object {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var photoUrl: String
}
