//
//  StorageManager.swift
//  Unsplash+Realm
//
//  Created by Алексей on 25.03.2024.
//

import Foundation

class StorageManager {
    func getPath() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func saveImage(data: Data, name: String) {
        var path = getPath()
        
        path.append(path: name)
        do {
            try data.write(to: path)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getImage(imgName: String) -> Data? {
        var path = getPath()
        path.append(path: imgName)
        return try? Data(contentsOf: path)
    }
}
