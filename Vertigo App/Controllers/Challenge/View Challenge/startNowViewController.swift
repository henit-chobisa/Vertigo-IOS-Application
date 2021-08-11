//
//  startNowViewController.swift
//  Vertigo App
//
//  Created by Henit Work on 13/07/21.
//

import UIKit
import AVFoundation
import AVKit
import Kingfisher
import Firebase


class startNowViewController: UIViewController {
    
    @IBOutlet weak var peopleCollectionView: UICollectionView!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var channelTitle: UILabel!
    @IBOutlet weak var dateTitle: UILabel!
    @IBOutlet weak var mainTitle: UILabel!
    var player: AVPlayer?
    var eventDetails = Event(ChallengeName:"Update Data..." , ChallengeDate: "Update Data...", ChallengeTime:"Update Data..." , ChallengeID:"Update Data..." )
    var membersArray : [String] = []
    let db = Firestore.firestore()
    
    override func viewWillAppear(_ animated: Bool) {
        goButton.layer.cornerRadius = 20
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadVideo(Video: "video", format: "mp4", height: CGFloat(1598), width: CGFloat(1792), x: 25, y: 700, view: self.view)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            self.mainTitle.text = self.eventDetails.ChallengeName
            self.dateTitle.text = "\(self.eventDetails.ChallengeDate)-\(self.eventDetails.ChallengeTime)"
            self.channelTitle.text = "\(self.eventDetails.ChallengeID)"
        }
        
        peopleCollectionView.dataSource = self
        peopleCollectionView.register(UINib(nibName: "ViewParticipantsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "person")
        Timer.scheduledTimer(timeInterval: 11.6, target: self, selector: #selector(videoLoop), userInfo: nil, repeats: true)
        

    }
    
    func loadImage(imageUrl : String, myimage : UIImageView ){
        let url = URL.init(string: imageUrl)
        let imageResourse = ImageResource.init(downloadURL: url!)
        myimage.kf.setImage(with: imageResourse)
    }
    
    @objc func videoLoop (){
        player?.seek(to: CMTime.zero)
        player?.play()
    }
    
    func loadVideo(Video : String , format : String ,height : CGFloat , width : CGFloat , x : CGFloat , y : CGFloat , view : UIView  ) {

    
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
        } catch { }

        let path = Bundle.main.path(forResource: Video, ofType:format)

        player = AVPlayer(url: NSURL(fileURLWithPath: path!) as URL)
        let playerLayer = AVPlayerLayer(player: player)

        playerLayer.frame = view.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer.frame.size.height = height
        playerLayer.frame.size.width = width
        playerLayer.position.x = x
        playerLayer.position.y = y
        playerLayer.zPosition = -1

        view.layer.addSublayer(playerLayer)

        player?.seek(to: CMTime.zero)
        player?.play()
        
    }

    
    @IBAction func didTapDismiss(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    

}

extension startNowViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return membersArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = peopleCollectionView.dequeueReusableCell(withReuseIdentifier: "person", for: indexPath) as! ViewParticipantsCollectionViewCell
        print(indexPath.row)

            self.db.collection(membersArray[indexPath.row]).getDocuments { (querySnapshot, error) in
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

