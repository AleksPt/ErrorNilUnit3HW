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
        $0.backgroundColor = .dark
        return $0
    }(UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout()))
    
    lazy var renameDirectoryButton: UIButton = {
        $0.setTitle("Rename directory", for: .normal)
//        $0.setImage(UIImage(systemName: "highlighter"), for: .normal)
        $0.tintColor = .systemBlue
        return $0
    }(UIButton(type: .system, primaryAction: renameDirectoryAction))
    
    lazy var renameDirectoryAction = UIAction { [weak self] _ in
        self?.showAlertRenameDirectory()
    }
    
    lazy var deleteImageButton: UIButton = {
        $0.setTitle("Delete all", for: .normal)
        $0.tintColor = .systemRed
//        $0.setImage(UIImage(systemName: "trash"), for: .normal)
        $0.tintColor = .red
        return $0
    }(UIButton(type: .system, primaryAction: deleteImageAction))
    
    lazy var deleteImageAction = UIAction { [weak self] _ in
        self?.showAlertDeleteAllPhoto()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: deleteImageButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: renameDirectoryButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photoModel = databaseManager.getPhotos()
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension FavoritesPhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photoModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCell.reuseId, for: indexPath) as! FavoriteCell
        
        cell.configCell(photoId: photoModel[indexPath.item].photoUrl)
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
            style: .default) { action in
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
            title: "Are you sure you want to delete all the photos? ",
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
            }
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel
        )
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}

/*
final class FavoritesPhotoViewController: UIViewController {
    
    lazy var favoriteImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
        return $0
    }(UIImageView())
    
    lazy var deleteImageButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(systemName: "trash"), for: .normal)
        $0.tintColor = .red
        return $0
    }(UIButton(type: .custom, primaryAction: deleteImageAction))
    
    lazy var deleteImageAction = UIAction { [weak self] _ in
        StorageManager.shared.deleteFolder()
        
        self?.favoriteImageView.image = nil
        self?.deleteImageButton.isHidden = true
        self?.renameDirectoryButton.isHidden = true
    }
    
    lazy var renameDirectoryButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(systemName: "highlighter"), for: .normal)
        $0.tintColor = .systemBlue
        return $0
    }(UIButton(type: .custom, primaryAction: renameDirectoryAction))
    
    lazy var renameDirectoryAction = UIAction { [weak self] _ in
        self?.showAlert()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .dark
        view.addSubview(favoriteImageView)
        view.addSubview(deleteImageButton)
        view.addSubview(renameDirectoryButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let imageData = StorageManager.shared.getImage(imgName: "image.jpeg") {
            favoriteImageView.image = UIImage(data: imageData)
        }
        
        NSLayoutConstraint.activate([
            favoriteImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            favoriteImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            favoriteImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            favoriteImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            favoriteImageView.heightAnchor.constraint(equalToConstant: view.frame.width),
            
            deleteImageButton.topAnchor.constraint(equalTo: favoriteImageView.bottomAnchor, constant: 10),
            deleteImageButton.trailingAnchor.constraint(equalTo: favoriteImageView.trailingAnchor),
            deleteImageButton.widthAnchor.constraint(equalToConstant: 40),
            deleteImageButton.heightAnchor.constraint(equalToConstant: 40),
            
            renameDirectoryButton.topAnchor.constraint(equalTo: favoriteImageView.bottomAnchor, constant: 10),
            renameDirectoryButton.leadingAnchor.constraint(equalTo: favoriteImageView.leadingAnchor),
            renameDirectoryButton.widthAnchor.constraint(equalToConstant: 40),
            renameDirectoryButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        if favoriteImageView.image != nil {
            deleteImageButton.isHidden = false
            renameDirectoryButton.isHidden = false
        } else {
            deleteImageButton.isHidden = true
            renameDirectoryButton.isHidden = true
        }
    }
}


*/
