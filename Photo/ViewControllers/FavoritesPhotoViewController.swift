import UIKit

final class FavoritesPhotoViewController: UIViewController {
    
    private let databaseManager = DataBaseManager()
    private var photoModel = [PhotoModel()]
    
    lazy var collectionView: UICollectionView = {
        let layout = $0.collectionViewLayout as! UICollectionViewFlowLayout
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10

        $0.dataSource = self
        $0.register(FavoriteCell.self, forCellWithReuseIdentifier: FavoriteCell.reuseId)
        $0.backgroundColor = .white
        return $0
    }(UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout()))
    
    lazy var renameDirectoryButton: UIButton = {
        $0.setTitle("Rename directory", for: .normal)
        $0.tintColor = .systemBlue
        return $0
    }(UIButton(type: .system, primaryAction: renameDirectoryAction))
    
    lazy var renameDirectoryAction = UIAction { [weak self] _ in
        self?.showAlertRenameDirectory()
    }
    
    lazy var deleteAllPhotoButton: UIButton = {
        $0.setTitle("Delete all", for: .normal)
        $0.tintColor = .systemRed
        return $0
    }(UIButton(type: .system, primaryAction: deleteAllPhotoAction))
    
    lazy var deleteAllPhotoAction = UIAction { [weak self] _ in
        self?.showAlertDeleteAllPhoto()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: deleteAllPhotoButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: renameDirectoryButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photoModel = databaseManager.getPhotos()
        collectionView.reloadData()
        
        if !photoModel.isEmpty {
            deleteAllPhotoButton.isEnabled = true
            deleteAllPhotoButton.tintColor = .systemRed
        }
    }
}

// MARK: - UICollectionViewDataSource
extension FavoritesPhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photoModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCell.reuseId, for: indexPath) as! FavoriteCell
        
        let photourl = photoModel[indexPath.item].photoUrl
        let photoid = photoModel[indexPath.item].id
        
        cell.configCell(photoId: photourl)
        cell.completionDelete = { [weak self] in
            self?.showAlertDeleteOnePhoto(idPhoto: photoid, photoUrl: photourl)
            self?.photoModel.remove(at: indexPath.row)
        }
        
        cell.completionUpdate = { [weak self] in
            self?.showAlertUpdatePhoto(id: photoid)
        }
        
        cell.completionShared = { [weak self] share in
            self?.present(share, animated: true)
        }
        
        return cell
    }
}

// MARK: - Alerts
extension FavoritesPhotoViewController {
    
    func showAlertRenameDirectory() {
        let renameAlert = UIAlertController(
            title: nil,
            message: "Enter name for new folder:",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(
            title: "Ok",
            style: .default) { _ in
                if let text = renameAlert.textFields?.first?.text {
                    StorageManager.shared.moveFile(path: text)
                }
            }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        renameAlert.addTextField()
        renameAlert.addAction(okAction)
        renameAlert.addAction(cancelAction)
        present(renameAlert, animated: true)
    }
    
    func showAlertDeleteAllPhoto() {

        let alert = UIAlertController(
            title: "Are you sure you want to delete all the photos?",
            message: "This action cannot be undone!",
            preferredStyle: .actionSheet
        )

        let okAction = UIAlertAction(
            title: "Yeah, I'm sure",
            style: .destructive) { [weak self] _ in
                StorageManager.shared.deleteFolder()
                self?.databaseManager.deleteAllPhoto()
                self?.photoModel = []
                self?.collectionView.reloadData()
                self?.deleteAllPhotoButton.isEnabled = false
                self?.deleteAllPhotoButton.tintColor = .systemGray
            }
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel
        )
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func showAlertDeleteOnePhoto(idPhoto: String, photoUrl: String) {

        let alert = UIAlertController(
            title: "Are you sure you want to delete this photo?",
            message: "This action cannot be undone!",
            preferredStyle: .actionSheet
        )

        let okAction = UIAlertAction(
            title: "Yeah, I'm sure",
            style: .destructive) { [weak self] _ in
                self?.databaseManager.deletePhoto(id: idPhoto)
                self?.collectionView.reloadData()
                StorageManager.shared.deletePhoto(id: photoUrl)
            }
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel
        )
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func showAlertUpdatePhoto(id: String) {
        let renameAlert = UIAlertController(
            title: nil,
            message: "Enter new header:",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(
            title: "Ok",
            style: .default) { [weak self] _ in
                if let text = renameAlert.textFields?.first?.text {
                    self?.databaseManager.updatePhoto(id: id, header: text)
                }
            }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        renameAlert.addTextField()
        renameAlert.addAction(okAction)
        renameAlert.addAction(cancelAction)
        present(renameAlert, animated: true)
    }
}
