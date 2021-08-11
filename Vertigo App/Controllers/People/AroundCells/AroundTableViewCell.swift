//
//  AroundTableViewCell.swift
//  Vertigo App
//
//  Created by Henit Work on 23/06/21.
//

import UIKit

class AroundTableViewCell: UITableViewCell {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        connectButton.layer.cornerRadius = 10
        userImage.layer.cornerRadius = 26
        backView.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTapConnect(_ sender: UIButton) {
    }
}
