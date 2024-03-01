import Foundation

final class NetworkManager {
    func getNews(category: String) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "newsapi.org"
        urlComponents.path = "/v2/top-headlines"
     
        urlComponents.queryItems = [
            URLQueryItem(name: "apiKey", value: "439475c8529944cfb6b58a6e19673038"),
            URLQueryItem(name: "country", value: "ru"),
            URLQueryItem(name: "category", value: category),
            URLQueryItem(name: "page", value: "1"),
        ]
        
        guard let url = urlComponents.url else { return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let jsonData = data {
                let response = try? JSONDecoder().decode(Response.self, from: jsonData)
                print("""
                    Статус: \(response?.status ?? "")
                    Всего результатов: \(response?.totalResults ?? 0)\n
                    """)
                response?.articles.forEach {
                    print("""
                        🙋‍♂️ Автор:
                        \t\($0.author)
                        ✏️ Заголовок:
                        \t\($0.title)
                        ⏱️ Опубликовано:
                        \t\($0.publishedAt)\n
                        """)
                }
                
            }
            
        }.resume()
    }
}

struct Response: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Articles]
}

struct Articles: Decodable {
    let author: String
    let title: String
    let publishedAt: String
}


