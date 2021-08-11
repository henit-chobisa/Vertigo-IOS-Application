//
//  SentRequestTableViewCell.swift
//  Vertigo App
//
//  Created by Henit Work on 23/06/21.
//

import UIKit

class SentRequestTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.cornerRadius = 20
        deleteButton.layer.cornerRadius = 10
        userImage.layer.cornerRadius = 26
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
