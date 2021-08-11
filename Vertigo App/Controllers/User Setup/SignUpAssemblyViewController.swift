//
//  SignUpAssemblyViewController.swift
//  Vertigo App
//
//  Created by Henit Work on 20/06/21.
//

import UIKit
import Firebase

class SignUpAssemblyViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {

    @IBOutlet weak var imagePickerButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    var imagePicker = UIImagePickerController()
    var email = ""
    var name = ""
    var phone = ""
    var weight = ""
    var height = ""
    var docID = ""
    var db = Firestore.firestore()
    var constants = KUserDetails()
    
    override func viewWillAppear(_ animated: Bool) {
        submitButton.layer.cornerRadius = 15
        userImage.layer.cornerRadius = userImage.bounds.size.width/2
        userImage.clipsToBounds = true
        userImage.layer.borderWidth = 1
        userImage.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            print(self.email)
        }
        

        // Do any additional setup after loading the view.
    }
    
    func handovertoDatabase(k : String){
        
        db.collection("All Users").addDocument(data: [constants.userEmail : email, constants.userName : name, constants.userWeight : weight, constants.userheight : height, constants.userPhone : phone, constants.image : k])
        
        db.collection("All Users").whereField(constants.userEmail, isEqualTo: email).getDocuments { (query, error) in
            self.docID = (query?.documents.first!.documentID)!
        }
        
        db.collection((Auth.auth().currentUser?.email)!).addDocument(data: [constants.userEmail : email, constants.userName : name, constants.userWeight : weight, constants.userheight : height, constants.userPhone : phone, constants.image : k, "DocID" : docID])
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "tomain", sender: self)
        }
    }
    
    @IBAction func submitButtonHit(_ sender: UIButton) {
        let data = userImage.image?.jpegData(compressionQuality: 0.7)
        let imageReference = Storage.storage().reference().child((Auth.auth().currentUser?.email)!).child("\(String(describing: Auth.auth().currentUser?.email)) profile Image")
        imageReference.putData(data!, metadata: nil) { (meta, error2) in
            imageReference.downloadURL { (url, error) in
                self.handovertoDatabase(k: url!.absoluteString)
                
            }
        }
    }
    
    @IBAction func pickerButtonPressed(_ sender: UIButton) {
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        dismiss(animated: true)
        userImage.image = image
    }

}
