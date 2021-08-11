//
//  PeopleViewController.swift
//  Vertigo App
//
//  Created by Henit Work on 20/06/21.
//

import UIKit
import Firebase
import Kingfisher

class PeopleViewController: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var searchFeild: UITextField!
    let af = AccessoryFunctions()
    
    let kinter = Kinteraction()
    let db = Firestore.firestore()
    
    struct userInfo {
        var name : String?
        var ImageURL : String?
    }
    
    @IBOutlet weak var switchControl: UISegmentedControl!
    
    struct Person {
        var type : String?
        var Email : String?
    }
    
    var connections : [Person] = []
    var requests : [Person] = []
    var sentRequest : [Person] = []
    var around : [Person] = []
    
    override func viewWillAppear(_ animated: Bool) {
        topView.layer.cornerRadius = 15
        userImage.layer.cornerRadius = 23
        userImage.layer.borderWidth = 1
        userImage.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        searchFeild.layer.cornerRadius = 10
        searchFeild.layer.borderWidth = 1
        searchFeild.layer.borderColor = #colorLiteral(red: 0.9725160003, green: 0.2743841112, blue: 0.07287726551, alpha: 1)
        af.creatArtributedPlaceholder(Feild: searchFeild, LabelOnHolder: "Search Individual", Color: .lightGray)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTableView.register(UINib(nibName: "ConnectionsTableViewCell", bundle: nil), forCellReuseIdentifier: "connectionCell")
        mainTableView.register(UINib(nibName: "RequestTableViewCell", bundle: nil), forCellReuseIdentifier: "requestCell")
        mainTableView.register(UINib(nibName: "AroundTableViewCell", bundle: nil), forCellReuseIdentifier: "aroundCell")
        mainTableView.register(UINib(nibName: "SentRequestTableViewCell", bundle: nil), forCellReuseIdentifier: "sentRequestCell")
        mainTableView.dataSource = self
        mainTableView.rowHeight = 82
        self.loadPeople()
        self.loadImage()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.mainTableView.reloadData()
        }
        
        

        
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
    
    @IBAction func switchControlChanged(_ sender: UISegmentedControl) {
        
        mainTableView.reloadData()
    }
    
    
    func loadImage(imageUrl : String, myimage : UIImageView ){
        let url = URL.init(string: imageUrl)
        let imageResourse = ImageResource.init(downloadURL: url!)
        myimage.kf.setImage(with: imageResourse)
    }
    
    func getData(of email : String) -> userInfo{
        var information = userInfo()
        db.collection(email).getDocuments { (querySnapshot, error) in
            if let e = error {
                print(e.localizedDescription)
            }
            else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let Name = data["Name"] as? String, let ImageURL = data["Image"] as? String{
                            information = userInfo(name: Name, ImageURL: ImageURL)
                        }
                    }
                }
            }
        }
        return information
        
    }
    
    
    func loadPeople(){
        connections = []
        requests = []
        sentRequest = []
        around = []
        
        
        db.collection((Auth.auth().currentUser?.email)!).document(kinter.interations).collection(kinter.SentRequests).addSnapshotListener { (querySnapshot, error) in
            if let e = error {
                print(e.localizedDescription)
            }
            else{
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        let type = "SentRequest"
                        if let email = data[self.kinter.requestedtoEmail]{
                            let individual = Person(type: type, Email: (email as? String)!)
                            self.sentRequest.append(individual)
                            
                        }
                    }
                }
                
            }
        }
        
        db.collection((Auth.auth().currentUser?.email)!).document(kinter.interations).collection(kinter.Requests).addSnapshotListener { (querySnapshot, error) in
            if let e = error {
                print(e.localizedDescription)
            }
            else{
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        let type = "Request"
                        if let email = data[self.kinter.requesterEmail]{
                            let individual = Person(type: type, Email: (email as? String)!)
                            self.requests.append(individual)
                            
                        }
                    }
                }
                
            }
        }
        
        db.collection((Auth.auth().currentUser?.email)!).document(kinter.interations).collection(kinter.Connections).addSnapshotListener { (querySnapshot, error) in
            if let e = error {
                print(e.localizedDescription)
            }
            else{
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        let type = "Connection"
                        if let email = data[self.kinter.connectionEmail]{
                            let individual = Person(type: type, Email: (email as? String)!)
                            self.connections.append(individual)
                            
                        }
                    }
                }
                
            }
        }
        
        db.collection("All Users").addSnapshotListener { (querySnapshot, error) in
            if let e = error {
                print(e.localizedDescription)
            }
            else{
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        let type = "Around"
                        if let email = data["Email"]{
                            let individual = Person(type: type, Email: (email as? String)!)
                            self.around.append(individual)
                            
                        }
                    }
                }
                
            }
            
        }
        DispatchQueue.main.async {
            self.mainTableView.reloadData()
        }
        
        
    }
}

extension PeopleViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch switchControl.selectedSegmentIndex {
        case 0 :
            return connections.count
            
        case 1 :
            return requests.count
        
        case 2 :
            return sentRequest.count
        
        case 3 :
            return around.count
            
        default:
            print("Invalid Selection")
            return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let backView = UIView()
        backView.backgroundColor = UIColor(red: 213/255, green: 94.0/255, blue: 59.0/255, alpha: 0.4)
        backView.layer.cornerRadius = 20
        
        switch switchControl.selectedSegmentIndex {
        case 0 :
            let cell = mainTableView.dequeueReusableCell(withIdentifier: "connectionCell", for: indexPath) as! ConnectionsTableViewCell
            let mail = connections[indexPath.row].Email
            
            db.collection(mail!).getDocuments { (querySnapshot, error) in
                if let e = error {
                    print(e.localizedDescription)
                }
                else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let Name = data["Name"] as? String, let ImageURL = data["Image"] as? String{
                                cell.mainLabel.text = Name
                                self.loadImage(imageUrl: ImageURL, myimage: cell.userImage)
                                cell.selectedBackgroundView = backView
                            }
                        }
                    }
                }
            }
            cell.selectedBackgroundView = backView
            
            return cell
            
            
        case 1 :
            let cell = mainTableView.dequeueReusableCell(withIdentifier: "requestCell", for: indexPath) as! RequestTableViewCell
            
            let mail = requests[indexPath.row].Email
            db.collection(mail!).getDocuments { (querySnapshot, error) in
                if let e = error {
                    print(e.localizedDescription)
                }
                else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let Name = data["Name"] as? String, let ImageURL = data["Image"] as? String{
                                cell.mainLabel.text = Name
                                self.loadImage(imageUrl: ImageURL, myimage: cell.userImage)
                                cell.selectedBackgroundView = backView
                            }
                        }
                    }
                }
            }
            cell.selectedBackgroundView = backView
            
            return cell
            
        
        case 2 :
            let cell = mainTableView.dequeueReusableCell(withIdentifier: "sentRequestCell", for: indexPath) as! SentRequestTableViewCell
            let mail = sentRequest[indexPath.row].Email
            db.collection(mail!).getDocuments { (querySnapshot, error) in
                if let e = error {
                    print(e.localizedDescription)
                }
                else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let Name = data["Name"] as? String, let ImageURL = data["Image"] as? String{
                                cell.userName.text = Name
                                self.loadImage(imageUrl: ImageURL, myimage: cell.userImage)
                                cell.selectedBackgroundView = backView
                            }
                        }
                    }
                }
            }
            cell.selectedBackgroundView = backView
            
            return cell
            
        
        case 3 :
            
            let cell = mainTableView.dequeueReusableCell(withIdentifier: "aroundCell", for: indexPath) as! AroundTableViewCell
            let mail = around[indexPath.row].Email
            
            db.collection(mail!).getDocuments { (querySnapshot, error) in
                if let e = error {
                    print(e.localizedDescription)
                }
                else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let Name = data["Name"] as? String, let ImageURL = data["Image"] as? String{
                                cell.mainLabel.text = Name
                                self.loadImage(imageUrl: ImageURL, myimage: cell.userImage)
                                cell.selectedBackgroundView = backView
                            }
                        }
                    }
                }
            }
            return cell
            
            
        default:
            let cell = mainTableView.dequeueReusableCell(withIdentifier: "aroundCell", for: indexPath) as! AroundTableViewCell
            return cell
            
        }
        
    }
    
    
}


