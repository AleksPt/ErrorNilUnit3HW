import UIKit

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

extension FavoritesPhotoViewController {
    func showAlert() {
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
        
        renameAlert.addTextField()
        renameAlert.addAction(okAction)
        present(renameAlert, animated: true)
    }
}
