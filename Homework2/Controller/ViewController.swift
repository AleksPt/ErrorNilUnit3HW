import UIKit

final class ViewController: UIViewController {

    private let networkManager = NetworkManager()
    private var news: [Articles]? = []
    
    private lazy var searchController: UISearchController = {
        $0.searchResultsUpdater = self
        $0.searchBar.placeholder = "Поиск"
        return $0
    }(UISearchController(searchResultsController: nil))
    
    private lazy var tableView: UITableView = {
        $0.dataSource = self
        $0.register(NewsCell.self, forCellReuseIdentifier: NewsCell.reuseId)
        return $0
    }(UITableView(frame: view.bounds))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        title = "Новости"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        
        self.tableView.separatorStyle = .none
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        news?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.reuseId, for: indexPath) as! NewsCell
        
        let cellItem = news?[indexPath.row]
        
        cell.configureCell(
            title: cellItem?.title ?? "",
            description: cellItem?.description ?? "",
            imageUrl: cellItem?.urlToImage ?? ""
        )
        
        cell.selectionStyle = .none
        
        return cell
    }
}

//MARK: - UISearchResultsUpdating
extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            networkManager.getNews(keyword: searchText) { [weak self] data in
                self?.news = data
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
}
