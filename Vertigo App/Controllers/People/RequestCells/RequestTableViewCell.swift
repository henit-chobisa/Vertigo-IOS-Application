//
//  RequestTableViewCell.swift
//  Vertigo App
//
//  Created by Henit Work on 23/06/21.
//

import UIKit

class RequestTableViewCell: UITableViewCell {

    @IBOutlet weak var backPanel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        deleteButton.layer.cornerRadius = 20
        acceptButton.layer.cornerRadius = 20
        userImage.layer.cornerRadius = 26
        backView.layer.cornerRadius = 20
        backPanel.layer.cornerRadius = 20
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didAcceptRequest(_ sender: UIButton) {
        
    }
    @IBAction func didDeleteRequest(_ sender: UIButton) {
        
    }
    
}
