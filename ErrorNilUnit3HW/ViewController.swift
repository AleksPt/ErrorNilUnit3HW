import UIKit

class ViewController: UIViewController {

    enum Category: String, CaseIterable {
        case business = "Бизнес"
        case entertainment = "Развлечения"
        case health = "Здоровье"
        case science = "Наука"
        case sports = "Спорт"
        case technology = "Технологии"
        
        func getCategory() -> String {
            switch self {
            case .business:
                return "business"
            case .entertainment:
                return "entertainment"
            case .health:
                return "health"
            case .science:
                return "science"
            case .sports:
                return "sports"
            case .technology:
                return "technology"
            }
        }
    }
    
    private let networkManager = NetworkManager()
    
    lazy var pickerView: UIPickerView = {
        $0.center.x = view.center.x
        $0.center.y = view.center.y
        $0.dataSource = self
        $0.delegate = self
        return $0
    }(UIPickerView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(pickerView)
    }
}

// MARK: - UIPickerViewDataSource
extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        Category.allCases.count
    }
}

//MARK: - UIPickerViewDelegate
extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        Category.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var category = Category.getCategory(Category.allCases[row])()
        
        networkManager.getNews(category: category)
    }
}
