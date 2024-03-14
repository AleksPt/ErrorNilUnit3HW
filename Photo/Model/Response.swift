import Foundation

struct Photo: Decodable {
    let id: String?
    let width, height: Int?
    let urls: PhotoUrl?
}

struct PhotoUrl: Decodable {
    let regular: String?
}
