//
//  CardViewController.swift
//  ankicopy
//
//  Created by user on 03.11.2020.
//

import UIKit

class CardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    var state = 0
    var card: Card?
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func reverseCard(_ sender: Any) {
        descriptionTextView.isHidden = !descriptionTextView.isHidden
        if card?.image != nil {
            imageView.isHidden = !imageView.isHidden
        }
        nameLabel.isHidden = !nameLabel.isHidden
    }
    
    func updateView() {
        nameLabel.text = card?.name ?? ""
        descriptionTextView.text = card?.description ?? ""
        if let image = card?.image {
            imageView.image = image
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(tap)
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }

    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
}
