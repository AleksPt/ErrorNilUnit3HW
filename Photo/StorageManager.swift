import Foundation

class StorageManager{

    static let shared = StorageManager()
    
    private var defaultPath = "photo"
    
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self?.saveImage(data: data)
                }
            }
        }
    }
    
    func getPath() -> URL{
        return FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask).first!
    }
    
    func saveImage(data: Data){
       var path = getPath()
        path.append(path: defaultPath)
        
        try? FileManager.default.createDirectory(at: path, withIntermediateDirectories: true)
        
        path.append(path: "image.jpeg")
        
        do {
            try data.write(to: path)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getImage(imgName: String) -> Data?{
        var path = getPath()
        path.append(path: defaultPath)
        path.append(path: imgName)
        
        return try? Data(contentsOf: path)
    }
    
    func deleteFolder() {
        var path = getPath()
        path.append(path: defaultPath)
        try? FileManager.default.removeItem(at: path)
    }
    
    func moveFile(path: String) -> Bool {
        do {
            var oldPath = getPath()
            oldPath.append(path: defaultPath)
            var newPath = getPath()
            newPath.append(path: path)
            try FileManager.default.moveItem(at: oldPath, to: newPath)
            deleteFolder()
            defaultPath = path
            return true
        } catch {
            return false
        }
    }
}
