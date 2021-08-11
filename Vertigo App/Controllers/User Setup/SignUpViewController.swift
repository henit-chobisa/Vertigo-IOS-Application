//
//  SignUpViewController.swift
//  Vertigo App
//
//  Created by Henit Work on 19/06/21.
//

import UIKit
import Canvas

class SignUpViewController: UIViewController {

    @IBOutlet weak var AwesomeButton: UIButton!
    @IBOutlet weak var feildTracker: UILabel!
    @IBOutlet weak var animationFeildView: CSAnimationView!
    @IBOutlet weak var textFeild: UITextField!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var upButton: UIButton!
    var accessoryfuncs = AccessoryFunctions()
    @IBOutlet weak var inputTextFeild: UITextField!
    var tracker = 0
    var a = ""
    var b = ""
    var c = ""
    var d = ""
    var e = ""
    
    var canvasfuns = CanvasAnims()
    var placeholdermarks = ["email","name", "number", "weight in kgs", "height in cms"]
    var labeloffeild : String = "Please Enter your "
    var user = UserDetails(Email: nil, Name: nil, Number: nil, Weight: nil, height: nil)

    override func viewWillAppear(_ animated: Bool) {
        inputTextFeild.layer.cornerRadius = 10
        inputTextFeild.layer.borderWidth = 1
        inputTextFeild.layer.borderColor = #colorLiteral(red: 0.9012104869, green: 0.3294653594, blue: 0.1761626601, alpha: 1)
        AwesomeButton.layer.cornerRadius = 20
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePlaceHolder()

        // Do any additional setup after loading the view.
    }
    
    func updatePlaceHolder(){
        if (tracker == 0 ){
            upButton.isEnabled = false
        }
        else{
            upButton.isEnabled = true
        }
        
        if (tracker == 4){
            downButton.isEnabled = false
            AwesomeButton.isEnabled = true
            AwesomeButton.alpha = 1
        }
        else{
            downButton.isEnabled = true
            AwesomeButton.isEnabled = false
            AwesomeButton.alpha = 0.5
        }
        
        accessoryfuncs.creatArtributedPlaceholder(Feild: inputTextFeild, LabelOnHolder: "\(labeloffeild)\(placeholdermarks[tracker] )", Color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
    }
    
    @IBAction func downPressed(_ sender: UIButton) {
        
        if (!inputTextFeild.hasText){
            accessoryfuncs.creatArtributedPlaceholder(Feild: inputTextFeild, LabelOnHolder: "\(labeloffeild)\(placeholdermarks[tracker] )", Color: #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1))
        }
        
        else{
            tracker = tracker + 1
            feildTracker.text = "Feilds : \(tracker + 1)/5"
            
            switch (tracker-1) {
            case 0:
                user.Email = inputTextFeild.text
            case 1:
                user.Name = inputTextFeild.text
            case 2:
                user.Number = inputTextFeild.text
            case 3:
                user.Weight = inputTextFeild.text
            case 4:
                user.height = inputTextFeild.text
            default:
                user.Email = "Non existent"
            }
            
            canvasfuns.zoomIn(targetView: animationFeildView)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.inputTextFeild.text = ""
                self.updatePlaceHolder()
                self.canvasfuns.zoomOut(targetView: self.animationFeildView)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "tofinal" {
                if let viewController = segue.destination as? SignUpAssemblyViewController {
                    viewController.email = a
                    viewController.name = b
                    viewController.phone = c
                    viewController.weight = d
                    viewController.height = e
                  
                }
            }
        }
    
    @IBAction func upPressed(_ sender: UIButton) {
        tracker = tracker - 1
        
        feildTracker.text = "Feilds : \(tracker + 1)/5"
        inputTextFeild.text = ""
        canvasfuns.zoomIn(targetView: animationFeildView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.updatePlaceHolder()
            self.canvasfuns.zoomOut(targetView: self.animationFeildView)
        }
        
        
    }
    
    @IBAction func awesomeButtonPressed(_ sender: UIButton) {
        user.height = inputTextFeild.text
        a = user.Email!
        b = user.Name!
        c = user.Number!
        d = user.Weight!
        e = user.height!
        self.performSegue(withIdentifier: "tofinal", sender: self)
        
    }
    

}
