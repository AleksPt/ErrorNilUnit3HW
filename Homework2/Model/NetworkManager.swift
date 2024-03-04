import Foundation

final class NetworkManager {
    func getNews(keyword: String, completion: @escaping ([Articles]?) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "newsapi.org"
        urlComponents.path = "/v2/top-headlines"
        
        urlComponents.queryItems = [
            URLQueryItem(name: "apiKey", value: "439475c8529944cfb6b58a6e19673038"),
            URLQueryItem(name: "q", value: keyword)
        ]
        
        guard let url = urlComponents.url else { return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            
            if let jsonData = data {
                let responseData = try? JSONDecoder().decode(Response.self, from: jsonData)
                let responseArticles = responseData?.articles
                completion(responseArticles)
            }
            
        }.resume()
    }
}
