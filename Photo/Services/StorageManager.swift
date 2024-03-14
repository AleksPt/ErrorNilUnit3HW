import Foundation

class StorageManager{

    static let shared = StorageManager()
        
    var defaultDirectory = UserDefaults.standard.string(forKey: "folder")
    
    func load(url: URL, namePhoto: String) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self?.saveImage(data: data, namePhoto: namePhoto)
                }
            }
        }
    }
    
    func getPath() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask).first!
    }
    
    func saveImage(data: Data, namePhoto: String) {
       var path = getPath()
        path.append(path: defaultDirectory ?? "photo")
        
        try? FileManager.default.createDirectory(at: path, withIntermediateDirectories: true)
        
        path.append(path: namePhoto + ".jpeg")
        
        do {
            try data.write(to: path)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getImage(imgName: String) -> Data? {
        var path = getPath()
        path.append(path: defaultDirectory ?? "photo")
        path.append(path: imgName)
        
        return try? Data(contentsOf: path)
    }
    
    func deleteFolder() {
        var path = getPath()
        path.append(path: defaultDirectory ?? "photo")
        try? FileManager.default.removeItem(at: path)
    }
    
    func moveFile(path: String) -> Bool {
        do {
            var oldPath = getPath()
            oldPath.append(path: defaultDirectory ?? "photo")
            var newPath = getPath()
            newPath.append(path: path)
            try FileManager.default.moveItem(at: oldPath, to: newPath)
            deleteFolder()
            UserDefaults.standard.setValue(path, forKey: "folder")
            return true
        } catch {
            return false
        }
    }
}
