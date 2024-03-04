import UIKit

final class ViewController: UIViewController {

    private let networkManager = NetworkManager()
    private var news: [Articles]? = []
    
    private lazy var tableView: UITableView = {
        $0.dataSource = self
        return $0
    }(UITableView(frame: view.bounds, style: .insetGrouped))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        
        networkManager.getNews(keyword: "Apple") { [weak self] data in
            self?.news = data
            
            DispatchQueue.main.async {
                <#code#>
            }
        }
    }


}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        news?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}
