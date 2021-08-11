//
//  LandingPageViewController.swift
//  Vertigo App
//
//  Created by Henit Work on 20/06/21.
//

import UIKit
import iCarousel
import Firebase
import Kingfisher

class LandingPageViewController: UIViewController {

    @IBOutlet weak var downImage: UIImageView!
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var peopleCollection: UICollectionView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var carouselView: iCarousel!
    let db = Firestore.firestore()
    let constants = UserDetails()
    var remoteUsers : [userPops] = []
    var kinter = Kinteraction()
    
    let bannerImages : [UIImage] = [#imageLiteral(resourceName: "Kratos Banner"), #imageLiteral(resourceName: "Ecojog Banner"), #imageLiteral(resourceName: "Divine Banner"), #imageLiteral(resourceName: "Wanderer Banner"), #imageLiteral(resourceName: "Create banner")]
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        topView.layer.cornerRadius = 15
        profileImageView.layer.cornerRadius = 23
        profileImageView.layer.borderWidth = 0.7
        profileImageView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        downImage.layer.cornerRadius = 35
        downImage.layer.borderWidth = 0.7
        downImage.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        downImage.backgroundColor = .black
        
        carouselView.type = .coverFlow
        aboutView.layer.cornerRadius = 20
        DispatchQueue.main.async {
            self.loadImage()
            self.loadPeople()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        carouselView.dataSource = self
        carouselView.currentItemIndex = 1
        peopleCollection.dataSource = self
        peopleCollection.delegate = self
        peopleCollection.isScrollEnabled = true
        
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 124, height: 210)
        
        peopleCollection.collectionViewLayout = layout
        layout.scrollDirection = .horizontal
        
       
        
        peopleCollection.register(UINib.init(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier:"peoplecell")
        
    }
    func loadImage(){
        db.collection((Auth.auth().currentUser?.email)!).getDocuments { (query, error) in
            for doc in query!.documents{
                let imageUrl = doc["Image"] as! String
                let url = URL.init(string: imageUrl)
                let imageResourse = ImageResource.init(downloadURL: url!)
                self.profileImageView.kf.setImage(with: imageResourse)
                self.downImage.kf.setImage(with: imageResourse)
                
            }
        }
    }
    
    func loadPeople(){
        remoteUsers = []
        db.collection("All Users").getDocuments { (query, error) in
            for doc in query!.documents{
                if (doc["Email"] as! String == (Auth.auth().currentUser?.email)!){
                    continue;
                }
                else{
                    let name = doc["Name"] as! String
                    let Url = doc["Image"] as! String
                    let mail = doc["Email"] as! String
                    let user = userPops(Name : name, Email : mail ,imageUrl : Url)
                    self.remoteUsers.append(user)
                    self.peopleCollection.reloadData()
                }
            }
        }
        
    }
    
    @IBAction func reload(_ sender: UIButton) {
        loadPeople()
    }
    
}

extension LandingPageViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        remoteUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = peopleCollection.dequeueReusableCell(withReuseIdentifier: "peoplecell", for: indexPath) as! CollectionViewCell
        
            cell.nameLabel.text = self.remoteUsers[indexPath.row].Name
            cell.emailfeild.text = self.remoteUsers[indexPath.row].Email
            let imageURLString = self.remoteUsers[indexPath.row].imageUrl
            let url = URL.init(string: imageURLString)
            let imageResourse = ImageResource.init(downloadURL: url!)
            cell.userImage.kf.setImage(with: imageResourse)
        
        DispatchQueue.main.async {
            self.db.collection((Auth.auth().currentUser?.email)!).document(self.kinter.interations).collection(self.kinter.SentRequests).getDocuments { (query, error) in
                for doc in query!.documents{
                    if (doc[self.kinter.requestedtoEmail] as! String == self.remoteUsers[indexPath.row].Email ){
                        cell.sendButton.setTitle("Delete", for: .normal)
                        DispatchQueue.main.async {
                            cell.sendButton.backgroundColor = .red
                            cell.sendButton.setTitleColor(.white, for: .normal)
                        }
                    }
                    else {
                        cell.sendButton.setTitle("Add", for: .normal)
                        DispatchQueue.main.async {
                            cell.sendButton.backgroundColor = .white
                            cell.sendButton.setTitleColor(.init(red: 213/255, green: 94/255, blue: 59/255, alpha: 1.0), for: .normal)
                        }
                        
                    }
                }
                
            }
            self.db.collection((Auth.auth().currentUser?.email)!).document(self.kinter.interations).collection(self.kinter.Requests).getDocuments { (querySnapshot, error) in
                for doc in querySnapshot!.documents {
                    if (doc[self.kinter.requesterEmail] as! String == self.remoteUsers[indexPath.row].Email){
                        cell.sendButton.setTitle("Accept", for: .normal)
                        DispatchQueue.main.async {
                            cell.sendButton.backgroundColor = .green
                            cell.sendButton.setTitleColor(.white, for: .normal)
                        }
                    }
                    else {
                        cell.sendButton.setTitle("Add", for: .normal)
                        DispatchQueue.main.async {
                            cell.sendButton.backgroundColor = .white
                            cell.sendButton.setTitleColor(.init(red: 213/255, green: 94/255, blue: 59/255, alpha: 1.0), for: .normal)
                        }
                    }
                }
            }
            self.db.collection((Auth.auth().currentUser?.email)!).document(self.kinter.interations).collection(self.kinter.Connections).getDocuments { (querysnapshot, error) in
                if let e = error {
                    print(e.localizedDescription)
                }
                else {
                    if let snapshotdocuments = querysnapshot?.documents{
                        for doc in snapshotdocuments{
                            if (doc[self.kinter.connectionEmail] as! String == self.remoteUsers[indexPath.row].Email){
                                cell.sendButton.setTitle("Disconnect", for: .normal)
                                DispatchQueue.main.async {
                                    cell.sendButton.backgroundColor = .white
                                    cell.sendButton.setTitleColor(.red, for: .normal)
                                }
                            }
                            else{
                                cell.sendButton.setTitle("Add", for: .normal)
                                DispatchQueue.main.async {
                                    cell.sendButton.backgroundColor = .white
                                    cell.sendButton.setTitleColor(.init(red: 213/255, green: 94/255, blue: 59/255, alpha: 1.0), for: .normal)
                                }
                            }
                        }
                    }
                }
            }
            
            

            
        }
        
        
        
    
        
        return cell
    }
}


extension LandingPageViewController : iCarouselDataSource{
    func numberOfItems(in carousel: iCarousel) -> Int {
        return bannerImages.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 345, height: 204))
        let myimage = UIImageView(frame: view.bounds)
        myimage.image = bannerImages[index]
        view.addSubview(myimage)
        view.layer.cornerRadius = 20
        myimage.contentMode = .scaleToFill
        return view
    }
    
}

extension LandingPageViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 124, height: 210)
    }
    

}

