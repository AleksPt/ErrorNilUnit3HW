import Foundation

struct Response: Decodable {
    let articles: [Articles]
}

struct Articles: Decodable {
    let title: String?
    let description: String?
    let urlToImage: String?
}
