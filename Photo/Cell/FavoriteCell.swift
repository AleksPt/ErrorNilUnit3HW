//
//  FavoriteCell.swift
//  Photo
//
//  Created by Алексей on 14.03.2024.
//

import UIKit
import SpringAnimation

class FavoriteCell: UICollectionViewCell {
    
    private let databaseManager = DataBaseManager()
    static let reuseId = "FavoriteCell"
    
    var completionDelete: (()->())?
    var completionUpdate: (()->())?
    var completionShared: ((UIActivityViewController)->())?
    
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
        $0.isUserInteractionEnabled = true
        return $0
    }(UIImageView())
    
    lazy var sharedButton: SpringButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Shared", for: .normal)
        return $0
    }(SpringButton(type: .system, primaryAction: sharedAction))
    
    lazy var sharedAction = UIAction { [weak self] _ in
        let share = UIActivityViewController(
            activityItems: [self?.favoriteImageView.image as Any],
            applicationActivities: nil
        )
        self?.completionShared?(share)
        
        self?.sharedButton.animation = "swing"
        self?.sharedButton.duration = 0.5
        self?.sharedButton.animate()
    }
    
    lazy var deletePhotoButton: SpringButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(systemName: "trash"), for: .normal)
        $0.tintColor = .systemRed
        return $0
    }(SpringButton(type: .custom, primaryAction: deletePhotoAction))
    
    lazy var deletePhotoAction = UIAction { [weak self] _ in
        self?.completionDelete?()
        
        self?.deletePhotoButton.animation = "swing"
        self?.deletePhotoButton.duration = 0.5
        self?.deletePhotoButton.animate()
    }
    
    lazy var renamePhotoButton: SpringButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(systemName: "character.cursor.ibeam"), for: .normal)
        $0.tintColor = .systemBlue
        return $0
    }(SpringButton(type: .custom, primaryAction: renamePhotoAction))
    
    lazy var renamePhotoAction = UIAction { [weak self] _ in
        self?.completionUpdate?()
        
        self?.renamePhotoButton.animation = "swing"
        self?.renamePhotoButton.duration = 0.5
        self?.renamePhotoButton.animate()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(customView)
        addSubview(favoriteImageView)
        addSubview(deletePhotoButton)
        addSubview(renamePhotoButton)
        addSubview(sharedButton)
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
                deletePhotoButton.centerYAnchor.constraint(equalTo: renamePhotoButton.centerYAnchor),
                deletePhotoButton.widthAnchor.constraint(equalToConstant: 30),
                deletePhotoButton.heightAnchor.constraint(equalToConstant: 30),
                
                renamePhotoButton.topAnchor.constraint(equalTo: favoriteImageView.bottomAnchor),
                renamePhotoButton.leadingAnchor.constraint(equalTo: favoriteImageView.leadingAnchor, constant: 10),
                renamePhotoButton.bottomAnchor.constraint(equalTo: bottomAnchor),
                renamePhotoButton.widthAnchor.constraint(equalToConstant: 30),
                renamePhotoButton.heightAnchor.constraint(equalToConstant: 30),
                
                sharedButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                sharedButton.centerYAnchor.constraint(equalTo: renamePhotoButton.centerYAnchor),
                
                customView.leadingAnchor.constraint(equalTo: favoriteImageView.leadingAnchor, constant: 5),
                customView.trailingAnchor.constraint(equalTo: favoriteImageView.trailingAnchor, constant:  -5),
                customView.bottomAnchor.constraint(equalTo: bottomAnchor),
                customView.heightAnchor.constraint(equalToConstant: 1)
            ])
        }
    }
}
