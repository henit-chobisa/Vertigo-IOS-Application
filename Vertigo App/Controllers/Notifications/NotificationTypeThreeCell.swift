//
//  NotificationTypeThreeCell.swift
//  Vertigo App
//
//  Created by Henit Work on 26/06/21.
//

import UIKit
import Firebase

class NotificationTypeThreeCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    var channel = ""
    var ChallengeName = ""
    var ChallengeTime = ""
    var ChallengeDate = ""
    var ChallengeOwner = ""
    
    var kc = KChallenge()
    var knf = Knotifications()
    
    
    var db = Firestore.firestore()
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.cornerRadius = 15
        userImage.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getTime()->[Int]{
        let date = Date()
        let calendar = Calendar.current
        let currentdate = calendar.component(.day, from: date)
        let currentmonth = calendar.component(.month, from: date)
        let currentyear = calendar.component(.year, from: date)
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
        
        return [currentyear,currentmonth,currentdate,hour,minutes,second]
    }
    
    @IBAction func didTapAcceptButton(_ sender: UIButton) {
        var reference1 = ""
        var reference2 = ""
        
        
        acceptButton.setImage(#imageLiteral(resourceName: "people_white_144x144"), for: .normal)
        
        db.collection((Auth.auth().currentUser?.email)!).document("Challenges").collection(channel).addDocument(data: [kc.challengeName : kc.ecoJog, kc.id : channel, kc.date : ChallengeDate, kc.time : ChallengeTime, kc.Host : ChallengeOwner])
        
        db.collection(ChallengeOwner).document(knf.notifications).collection(knf.notificationTypeTwo).addDocument(data : [knf.notificationType : "challengeApproved",knf.connector:(Auth.auth().currentUser?.email)!,knf.time: getTime()])
        
        db.collection((Auth.auth().currentUser?.email)!).document(knf.notifications).collection(knf.notificationTypeThree).whereField(knf.askerEmail, isEqualTo: ChallengeOwner).getDocuments { (querySnapshot, error) in
            if let e = error {
                print(e.localizedDescription)
            }
            else {
                if let documents = querySnapshot?.documents{
                    let doc = documents.first
                    if let document = doc {
                        reference1 = document.documentID
                    }
                    self.db.collection((Auth.auth().currentUser?.email)!).document(self.knf.notifications).collection(self.knf.notificationTypeThree).document(reference1).delete()
                }
            }
        }
        db.collection(ChallengeOwner).document("Challenges").collection(channel).whereField(kc.time, isEqualTo: ChallengeTime).getDocuments { (querySnapshot, error) in
            if let e = error{
                print(e.localizedDescription)
            }
            else {
                if let documents = querySnapshot?.documents{
                    let doc = documents.first
                    if let document = doc {
                        reference2 = document.documentID
                    }
                    self.db.collection(self.ChallengeOwner).document("Challenges").collection(self.channel).document(reference2).updateData(["Members" : FieldValue.arrayUnion([(Auth.auth().currentUser?.email)!])])
                }
            }
        }
        
        
        
    }
    
    
}
