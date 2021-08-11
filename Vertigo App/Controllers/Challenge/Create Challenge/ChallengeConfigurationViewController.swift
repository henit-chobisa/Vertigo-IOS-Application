


import UIKit
import Canvas

class ChallengeConfigurationViewController: UIViewController {

    @IBOutlet weak var animView: CSAnimationView!
    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var generateButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var dataTextFeild: UITextField!
    
    
    var config = configurations(date: nil, time: nil, day: nil, channel: nil)
    
    var tracker = 0
    var labeloffeild : String = "Please Enter your "
    let af = AccessoryFunctions()
    let ca = CanvasAnims()
    var placeholders = ["At what date?", "At what time?", "At what day?"]
    
    
    override func viewWillAppear(_ animated: Bool) {
        dataTextFeild.layer.cornerRadius = 15
        dataTextFeild.layer.borderWidth = 1
        dataTextFeild.layer.borderColor = #colorLiteral(red: 0.9725160003, green: 0.2743841112, blue: 0.07287726551, alpha: 1)
        generateButton.layer.cornerRadius = 20
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePlaceHolder()
        channelName.isHidden = true
        generateButton.isHidden = true
        
    }
    @IBAction func upButtonPressed(_ sender: UIButton) {
        
        tracker -= 1
        ca.zoomIn(targetView: animView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dataTextFeild.text = ""
            self.updatePlaceHolder()
            self.ca.zoomOut(targetView: self.animView)
        }
    }
    
    @IBAction func downButtonPressed(_ sender: UIButton) {
        if (!dataTextFeild.hasText){
            af.creatArtributedPlaceholder(Feild: dataTextFeild, LabelOnHolder: "\(labeloffeild)\(placeholders[tracker] )", Color: #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1))
        }
        
        else {
            
            
            tracker += 1
            
            switch tracker - 1 {
            case 0:
                config.date = dataTextFeild.text!
                break
                
            case 1:
                config.time = dataTextFeild.text!
                break
            default:
                print("invalid")
            }
            ca.zoomIn(targetView: animView)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.dataTextFeild.text = ""
                self.updatePlaceHolder()
                self.ca.zoomOut(targetView: self.animView)
            }
        }
    }
    
    
    func updatePlaceHolder(){
        if (tracker == 0){
            upButton.isEnabled = false
        }
        else {
            upButton.isEnabled = true
        }
        
        if tracker == 2 {
            downButton.isEnabled = false
            channelName.isHidden = false
            generateButton.isHidden = false
        }
        else {
            downButton.isEnabled = true
            channelName.isHidden = true
            generateButton.isHidden = true
        }
        
        
        
        af.creatArtributedPlaceholder(Feild: dataTextFeild, LabelOnHolder: placeholders[tracker] , Color: .gray)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ecojogMainScreen" {
            if let VC = segue.destination as? EcoJogBaseViewController {
                VC.config = config
            }
            
        }
        
    }
    
    @IBAction func generateButtonPressed(_ sender: UIButton) {
        if (generateButton.currentTitle == "Generate Now"){
            config.day = dataTextFeild.text!
            channelName.text = "\(Int.random(in: 1..<100000000))"
            config.channel = channelName.text!
            generateButton.setTitle("Awesome", for: .normal)
        }
        else {
            performSegue(withIdentifier: "ecojogMainScreen", sender: self)
            
        }
    }
    
    @IBAction func didTapBack(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
