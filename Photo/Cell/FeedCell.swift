import UIKit
import SDWebImage
import SpringAnimation

final class FeedCell: UICollectionViewCell {
    
    private let databaseManager = DataBaseManager()
    private var urlImage: URL?
    static let reuseId = "FeedCell"
    
    lazy var photo: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
        return $0
    }(UIImageView())
    
    lazy var saveButton: SpringButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Сохранить", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14)
        $0.backgroundColor = .systemPink
        $0.layer.cornerRadius = 15
        return $0
    }(SpringButton(type: .custom, primaryAction: saveAction))
    
    lazy var saveAction = UIAction { [weak self] _ in
        guard let url = self?.urlImage else { return }
        
        let id = UUID().uuidString
        var photoModel: PhotoModel = {
            $0.photoUrl = id
            return $0
        }(PhotoModel())
        
        self?.databaseManager.savePhoto(photoModel)
        StorageManager.shared.load(url: url, namePhoto: id)
        
        self?.saveButton.animation = "pop"
        self?.saveButton.duration = 0.5
        self?.saveButton.animate()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photo)
        addSubview(saveButton)
    }
    
    override func prepareForReuse() {
        self.photo.image = nil
        self.urlImage = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCell(url: String, widthPhoto: Int, heightPhoto: Int) {
        if let url = URL(string: url) {
            
            let photoRatio = (CGFloat(widthPhoto)) / (CGFloat(heightPhoto))
            let viewWidth = UIScreen.main.bounds.width - 40
            let newHeightPicture = viewWidth * photoRatio
            
            photo.sd_setImage(with: url, placeholderImage: .loading)
            urlImage = url
            
            let hAnchor = photo.heightAnchor.constraint(equalToConstant: newHeightPicture)
            hAnchor.priority = .defaultHigh
            
            NSLayoutConstraint.activate([
                photo.topAnchor.constraint(equalTo: topAnchor),
                photo.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                photo.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                photo.bottomAnchor.constraint(equalTo: bottomAnchor),
                photo.widthAnchor.constraint(equalToConstant: viewWidth),
                hAnchor,
                
                saveButton.bottomAnchor.constraint(equalTo: photo.bottomAnchor, constant: -10),
                saveButton.heightAnchor.constraint(equalToConstant: 30),
                saveButton.widthAnchor.constraint(equalToConstant: 100),
                saveButton.centerXAnchor.constraint(equalTo: photo.centerXAnchor)
            ])
        }
    }
}
