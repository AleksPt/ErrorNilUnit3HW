import UIKit

final class FavoritesPhotoViewController: UIViewController {
    
    lazy var favoriteImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .dark
        view.addSubview(favoriteImageView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let imgData = StorageManager.shared.getImage(imgName: "image.jpeg") {
            favoriteImageView.image = UIImage(data: imgData)
        }
        
        NSLayoutConstraint.activate([
            favoriteImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            favoriteImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            favoriteImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            favoriteImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            favoriteImageView.heightAnchor.constraint(equalToConstant: 500)
        ])
       
    }
}
