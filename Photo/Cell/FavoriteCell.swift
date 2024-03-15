//
//  FavoriteCell.swift
//  Photo
//
//  Created by Алексей on 14.03.2024.
//

import UIKit

class FavoriteCell: UICollectionViewCell {
    
    private let databaseManager = DataBaseManager()
    static let reuseId = "FavoriteCell"
    
    var completionDelete: (()->())?
    var completionUpdate: (()->())?
    
    lazy var customView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .systemGray
        return $0
    }(UIView())
    
    lazy var favoriteImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        return $0
    }(UIImageView())
    
    lazy var deletePhotoButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(systemName: "trash"), for: .normal)
        $0.tintColor = .systemRed
        return $0
    }(UIButton(type: .custom, primaryAction: deletePhotoAction))
    
    lazy var deletePhotoAction = UIAction { [weak self] _ in
        self?.completionDelete?()
    }
    
    lazy var renamePhotoButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(systemName: "character.cursor.ibeam"), for: .normal)
        $0.tintColor = .systemBlue
        return $0
    }(UIButton(type: .custom, primaryAction: renamePhotoAction))
    
    lazy var renamePhotoAction = UIAction { [weak self] _ in
        self?.completionUpdate?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(customView)
        addSubview(favoriteImageView)
        addSubview(deletePhotoButton)
        addSubview(renamePhotoButton)
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
                favoriteImageView.bottomAnchor.constraint(equalTo: deletePhotoButton.topAnchor, constant: -5),
                favoriteImageView.widthAnchor.constraint(equalToConstant: viewWidth),
                hAnchor,
                
                deletePhotoButton.trailingAnchor.constraint(equalTo: favoriteImageView.trailingAnchor, constant: -10),
                deletePhotoButton.bottomAnchor.constraint(equalTo: bottomAnchor),
                deletePhotoButton.widthAnchor.constraint(equalToConstant: 30),
                deletePhotoButton.heightAnchor.constraint(equalToConstant: 30),
                
                renamePhotoButton.topAnchor.constraint(equalTo: favoriteImageView.bottomAnchor),
                renamePhotoButton.leadingAnchor.constraint(equalTo: favoriteImageView.leadingAnchor, constant: 10),
                renamePhotoButton.bottomAnchor.constraint(equalTo: bottomAnchor),
                renamePhotoButton.widthAnchor.constraint(equalToConstant: 30),
                renamePhotoButton.heightAnchor.constraint(equalToConstant: 30),
                
                customView.leadingAnchor.constraint(equalTo: favoriteImageView.leadingAnchor, constant: 5),
                customView.trailingAnchor.constraint(equalTo: favoriteImageView.trailingAnchor, constant:  -5),
                customView.bottomAnchor.constraint(equalTo: bottomAnchor),
                customView.heightAnchor.constraint(equalToConstant: 1)
            ])
        }
    }
}
