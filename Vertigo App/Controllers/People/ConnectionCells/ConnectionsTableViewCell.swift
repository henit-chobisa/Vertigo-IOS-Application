//
//  ConnectionsTableViewCell.swift
//  Vertigo App
//
//  Created by Henit Work on 23/06/21.
//

import UIKit

class ConnectionsTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var mainLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        userImage.layer.cornerRadius = 26
        deleteButton.layer.cornerRadius = 10
        backView.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
