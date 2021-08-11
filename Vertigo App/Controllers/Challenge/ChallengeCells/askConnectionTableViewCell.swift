//
//  askConnectionTableViewCell.swift
//  Vertigo App
//
//  Created by Henit Work on 24/06/21.
//

import UIKit
import Firebase

class askConnectionTableViewCell: UITableViewCell {

    @IBOutlet weak var askButton: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var connectionName: UILabel!
    @IBOutlet weak var connectionImage: UIImageView!
    
    var db = Firestore.firestore()
    var ku = KUserDetails()
    var kn = Knotifications()
    
    var ChallengeName = "1"
    var ChallengeID = "2"
    var ChallengeTime = "3"
    var ChallengeDate = "4"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.cornerRadius = 15
        connectionImage.layer.cornerRadius = 26
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            print(self.ChallengeName, self.ChallengeDate, self.ChallengeID, self.ChallengeTime)
        }
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
    
    func sendTypeThreeRequest(to targetName : String){
        db.collection("All Users").whereField(ku.userName, isEqualTo: targetName).getDocuments { (querySnapshot, error) in
            if let e = error{
                print(e.localizedDescription)
            }
            else {
                if let snapshotDocuments = querySnapshot?.documents {
                    let doc = snapshotDocuments.first
                    if let email = doc![self.ku.userEmail]{
                        self.db.collection(email as! String).document(self.kn.notifications).collection(self.kn.notificationTypeThree).addDocument(data: [self.kn.notificationType : self.kn.notificationTypeThree,self.kn.askerEmail : (Auth.auth().currentUser?.email)!, self.kn.time : self.getTime(), self.kn.forChallenge : self.ChallengeName, self.kn.channel : self.ChallengeID,self.kn.challengeTime : self.ChallengeTime, self.kn.challengeDate : self.ChallengeDate])
                    }
                }
            }
        }
    }
    
    
    func cancelTypeThreeRequest(to targetName : String){
        db.collection("All Users").whereField(ku.userName, isEqualTo: targetName).getDocuments { (querySnapshot, error) in
            if let e = error{
                print(e.localizedDescription)
            }
            else {
                if let snapshotDocuments = querySnapshot?.documents {
                    let doc = snapshotDocuments.first
                    if let email = doc![self.ku.userEmail]{
                        self.db.collection(email as! String).document(self.kn.notifications).collection(self.kn.notificationTypeThree).whereField(self.kn.askerEmail, isEqualTo: (Auth.auth().currentUser?.email)!).getDocuments { (querySnapshot, error) in
                            if let e = error {
                                print(e.localizedDescription)
                            }
                            else
                            {
                                if let snapshotDocuments = querySnapshot?.documents{
                                    let doc = snapshotDocuments.first
                                    if let reference = doc?.documentID{
                                        self.db.collection(email as! String).document(self.kn.notifications).collection(self.kn.notificationTypeThree).document(reference).delete()
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func didTapAskButton(_ sender: UIButton) {
        if (askButton.currentImage == #imageLiteral(resourceName: "372raisedhand2_100287"))
        {
            askButton.setImage(#imageLiteral(resourceName: "right-true-verify-perfect-trust-64-32776"), for: .normal)
            sendTypeThreeRequest(to: connectionName.text!)
            
        }
        else
        {
            askButton.setImage(#imageLiteral(resourceName: "372raisedhand2_100287"), for: .normal)
            cancelTypeThreeRequest(to: connectionName.text!)
        }
        
    }
    
    
}
