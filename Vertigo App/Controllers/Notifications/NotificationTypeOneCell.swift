//
//  NotificationTypeOneCell.swift
//  Vertigo App
//
//  Created by Henit Work on 21/06/21.
//

import UIKit

class NotificationTypeOneCell: UITableViewCell {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var buttonBackLabel: UILabel!
    @IBOutlet weak var senderImage: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    var name : String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.cornerRadius = 15
        senderImage.layer.cornerRadius = 26
        buttonBackLabel.layer.cornerRadius = 20
        acceptButton.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
