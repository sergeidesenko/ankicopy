//
//  ViewController.swift
//  ankicopy
//
//  Created by user on 03.11.2020.
//

import UIKit

class AnkiViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var cardsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cards.append(Card(name: "a", description: "b", image: nil))
        cardsTableView.delegate = self
        cardsTableView.dataSource = self
    }

    var cards = Array<Card>()
    
    func addCard(_ card: Card){
        cards.append(card)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "FromAnkiToCard") {
            if let vc = segue.destination as? CardViewController, let card = sender as? Card {
                debugPrint(card)
                vc.card = card
            }
        }
    }
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue){
        
    }

    
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
}

