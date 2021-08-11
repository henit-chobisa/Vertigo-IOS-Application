//
//  NotificationTypeTwoCell.swift
//  Vertigo App
//
//  Created by Henit Work on 23/06/21.
//

import UIKit

class NotificationTypeTwoCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.cornerRadius = 15
        userImage.layer.cornerRadius = 26
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
