import UIKit

class ViewController: UIViewController {

    enum Category: String {
        case business
        case entertainment
        case health
        case science
        case sports
        case technology
    }
    
    private let categories = [
        "Бизнес",
        "Развлечения",
        "Здоровье",
        "Наука",
        "Спорт",
        "Технологии"
    ]
    
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
        categories.count
    }
}

//MARK: - UIPickerViewDelegate
extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var category = ""
        
        switch row {
        case 0: category = Category.business.rawValue
        case 1: category = Category.entertainment.rawValue
        case 2: category = Category.health.rawValue
        case 3: category = Category.science.rawValue
        case 4: category = Category.sports.rawValue
        default: category = Category.technology.rawValue
        }
        
        networkManager.getNews(category: category)
    }
}
