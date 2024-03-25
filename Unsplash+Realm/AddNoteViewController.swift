//
//  AddNoteViewController.swift
//  Unsplash+Realm
//
//  Created by Алексей on 25.03.2024.
//

import UIKit

class AddNoteViewController: UIViewController {
    
    var folder: Folder?
    
    private let manager = DataBaseManager()
    private let storageManager = StorageManager()
    
    lazy var addNote = UIAction { [unowned self] _ in
        present(picker, animated: true)
    }
    
    lazy var picker: UIImagePickerController = {
        $0.sourceType = .photoLibrary
        $0.allowsEditing = true
        $0.delegate = self
        return $0
    }(UIImagePickerController())
    
    lazy var tableview: UITableView = {
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        $0.dataSource = self
        $0.delegate = self
        return $0
    }(UITableView(frame: view.bounds, style: .insetGrouped))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            systemItem: .add,
            primaryAction: addNote
        )
        title = "Notes"
        view.backgroundColor = .white
        view.addSubview(tableview)
    }
}

//MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension AddNoteViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        
        let photoName = UUID().uuidString + ".jpeg"
        
        if let img = info[.editedImage] as? UIImage {
            let note = Note()
            note.header = "Image"
            note.photoUrl = photoName
            
            manager.createNote(folder: folder!, note: note )
            if let imgData = img.jpegData(compressionQuality: 1) {
                storageManager.saveImage(data: imgData, name: photoName)
            }
        }
        picker.dismiss(animated: true)
        let indexPath = IndexPath(row: manager.folders.count - 1, section: 0)
        tableview.insertRows(at: [indexPath], with: .automatic)
    }
}

//MARK: - UITableViewDataSource
extension AddNoteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        folder!.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let note = Array(folder!.notes)
        let oneNote = note[indexPath.row]
        
        var configCell = cell.defaultContentConfiguration()
        configCell.text = oneNote.header
        if let data = storageManager.getImage(imgName: oneNote.photoUrl), let img = UIImage(data: data) {
            configCell.imageProperties.maximumSize = CGSize(width: 50, height: 50)
            configCell.image = img
            configCell.imageProperties.cornerRadius = 10
        }
        cell.contentConfiguration = configCell
        cell.accessoryType = .detailButton
        return cell
    }
}

//MARK: - UITableViewDelegate
extension AddNoteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let note = Array(folder!.notes)
        let oneNote = note[indexPath.row]
        
        if editingStyle == .delete {
            manager.deleteNote(id: oneNote.id)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let note = Array(folder!.notes)
        let oneNote = note[indexPath.row]
        
        showAlert(id: oneNote.id, message: "Enter a new header:")
    }
}

extension AddNoteViewController {
    private func showAlert(id: String, message: String?) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "Rename", style: .default) { [unowned self] _ in
            if let text = alert.textFields?.first?.text {
                manager.updateNote(id: id, header: text)
                tableview.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        alert.addTextField()
        present(alert, animated: true)
    }
}
