//
//  ChallengeViewController.swift
//  Vertigo App
//
//  Created by Henit Work on 20/06/21.
//

import UIKit
import WebKit
import Firebase
import Kingfisher

class ChallengeViewController: UIViewController, UITableViewDelegate {


    @IBOutlet weak var topView: UIView!
    let db = Firestore.firestore()
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var mainTableView: UITableView!
    
    var banner : [UIImage] = [#imageLiteral(resourceName: "Ecojog Banner"), #imageLiteral(resourceName: "Divine Banner"), #imageLiteral(resourceName: "Kratos Banner"), #imageLiteral(resourceName: "Wanderer Banner"), #imageLiteral(resourceName: "Create banner")]
    
    override func viewWillAppear(_ animated: Bool) {
        topView.layer.cornerRadius = 15
        profileImageView.layer.cornerRadius = 26
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.dataSource = self
        mainTableView.delegate = self
        mainTableView.register(UINib(nibName: "ChallengeTableViewCell", bundle: nil), forCellReuseIdentifier: "challengeCell")
        mainTableView.rowHeight = 245
        loadImage()
        
        
    }
    
    
    func loadImage(){
        db.collection((Auth.auth().currentUser?.email)!).getDocuments { (query, error) in
            for doc in query!.documents{
                let imageUrl = doc["Image"] as! String
                let url = URL.init(string: imageUrl)
                let imageResourse = ImageResource.init(downloadURL: url!)
                self.profileImageView.kf.setImage(with: imageResourse)
                
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toconfig", sender: self)
    }

}

extension ChallengeViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return banner.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = mainTableView.dequeueReusableCell(withIdentifier: "challengeCell", for: indexPath) as! ChallengeTableViewCell
        cell.currentImageView.image = banner[indexPath.row]
        var myCustomSelectionColorView = UIView()
        let Color = UIColor(red: 213/255, green: 94.0/255, blue: 59.0/255, alpha: 0.4)
           
        myCustomSelectionColorView.backgroundColor = Color
        myCustomSelectionColorView.layer.cornerRadius = 20
        
        cell.selectedBackgroundView = myCustomSelectionColorView
        return cell
    }
}
