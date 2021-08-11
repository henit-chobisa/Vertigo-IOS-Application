//
//  askFriendViewController.swift
//  Vertigo App
//
//  Created by Henit Work on 24/06/21.
//

import UIKit
import Firebase
import Kingfisher

class askFriendViewController: UIViewController {

    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var connectionTableView: UITableView!
    
    var af = AccessoryFunctions()
    let db = Firestore.firestore()
    let kinter = Kinteraction()
    var connections : [String] = []
    
    var challengeID = ""
    var challengeName = ""
    var challengeTime = ""
    var challengeDate = ""
    
    
    override func viewWillAppear(_ animated: Bool) {
        searchBar.layer.cornerRadius = 15
        searchBar.layer.borderColor = #colorLiteral(red: 0.9725160003, green: 0.2743841112, blue: 0.07287726551, alpha: 1)
        searchBar.layer.borderWidth = 1
        af.creatArtributedPlaceholder(Feild: searchBar, LabelOnHolder: "Search Individual", Color: .gray)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectionTableView.dataSource = self
        connectionTableView.register(UINib(nibName: "askConnectionTableViewCell", bundle: nil), forCellReuseIdentifier: "askConnection")
        connectionTableView.rowHeight = 82
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.loadFriends()
        }

        
    }
    
    func loadImage(imageUrl : String, myimage : UIImageView ){
        let url = URL.init(string: imageUrl)
        let imageResourse = ImageResource.init(downloadURL: url!)
        myimage.kf.setImage(with: imageResourse)
    }
    
    func loadFriends(){
        
        connections = []
        
        db.collection((Auth.auth().currentUser?.email)!).document(kinter.interations).collection(kinter.Connections).addSnapshotListener { (querySnapshot, error) in
            if let e = error {
                print(e.localizedDescription)
            }
            else{
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let email = data[self.kinter.connectionEmail]{
                            self.connections.append(email as! String)
                        }
                    }
                    self.connectionTableView.reloadData()
                }
                
            }
        }
    }
    
}

extension askFriendViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        connections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = connectionTableView.dequeueReusableCell(withIdentifier: "askConnection", for: indexPath) as! askConnectionTableViewCell
        
        db.collection("All Users").whereField("Email", isEqualTo: connections[indexPath.row]).getDocuments { (querySnapshot, error) in
            if let e = error {
                print(e.localizedDescription)
            }
            else {
                if let snapshotDocument = querySnapshot?.documents {
                    let doc = snapshotDocument.first
                    if let data = doc?.data() {
                        
                        cell.connectionName.text = data["Name"] as? String
                        cell.ChallengeName = self.challengeName
                        cell.ChallengeID = self.challengeID
                        cell.ChallengeTime = self.challengeTime
                        cell.ChallengeDate = self.challengeDate
                        self.loadImage(imageUrl: data["Image"] as! String, myimage: (cell.connectionImage)!)
                        
                    }
                }
            }
        }
        return cell
    }
}
