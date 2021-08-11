//
//  CollectionViewCell.swift
//  Vertigo App
//
//  Created by Henit Work on 20/06/21.
//

import UIKit
import Firebase

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var emailfeild: UILabel!
    let db = Firestore.firestore()
    let kinter = Kinteraction()
    let knf = Knotifications()
    
    let cm = ConnectionMechanism()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImage.layer.cornerRadius = 45
        userImage.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        userImage.layer.borderWidth = 1
        sendButton.layer.cornerRadius = 7
        
    }
    
    @IBAction func operationPlaced(_ sender: UIButton) {
        if (sender.currentTitle == "Add"){
            sender.setTitle("Delete", for: .normal)
            cm.sendRequest(to: emailfeild.text!)
            cm.sendTypeOneNotification(to: emailfeild.text!)
            DispatchQueue.main.async {
                self.sendButton.backgroundColor = .red
                self.sendButton.setTitleColor(.white, for: .normal)
                
            }
        }
        else if (sender.currentTitle == "Accept"){
            
            DispatchQueue.main.async {
                self.cm.readyforfriend(to: self.emailfeild.text!)
            }
            
            sender.setTitle("Disconnect", for: .normal)
            cm.AddFriend(from: emailfeild.text!)
            cm.sendTypeTwoNotification(to: emailfeild.text!)
            DispatchQueue.main.async {
                self.sendButton.backgroundColor = .white
                self.sendButton.setTitleColor(.red, for: .normal)
            }
        }
        else if (sender.currentTitle == "Disconnect"){
            sender.setTitle("Add", for: .normal)
            cm.cancelFriend(which: emailfeild.text!)
            DispatchQueue.main.async {
                self.sendButton.backgroundColor = .white
                
                self.sendButton.setTitleColor(.init(red: 213/255, green: 94/255, blue: 59/255, alpha: 1.0), for: .normal)
                
            }
            
        }
        else {
            sender.setTitle("Add", for: .normal)
            cm.cancelRequest(to: emailfeild.text!)
            DispatchQueue.main.async {
                self.sendButton.backgroundColor = .white
                self.sendButton.setTitleColor(.init(red: 213/255, green: 94/255, blue: 59/255, alpha: 1.0), for: .normal)
            }
        }
        
    }
    
}
