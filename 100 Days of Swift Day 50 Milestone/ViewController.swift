//
//  ViewController.swift
//  100 Days of Swift Day 50 Milestone
//
//  Created by Seb Vidal on 12/12/2021.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var photos: [Photo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        load()
    }
    
    func setupNavigationBar() {
        title = "Photos"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhoto))
    }
    
    @objc func addPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
//        imagePicker.sourceType = .camera
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "photo", for: indexPath) as? PhotoCell else {
            fatalError("Cannot dequeue cell.")
        }
        
        let photo = photos[indexPath.row]
        let path = getDocumentsDirectory().appendingPathComponent(photo.image)
        
        cell.photo.image = UIImage(contentsOfFile: path.path)
        cell.label.text = photo.label
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailView") as? DetailViewController {
            detailViewController.selectedPhoto = photos[indexPath.row]
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        tableView.reloadData()
        showAlertController(parent: picker) { [weak self] label in
            let photo = Photo(image: imageName, label: label)
            self?.photos.append(photo)
            self?.tableView.reloadData()
            self?.save()
        }
    }
    
    func showAlertController(parent: UIImagePickerController, completion: @escaping (String) -> Void) {
        let title = "Add Caption"
        let message = "Write a caption for the photo you've just taken."
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: "Done", style: .default) { _ in
            if let caption = alertController.textFields?[0].text {
                completion(caption)
                parent.dismiss(animated: true)
            }
        })
        
        parent.present(alertController, animated: true)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let jsonData = try? jsonEncoder.encode(photos) {
            let defaults = UserDefaults.standard
            defaults.set(jsonData, forKey: "photos")
        }
    }
    
    func load() {
        let defaults = UserDefaults.standard
        
        if let savedPhotos = defaults.object(forKey: "photos") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                photos = try jsonDecoder.decode([Photo].self, from: savedPhotos)
            } catch {
                print("Error decoding JSON.")
            }
        }
    }
    
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    return paths[0]
}

