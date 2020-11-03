//
//  NewCardViewController.swift
//  ankicopy
//
//  Created by user on 03.11.2020.
//

import UIKit

class NewCardViewController: UIViewController, UITextViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2470588235)
        nameTextField.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4980392157)
        nameTextField.layer.borderWidth = 1
        descriptionTextView.delegate = self
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FromNewCardToAnki"{
            if let vc = segue.destination as? AnkiViewController, let card = sender as? Card{
                vc.addCard(card)
            }
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    @IBAction func didEndEnteringName(_ sender: Any) {
    }
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBAction func didTapCreate(_ sender: Any) {
        if nameTextField.text != "" && nameTextField.text != "Name"{
            if descriptionTextView.text != "" && descriptionTextView.text != "Description"{
                let card = Card(name: nameTextField.text!, description: descriptionTextView.text!, image: nil)
                performSegue(withIdentifier: "FromNewCardToAnki", sender: card)
            }
        }
    }
    @IBOutlet weak var nameTextField: UITextField!
    
}
