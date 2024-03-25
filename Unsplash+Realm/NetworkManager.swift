//
//  NetworkManager.swift
//  Unsplash+Realm
//
//  Created by Алексей on 25.03.2024.
//

import Foundation
import Alamofire

final class NetworkManager {
    func getRandomPhoto(completion: @escaping (Result<Photo?, Error>) -> ()) {
        let parameters: Parameters = [
            "client_id": "o1Qf3HRyR40Jm6N5pKkW923CJ7EbQAXgYl6LxnLq4U0"
        ]
        
        AF.request("https://api.unsplash.com/photos/random", parameters: parameters).response { result in
            guard result.error == nil else {
                completion(.failure(result.error!))
                return
            }
            
            if let data = result.data {
                let photos = try? JSONDecoder().decode(Photo.self, from: data)
                completion(.success(photos))
            }
        }
    }
}
