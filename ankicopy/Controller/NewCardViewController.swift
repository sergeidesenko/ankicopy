//
//  NewCardViewController.swift
//  ankicopy
//
//  Created by user on 03.11.2020.
//

import UIKit
import CoreData

class NewCardViewController: UIViewController, UITextViewDelegate, ImagePickerDelegate {
    
    var newCard: Card?
    var imagePicker: ImagePicker!
    var image: UIImage?
    var cardName: String?
    var cardDescription: String?
    
    @IBAction func didEndEnteringName(_ sender: Any) {
    }
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func didTapOnAddPhoto(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    @IBAction func didTapCreate(_ sender: Any) {
        if nameTextField.text != "" && nameTextField.text != "Name"{
            if descriptionTextView.text != "" && descriptionTextView.text != "Description"{
                let card = Card(name: nameTextField.text!, description: descriptionTextView.text!, image: image)
                saveCard(card){ (complete) in
                    if complete{
                        debugPrint("Successfully saved new card")
                    }
                    else{
                        debugPrint("Couldnt save the card")
                    }
                    
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.delegate = self
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        configureViews()
        setupTextFields()
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "FromNewCardToAnki"{
//            if let vc = segue.destination as? AnkiViewController, let card = sender as? Card{
//                vc.addCard(card)
//            }
//        }
//    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text ==  "Description"{
            textView.text = ""
        }
        textView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    func setupTextFields() {
            let toolbar = UIToolbar()
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
            let doneButton = UIBarButtonItem(title: "Done", style: .done,
                                             target: self, action: #selector(doneButtonTapped))
            
            toolbar.setItems([flexSpace, doneButton], animated: true)
            toolbar.sizeToFit()
            
            nameTextField.inputAccessoryView = toolbar
            descriptionTextView.inputAccessoryView = toolbar
        }
        
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }
    func didSelect(image: UIImage?) {
        self.image = image
        if let image = image{
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
        }
    }
    
    func saveCard(_ card: Card, completion: (_ finished: Bool) -> ()){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else{
            completion(false)
            return
        }
        let coreDataCard = CDCard(context: managedContext)
        coreDataCard.cardName = card.name
        coreDataCard.cardDescription = card.description
        if let imageData = card.image?.pngData(){
            coreDataCard.cardImage = imageData
        }
        do {
            try managedContext.save()
            completion(true)
        } catch {
            debugPrint("Couldnt save the new card: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func configureViews(){
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4980392157)
        nameTextField.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4980392157)
        nameTextField.layer.borderWidth = 1
        imageView.layer.cornerRadius = 25
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4980392157)
    }
    
    
}


