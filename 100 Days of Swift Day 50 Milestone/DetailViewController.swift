//
//  DetailViewController.swift
//  100 Days of Swift Day 50 Milestone
//
//  Created by Seb Vidal on 15/12/2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    var selectedPhoto: Photo?

    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupImageView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.hidesBarsOnTap = false
    }
    
    func setupNavigationBar() {
        if let photo = selectedPhoto {
            title = photo.label
        }
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func setupImageView() {
        if let photo = selectedPhoto {
            let path = getDocumentsDirectory().appendingPathComponent(photo.image)
            imageView.image = UIImage(contentsOfFile: path.path)
        }
    }

}
