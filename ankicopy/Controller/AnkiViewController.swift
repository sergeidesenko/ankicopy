//
//  ViewController.swift
//  ankicopy
//
//  Created by user on 03.11.2020.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class AnkiViewController: UIViewController {

    var CDCards = Array<CDCard>()
    var cards = Array<Card>()
    
    @IBOutlet weak var cardsTableView: UITableView!
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue){
        fetchCoreData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cardsTableView.delegate = self
        cardsTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCoreData()
    }

    
    func addCard(_ card: Card){
        cards.append(card)
        
    }
    
    func fetchCoreData(){
        self.fetch{ (complete) in
            if complete{
                if CDCards.count > 0 {
                    convertCDCardsToCards()
                    cardsTableView.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "FromAnkiToCard") {
            if let vc = segue.destination as? CardViewController, let card = sender as? Card {
                debugPrint(card)
                vc.card = card
            }
        }
    }
}
extension AnkiViewController{
    func fetch(completion: (_ complete: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {completion(false)
            return}
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDCard")
        do{
           CDCards = try managedContext.fetch(fetchRequest) as? Array<CDCard> ?? Array<CDCard>()
            completion(true)
        }catch{
            debugPrint("Could not fetch: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func convertCDCardsToCards(){
        cards = []
        for CDCard in CDCards {
            var image: UIImage? = nil
            if CDCard.cardImage != nil{
                image = UIImage(data: CDCard.cardImage!)
            }
            cards.append(Card(name: CDCard.cardName ?? "", description: CDCard.cardDescription ?? "", image: image))
        }
    }
    
    func removeCard(atIndexPath indexPath: IndexPath, completion: (Bool) -> ()){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {
            completion(false)
            return
        }
        managedContext.delete(CDCards[indexPath.row])
        do{
            try managedContext.save()
            debugPrint("Successfully removed card at: \(indexPath.row)")
            completion(true)
        } catch {
            debugPrint("Couldnt remove: \(error.localizedDescription)")
            completion(false)
        }
    }
}

extension AnkiViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell") as? CardTableViewCell{
            cell.nameLabel.text = cards[indexPath.row].name
            return cell
        }
        return CardTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        performSegue(withIdentifier: "FromAnkiToCard", sender: cards[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
      let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { (action, view, success) in
        self.removeCard(atIndexPath: indexPath){ (complete) in
            if complete{
                self.CDCards.remove(at: indexPath.row)
                self.cards.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                self.cardsTableView.reloadData()
            }
        }
      })
      deleteAction.backgroundColor = .red
      return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

