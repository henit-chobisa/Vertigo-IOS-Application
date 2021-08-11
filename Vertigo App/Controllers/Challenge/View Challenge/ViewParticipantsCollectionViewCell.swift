//
//  ViewParticipantsCollectionViewCell.swift
//  Vertigo App
//
//  Created by Henit Work on 12/07/21.
//

import UIKit

class ViewParticipantsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var personsImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        personsImage.layer.cornerRadius = 20
        personsImage.layer.borderWidth = 1
        personsImage.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
    }
}
