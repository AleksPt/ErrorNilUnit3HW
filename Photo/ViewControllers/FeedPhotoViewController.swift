import UIKit

final class FeedPhotoViewController: UIViewController {
    
    var photos: [Photo]? = []
    
    private let networkManager = NetworkManager()
    
    lazy var refresh: UIRefreshControl = {
        return $0
    }(UIRefreshControl(frame: .zero, primaryAction: refreshAction))
    
    lazy var refreshAction = UIAction { _ in
        self.getRandomPhotos()
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = $0.collectionViewLayout as! UICollectionViewFlowLayout
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        $0.dataSource = self
        $0.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.reuseId)
        $0.addSubview(refresh)
        $0.backgroundColor = .dark
        return $0
    }(UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        getRandomPhotos()
        
    }
    
    private func getRandomPhotos() {
        networkManager.getRandomPhotos { [weak self] result in
            switch result {
            case .success(let success):
                self?.photos = success
                self?.collectionView.reloadData()
                self?.refresh.endRefreshing()
            case .failure(let failure):
                self?.showAlert()
                print(failure.localizedDescription)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension FeedPhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.reuseId, for: indexPath) as! FeedCell
        
        guard let photoItem = photos?[indexPath.item] else { return UICollectionViewCell() }
        
        if let url = photoItem.urls?.regular {
            cell.configCell(
                url: url,
                widthPhoto: photoItem.width ?? 100,
                heightPhoto: photoItem.height ?? 100
            )
        }
        
        return cell
    }
}

// MARK: - Show alert with network error
private extension FeedPhotoViewController {
    func showAlert() {
        let alert = UIAlertController(
            title: "Ooops!",
            message: "error",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(
            title: "Ok",
            style: .default
        )
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
