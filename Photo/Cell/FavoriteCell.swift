//
//  FavoriteCell.swift
//  Photo
//
//  Created by Алексей on 14.03.2024.
//

import UIKit

class FavoriteCell: UICollectionViewCell {
    
    static let reuseId = "FavoriteCell"
    
    lazy var favoriteImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
        return $0
    }(UIImageView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(favoriteImageView)
    }
    
    override func prepareForReuse() {
        self.favoriteImageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCell(photoId: String) {
        if let imageData = StorageManager.shared.getImage(imgName: photoId + ".jpeg") {
            favoriteImageView.image = UIImage(data: imageData)
            
            let photoRatio = (CGFloat((UIImage(data: imageData)?.size.height)!)) / (CGFloat((UIImage(data: imageData)?.size.width)!))
            let viewWidth = UIScreen.main.bounds.width - 40
            let newHeightPicture = viewWidth * photoRatio
            let hAnchor = favoriteImageView.heightAnchor.constraint(equalToConstant: newHeightPicture)
            hAnchor.priority = .defaultHigh

            NSLayoutConstraint.activate([
                favoriteImageView.topAnchor.constraint(equalTo: topAnchor),
                favoriteImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                favoriteImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                favoriteImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
                favoriteImageView.widthAnchor.constraint(equalToConstant: viewWidth),
                hAnchor,
            ])
        }
    }
}

