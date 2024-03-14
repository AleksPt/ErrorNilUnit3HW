import UIKit

final class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let feedPhotoVC = configure(
            viewController: FeedPhotoViewController(),
            title: "Feed",
            tabBarImage: "photo.stack"
        )
        
        let favoritesPhotoVC = configure(
            viewController: FavoritesPhotoViewController(),
            title: "Favorites",
            tabBarImage: "star"
        )
        
        self.viewControllers = [feedPhotoVC, favoritesPhotoVC]
        tabBar.backgroundColor = .white
    }
    
    private func configure(
        viewController: UIViewController,
        title: String,
        tabBarImage: String
    ) -> UIViewController {
        let vc = viewController
        vc.tabBarItem.title = title
        vc.tabBarItem.image = UIImage(systemName: tabBarImage)
        vc.tabBarItem.selectedImage = UIImage(systemName: tabBarImage + ".fill")
        return vc
    }
}
