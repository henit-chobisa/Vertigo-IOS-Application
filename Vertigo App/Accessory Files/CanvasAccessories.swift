//
//  CanvasAccessories.swift
//  Vertigo App
//
//  Created by Henit Work on 19/06/21.
//

import Foundation
import UIKit
import Canvas

struct CanvasAnims {
    
    func zoomIn(targetView : CSAnimationView){
        targetView.type = "zoomIn"
        targetView.duration = 1
        targetView.delay = 0
        targetView.startCanvasAnimation()
    }
    
    func zoomOut(targetView : CSAnimationView){
        targetView.type = "zoomOut"
        targetView.duration = 1
        targetView.delay = 0
        targetView.startCanvasAnimation()
    }
    
}
