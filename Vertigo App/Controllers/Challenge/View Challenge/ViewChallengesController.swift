//
//  ViewChallengesController.swift
//  Vertigo App
//
//  Created by Henit Work on 12/07/21.
//

import UIKit
import Firebase
import Kingfisher

class ViewChallengesController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var challengeTableView: UITableView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var topView: UIView!
    var db = Firestore.firestore()
    
    var events : [Event] = []
    var members : [[String]] = []
    var challengesGenerated : [String] = []
    
    
    override func viewWillAppear(_ animated: Bool) {
        userImage.layer.cornerRadius = 26
        topView.layer.cornerRadius = 15
        DispatchQueue.main.async {
            self.loadEvents()
        }
        challengeTableView.rowHeight = 235
        challengeTableView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadImage()
        
        challengeTableView.register(UINib(nibName: "ViewChallengeTableViewCell", bundle: nil), forCellReuseIdentifier: "viewChallenge")
        challengeTableView.dataSource = self
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "preparationScreen", sender: self)
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
    
    func loadEvents (){
        events = []
        members = []
        challengesGenerated = []
        
        db.collection((Auth.auth().currentUser?.email)!).document("Challenges").collection("ChannelsGenerated").getDocuments { (querySnapshot, error) in
            if let e = error {
                print(e.localizedDescription)
            }
            else {
                if let documents = querySnapshot?.documents {
                    for doc in documents {
                        let channel = doc["Channel"] as! String
                        print(channel)
                        self.challengesGenerated.append(channel)
                    }
                    for channel in self.challengesGenerated {
                        print(channel)
                        self.db.collection((Auth.auth().currentUser?.email)!).document("Challenges").collection(channel).getDocuments { (querySnapshot, error) in
                            if let documents = querySnapshot?.documents{
                                if let doc = documents.first{
                                    
                                    let challengename = doc["ChallengeName"] as! String
                                    let challengetime = doc["Time"] as! String
                                    let challengeDate = doc["Date"] as! String
                                    let challengeID = doc["ID"] as! String
                                    var challengeMembers = doc["Members"] as! [String]
                                    let myEvent = Event(ChallengeName: challengename, ChallengeDate: challengeDate, ChallengeTime: challengetime, ChallengeID: challengeID)
                                    
                                    self.events.append(myEvent)
                                    self.members.append(challengeMembers)
                                    
                                    
                                }
                                self.challengeTableView.reloadData()
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "preparationScreen"{
            if let VC = segue.destination as? startNowViewController {
                let indexPath = challengeTableView.indexPathForSelectedRow
                VC.eventDetails = events[indexPath!.row]
                VC.membersArray = members[indexPath!.row]
            }
        }
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension ViewChallengesController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = challengeTableView.dequeueReusableCell(withIdentifier: "viewChallenge") as! ViewChallengeTableViewCell
        cell.members = members[indexPath.row]
        cell.channel.text = events[indexPath.row].ChallengeID
        cell.date.text = events[indexPath.row].ChallengeDate
        cell.time.text = events[indexPath.row].ChallengeTime
        cell.titleLabel.text = events[indexPath.row].ChallengeName
        
        return cell
    }
    
}
