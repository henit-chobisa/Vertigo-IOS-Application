//
//  NotificationsViewController.swift
//  Vertigo App
//
//  Created by Henit Work on 20/06/21.
//

import UIKit
import Firebase
import Kingfisher

class NotificationsViewController: UIViewController {
    
    @IBOutlet weak var weareclearlabel: UILabel!
    @IBOutlet weak var notificationTableView: UITableView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var topView: UIView!
    let db = Firestore.firestore()
    var userNotifications : [RecievedNotification] = []
    let knf = Knotifications()
    let kud = KUserDetails()
    var typeThreeNotifications : [askerNotification] = []
    
    override func viewWillAppear(_ animated: Bool) {
        topView.layer.cornerRadius = 15
        userImage.layer.borderWidth = 1
        userImage.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        userImage.layer.cornerRadius = 23
        
    }
    
    
    func loadImage(imageUrl : String, myimage : UIImageView ){
        let url = URL.init(string: imageUrl)
        let imageResourse = ImageResource.init(downloadURL: url!)
        myimage.kf.setImage(with: imageResourse)
    }
    
    struct askerNotification{
        var notificationType : String?
        var askerEmail : String?
        var id : String?
        var challengeDate : String?
        var challengeTime : String?
        var challengeName : String?
        var time : [Int]
    }
    
    
    func checkfornotifications(){
        
        self.userNotifications = []
        self.typeThreeNotifications = []
        
        db.collection((Auth.auth().currentUser?.email)!).document(knf.notifications).collection(knf.notificationTypeTwo).addSnapshotListener { (querySnapShot, error) in
            if let e = error {
                print(e.localizedDescription)
            }
            else{
                if let snapshotDocuments = querySnapShot?.documents{
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let whichNotification = data[self.knf.notificationType], let sender = data[self.knf.connector], let time = data[self.knf.time] {
                            let myNotification = RecievedNotification(NotificationType: whichNotification as? String, byEmail: sender as? String, Time: ((time as? [Int])!))
                            self.userNotifications.append(myNotification)
                            
                        }
                    }
                    self.notificationTableView.reloadData()
                    
                }
            }
        }
        
        db.collection((Auth.auth().currentUser?.email)!).document(knf.notifications).collection(knf.notificationTypeOne).addSnapshotListener { (querySnapshot, error) in
            
            if (error == nil){
                if let snapshotdocuments = querySnapshot?.documents{
                    for doc in snapshotdocuments{
                        let data = doc.data()
                        if let whichNotification = data[self.knf.notificationType],let sender = data[self.knf.requester],let time = doc[self.knf.time]{
                            let myNotification = RecievedNotification(NotificationType: whichNotification as? String, byEmail: sender as? String,Time : (time as? [Int])! )
                            self.userNotifications.append(myNotification)
                            
                        }
                    }
                    self.notificationTableView.reloadData()
                }
                
                
            }
            else{
                print(error!.localizedDescription)
            }
            
        }
        
        db.collection((Auth.auth().currentUser?.email)!).document(knf.notifications).collection(knf.notificationTypeThree).addSnapshotListener { (querySnapshot, error) in
            if let e = error {
                print(e.localizedDescription)
            }
            else{
                if let snapshotDocuments = querySnapshot?.documents{
                    for doc in snapshotDocuments{
                        let data = doc.data()
                        if let whichNotification = data[self.knf.notificationType] as? String, let asker = data[self.knf.askerEmail] as? String, let time = doc[self.knf.time] as? [Int], let channel = data[self.knf.channel] as? String, let date = doc[self.knf.challengeDate], let challengeName = doc[self.knf.forChallenge], let challengeTime = doc[self.knf.challengeTime] {
                            
                            let myNotification = askerNotification(notificationType: whichNotification, askerEmail: asker, id : channel, challengeDate : date as? String, challengeTime: challengeTime as? String, challengeName: challengeName as? String ,time: time)
                            
                            self.typeThreeNotifications.append(myNotification)
                            
                        }
                    }
                    self.notificationTableView.reloadData()
                }
            }
        }
        
       
        
    }
    
    @IBAction func reloadButtonPressed(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.checkfornotifications()
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadImage()
        notificationTableView.register(UINib.init(nibName: "NotificationTypeOneCell", bundle: nil), forCellReuseIdentifier: "notificationCellOne")
        notificationTableView.register(UINib.init(nibName: "NotificationTypeTwoCell", bundle: nil), forCellReuseIdentifier: "notificationCellTwo")
        notificationTableView.register(UINib.init(nibName: "NotificationTypeThreeCell", bundle: nil), forCellReuseIdentifier: "notificationCellThree")
        
        notificationTableView.dataSource = self
        notificationTableView.rowHeight = 83
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.checkfornotifications()
            
        }

        // Do any additional setup after loading the view.
    }
    
    func loadImage(){
        db.collection((Auth.auth().currentUser?.email)!).getDocuments { (query, error) in
            for doc in query!.documents{
                let imageUrl = doc["Image"] as! String
                let url = URL.init(string: imageUrl)
                let imageResourse = ImageResource.init(downloadURL: url!)
                self.userImage.kf.setImage(with: imageResourse)
                
            }
        }
    }

}
extension NotificationsViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (userNotifications.count + typeThreeNotifications.count == 0){
            weareclearlabel.isHidden = false
        }
        else{
            weareclearlabel.isHidden = true
        }
        return userNotifications.count + typeThreeNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if (indexPath.row < userNotifications.count){
            if (userNotifications[indexPath.row].NotificationType == knf.notificationTypeOne){
                let cell = notificationTableView.dequeueReusableCell(withIdentifier: "notificationCellOne", for: indexPath) as! NotificationTypeOneCell
                
                DispatchQueue.main.async {
                    let mail = self.userNotifications[indexPath.row].byEmail
                    self.db.collection("All Users").whereField(self.kud.userEmail, isEqualTo: mail!).getDocuments { (query, error) in
                        for doc in query!.documents{
                            let name = doc[self.kud.userName] as! String
                            let imageURLString = doc[self.kud.image] as? String
                            cell.mainLabel.text = "\(name) wants to connect"
                            self.loadImage(imageUrl: imageURLString!, myimage: cell.senderImage)
                            cell.timeLabel.text = "\(self.userNotifications[indexPath.row].Time[2])/\(self.userNotifications[indexPath.row].Time[1]), \(self.userNotifications[indexPath.row].Time[3]):\(self.userNotifications[indexPath.row].Time[4])"
                            
                        }
                    }
                }
                return cell
                
            }
            
            else {
                let cell = notificationTableView.dequeueReusableCell(withIdentifier: "notificationCellTwo", for: indexPath) as! NotificationTypeTwoCell
                
                if (userNotifications[indexPath.row].NotificationType! == "connectionApproved"){
                    DispatchQueue.main.async {
                        let mail = self.userNotifications[indexPath.row].byEmail
                      
                        self.db.collection("All Users").whereField(self.kud.userEmail, isEqualTo: mail!).getDocuments { (query, error) in
                            for doc in query!.documents{
                                let name = doc[self.kud.userName] as! String
                                let imageURLString = doc[self.kud.image] as? String
                                cell.notificationLabel.text = "\(name) has accepted your connection request"
                                self.loadImage(imageUrl: imageURLString!, myimage: cell.userImage)
                                cell.timeLabel.text = "\(self.userNotifications[indexPath.row].Time[2])/\(self.userNotifications[indexPath.row].Time[1]), \(self.userNotifications[indexPath.row].Time[3]):\(self.userNotifications[indexPath.row].Time[4])"
                                
                            }
                    }
                    }
                }
                
                else {
                    DispatchQueue.main.async {
                        let mail = self.userNotifications[indexPath.row].byEmail
                      
                        self.db.collection("All Users").whereField(self.kud.userEmail, isEqualTo: mail!).getDocuments { (query, error) in
                            for doc in query!.documents{
                                let name = doc[self.kud.userName] as! String
                                let imageURLString = doc[self.kud.image] as? String
                                cell.notificationLabel.text = "\(name) has accepted your challenge request, he will be there!"
                                self.loadImage(imageUrl: imageURLString!, myimage: cell.userImage)
                                cell.timeLabel.text = "\(self.userNotifications[indexPath.row].Time[2])/\(self.userNotifications[indexPath.row].Time[1]), \(self.userNotifications[indexPath.row].Time[3]):\(self.userNotifications[indexPath.row].Time[4])"
                            }
                    }
                    }
                }
                
                return cell
                
            }
        }

        
        else {
            
            let tracker = indexPath.row - userNotifications.count
            
            let cell = notificationTableView.dequeueReusableCell(withIdentifier: "notificationCellThree", for: indexPath) as! NotificationTypeThreeCell
            
            
            DispatchQueue.main.async {
                let mail = self.typeThreeNotifications[tracker].askerEmail
                
                self.db.collection("All Users").whereField(self.kud.userEmail, isEqualTo: mail!).getDocuments { (query, error) in
                    for doc in query!.documents{
                        let name = doc[self.kud.userName] as! String
                        let imageURLString = doc[self.kud.image] as? String
                        let challengeName = self.typeThreeNotifications[tracker].challengeName
                        let challengeDate = self.typeThreeNotifications[tracker].challengeDate
                        let challengeTime = self.typeThreeNotifications[tracker].challengeTime
                        let challengeID = self.typeThreeNotifications[tracker].id
                        
                        cell.ChallengeName = challengeName!
                        cell.ChallengeDate = challengeDate!
                        cell.ChallengeOwner = mail!
                        cell.ChallengeTime = challengeTime!
                        cell.channel = challengeID!

                        
                        cell.notificationLabel.text = "\(name) has asked you to join \(challengeName!) challenge hosted by him for \(challengeDate!), \(challengeTime!)"
                        self.loadImage(imageUrl: imageURLString!, myimage: cell.userImage)
                        cell.timeLabel.text = "\(self.typeThreeNotifications[tracker].time[2])/\(self.typeThreeNotifications[tracker].time[1]), \(self.typeThreeNotifications[tracker].time[3]):\(self.typeThreeNotifications[tracker].time[4])"
                    }
            }
            }
            
            return cell
        }
    }
}
