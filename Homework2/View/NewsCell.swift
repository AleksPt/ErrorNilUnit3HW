import UIKit

final class NewsCell: UITableViewCell {

    static let reuseId = "Cell"
    
    private lazy var customView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(
            red: 240/255,
            green: 240/255,
            blue: 240/255,
            alpha: 1
        )
        $0.layer.cornerRadius = 15
        return $0
    }(UIView())
    
    private lazy var picture: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 15
        return $0
    }(UIImageView())
    
    private lazy var titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.sizeToFit()
        $0.font = .boldSystemFont(ofSize: 16)
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    private lazy var descriptionLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.sizeToFit()
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 14)
        return $0
    }(UILabel())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(customView)
        addSubview(picture)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        
        setupConstraints()
    }
    
    override func prepareForReuse() {
        self.titleLabel.text = nil
        self.descriptionLabel.text = nil
        self.picture.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(title: String, description: String, imageUrl: String) {
        self.titleLabel.text = title
        self.descriptionLabel.text = description
        
        guard let url = URL(string: imageUrl) else {
            self.picture.image = .picture
            return
        }
        self.picture.load(url: url)
    }
    
}

// MARK: - Setup constraints
private extension NewsCell {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            customView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            customView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            customView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
            picture.topAnchor.constraint(equalTo: customView.topAnchor),
            picture.leadingAnchor.constraint(equalTo: customView.leadingAnchor),
            picture.trailingAnchor.constraint(equalTo: customView.trailingAnchor),
            picture.heightAnchor.constraint(equalToConstant: 200),
            
            titleLabel.topAnchor.constraint(equalTo: picture.bottomAnchor, constant: 17),
            titleLabel.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 34),
            titleLabel.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -34),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            descriptionLabel.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 15),
            descriptionLabel.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -15),
            descriptionLabel.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -25)
        ])
    }
}
