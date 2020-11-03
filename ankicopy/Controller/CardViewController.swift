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
        // Do any additional setup after loading the view.
    }
    var state = 0
    var card: Card?
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBAction func reverseCard(_ sender: Any) {
        descriptionTextView.isHidden = !descriptionTextView.isHidden
        nameLabel.isHidden = !nameLabel.isHidden
    }
    @IBOutlet weak var nameLabel: UILabel!
    

    
    func updateView() {
        nameLabel.text = card?.name ?? ""
        descriptionTextView.text = card?.description ?? ""
    }
}
