//
//  ViewController.swift
//  Unsplash+Realm
//
//  Created by Алексей on 25.03.2024.
//

import UIKit

final class ViewController: UIViewController {

    private var manager = DataBaseManager()
    
    lazy var tableview: UITableView = {
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        $0.dataSource = self
        $0.delegate = self
        return $0
    }(UITableView(frame: view.bounds, style: .insetGrouped))
    
    lazy var createFolder = UIAction { [unowned self] _ in
        showAlert(title: nil, message: "Enter the folder name:")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews([tableview])
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            systemItem: .add,
            primaryAction: createFolder
        )
        title = "Folders"
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableview.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        manager.folders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var configCell = cell.defaultContentConfiguration()
        configCell.text = manager.folders[indexPath.row].name
        configCell.secondaryText = "Количество фото: \(manager.folders[indexPath.row].notes.count)"
        configCell.image = UIImage(systemName: "folder.fill")
        cell.contentConfiguration = configCell
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let folder = manager.folders[indexPath.row]
        let addVC = AddNoteViewController()
        addVC.folder = folder
        navigationController?.pushViewController(addVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            manager.deleteFolder(id: manager.folders[indexPath.row].id)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: - Alert create folder
extension ViewController {
    private func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "Create", style: .default) { [unowned self] _ in
            if let text = alert.textFields?.first?.text {
                let folder = Folder()
                folder.name = text
                manager.createFolder(folder: folder)
                
                let indexPath = IndexPath(row: manager.folders.count - 1, section: 0)
                tableview.insertRows(at: [indexPath], with: .automatic)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        alert.addTextField()
        present(alert, animated: true)
    }
}
