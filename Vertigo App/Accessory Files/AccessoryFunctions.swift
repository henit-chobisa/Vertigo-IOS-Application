//
//  accessoryFunctions.swift
//  Vertigo App
//
//  Created by Henit Work on 19/06/21.
//

import Foundation
import UIKit

struct AccessoryFunctions{
    
    func creatArtributedPlaceholder(Feild : UITextField , LabelOnHolder : String , Color : UIColor){
        Feild.attributedPlaceholder = NSAttributedString(string: LabelOnHolder,
                                                         attributes: [NSAttributedString.Key.foregroundColor: Color])
    }
    
}
