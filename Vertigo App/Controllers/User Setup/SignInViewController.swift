//
//  SignInViewController.swift
//  Vertigo App
//
//  Created by Henit Work on 19/06/21.
//

import UIKit
import Firebase
import AgoraRtcKit

class SignInViewController: UIViewController {

    @IBOutlet weak var signUpbUTTON: UIButton!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var passwordTextFeild: UITextField!
    @IBOutlet weak var emailTextFeild: UITextField!
    
    var accessoryfuncs = AccessoryFunctions()
    override func viewWillAppear(_ animated: Bool) {
        passwordTextFeild.layer.borderWidth = 1
        passwordTextFeild.layer.borderColor = #colorLiteral(red: 0.6450776458, green: 0.2957321405, blue: 0.1922585666, alpha: 1)
        passwordTextFeild.layer.cornerRadius = 10
        
        emailTextFeild.layer.borderWidth = 1
        emailTextFeild.layer.borderColor = #colorLiteral(red: 0.6450776458, green: 0.2957321405, blue: 0.1922585666, alpha: 1)
        emailTextFeild.layer.cornerRadius = 10
        
        goButton.layer.cornerRadius = 15
        signUpbUTTON.layer.cornerRadius = 15
        
        
        accessoryfuncs.creatArtributedPlaceholder(Feild: passwordTextFeild, LabelOnHolder: "Enter your password" , Color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
        
        accessoryfuncs.creatArtributedPlaceholder(Feild: emailTextFeild, LabelOnHolder: "Enter your Email | Username" , Color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        

       
    }
    
    @IBAction func microsoftButtonHit(_ sender: UIButton) {
    }
    @IBAction func appleButtonHit(_ sender: UIButton) {
    }
    @IBAction func facebookButtonHit(_ sender: UIButton) {
    }
    @IBAction func goButtonHit(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: emailTextFeild.text!, password: passwordTextFeild.text!) { (result, error) in
            if (error == nil ){
                self.performSegue(withIdentifier: "tomainscreen", sender: self)
            }
            else {
                print(error?.localizedDescription as! String)
            }
        }
        
    }
    @IBAction func signUpButtonHit(_ sender: UIButton) {
        Auth.auth().createUser(withEmail: emailTextFeild.text!, password: passwordTextFeild.text!) { (result, error) in
            if (error == nil ){
                self.performSegue(withIdentifier: "tomaintab", sender: self)
            }
            else{
                print(error?.localizedDescription as! String)
            }
        }
    }
    

}
