//
//  EcoJogBaseViewController.swift
//  Vertigo App
//
//  Created by Henit Work on 23/06/21.
//

import UIKit
import Firebase
import Kingfisher

class EcoJogBaseViewController: UIViewController {
    
    
  
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var SaveButton: UIButton!
    @IBOutlet weak var nullLabel: UILabel!
    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var startNowButton: UIButton!
    @IBOutlet weak var participantCollectionView: UICollectionView!
    @IBOutlet weak var organizerImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    var config = configurations()
    let db = Firestore.firestore()
    var kc = KChallenge()
    
    
    override func viewWillAppear(_ animated: Bool) {
        startNowButton.layer.cornerRadius = 15
        startNowButton.layer.borderWidth = 1
        startNowButton.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        SaveButton.layer.cornerRadius = 15
        SaveButton.layer.borderWidth = 1
        SaveButton.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        profileImage.layer.cornerRadius = 26
        organizerImage.layer.cornerRadius = 26
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.dateLabel.text = "\(self.config.date!)-\(self.config.day!)"
            self.timeLabel.text = self.config.time
            self.channelName.text = self.config.channel
            self.loadImage()
        }
        participantCollectionView.dataSource = self
        
        
        

        // Do any additional setup after loading the view.
    }
    
    func loadImage(){
        db.collection((Auth.auth().currentUser?.email)!).getDocuments { (query, error) in
            for doc in query!.documents{
                let imageUrl = doc["Image"] as! String
                let url = URL.init(string: imageUrl)
                let imageResourse = ImageResource.init(downloadURL: url!)
                self.profileImage.kf.setImage(with: imageResourse)
                self.organizerImage.kf.setImage(with: imageResourse)
                
            }
        }
    }
    
    @IBAction func didtapStartNow(_ sender: UIButton) {
        
        
        
    }
    
    @IBAction func didTapSaveEvent(_ sender: UIButton) {
        db.collection((Auth.auth().currentUser?.email)!).document("Challenges").collection(config.channel!).addDocument(data: [kc.challengeName : kc.ecoJog, kc.id : config.channel!,kc.day : config.day!, kc.date : config.date!, kc.time : config.time!,kc.Host : (Auth.auth().currentUser?.email)!, "Members" : [(Auth.auth().currentUser?.email)!]])
        
        db.collection((Auth.auth().currentUser?.email)!).document("Challenges").collection(kc.channelsGenerated).addDocument(data: [kc.channel : config.channel!])
        
        
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "tomaintab", sender: self)
        }
        
    }
    
    
    @IBAction func didTapBack(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toaskpeople" {
            if let VC = segue.destination as? askFriendViewController {
                VC.challengeName = "EcoJog"
                VC.challengeID = "\(String(describing: config.channel!))"
                VC.challengeTime = config.time!
                VC.challengeDate = config.date!
            }
        }
    }
}

extension EcoJogBaseViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = participantCollectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath)
        return cell
    }
    
    
}
