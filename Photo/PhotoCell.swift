import UIKit
import SDWebImage

final class PhotoCell: UICollectionViewCell {
    static let reuseId = "PhotoCell"
    
    lazy var photo: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
        return $0
    }(UIImageView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photo)
    }
    
    override func prepareForReuse() {
        self.photo.image = nil
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

            NSLayoutConstraint.activate([
                photo.topAnchor.constraint(equalTo: topAnchor),
                photo.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                photo.widthAnchor.constraint(equalToConstant: viewWidth),
                photo.heightAnchor.constraint(equalToConstant: newHeightPicture)
            ])
        }
    }
}
