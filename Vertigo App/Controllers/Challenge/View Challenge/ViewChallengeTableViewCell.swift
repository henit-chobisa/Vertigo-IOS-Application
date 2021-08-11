//
//  ViewChallengeTableViewCell.swift
//  Vertigo App
//
//  Created by Henit Work on 12/07/21.
//

import UIKit
import Firebase
import Kingfisher

class ViewChallengeTableViewCell: UITableViewCell, UICollectionViewDelegateFlowLayout {
    
    var db = Firestore.firestore()
    var members : [String] = []
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var channel: UILabel!
    @IBOutlet weak var peopleCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 20
        peopleCollectionView.register(UINib(nibName: "ViewParticipantsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "person")
        peopleCollectionView.dataSource = self
    
    }
    func loadImage(imageUrl : String, myimage : UIImageView ){
        let url = URL.init(string: imageUrl)
        let imageResourse = ImageResource.init(downloadURL: url!)
        myimage.kf.setImage(with: imageResourse)
    }

}


extension ViewChallengeTableViewCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return members.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = peopleCollectionView.dequeueReusableCell(withReuseIdentifier: "person", for: indexPath) as! ViewParticipantsCollectionViewCell
        print(indexPath.row)

            self.db.collection(members[indexPath.row]).getDocuments { (querySnapshot, error) in
                if let e = error {
                    print(e.localizedDescription)
                }
                else {
                    if let documents = querySnapshot?.documents {
                        if let doc = documents.last {
                            let imageURL = doc["Image"] as! String
                            self.loadImage(imageUrl: imageURL, myimage: cell.personsImage)
                        }
                    }
                }
            }
        
        
        return cell
    }
}
