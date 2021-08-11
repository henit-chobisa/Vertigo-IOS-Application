//
//  TestViewController.swift
//  Vertigo App
//
//  Created by Henit Work on 23/06/21.
//

import UIKit
import FloatingPanel
import MeterGauge


class TestViewController: UIViewController, FloatingPanelControllerDelegate {
    
    let fpcontroller = FloatingPanelController()

    @IBOutlet weak var gauge: MeterGauge!
    
    override func viewWillAppear(_ animated: Bool) {
        fpcontroller.surfaceView.layer.cornerRadius = 20
        fpcontroller.surfaceView.appearance.backgroundColor = .darkGray
        fpcontroller.surfaceView.appearance.cornerRadius = 30
        fpcontroller.move(to:.tip, animated: true)
        setGauge(value: 30)
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fpcontroller.delegate = self
        let contentVC = storyboard?.instantiateViewController(identifier: "fpc_floatingcontroller") as? floatingViewController
        fpcontroller.set(contentViewController: contentVC)
        fpcontroller.addPanel(toParent: self)
        
        fpcontroller.contentMode = .static
        // Do any additional setup after loading the view.
    }
    
    func setGauge(value : Int){
        gauge.set(value: value)
        let color = UIColor(red: 0.3, green: 0.5, blue: 0.2, alpha: 1.0)
        let segment = Segment(percent: 100, color: color, status: "")
        gauge.segments.append(segment)
        gauge.tickWidth = 7.0
        gauge.beforeIndicatorTickOpacity = 1.0
        gauge.afterIndicatorTickOpacity = 0.3
        gauge.indicatorTickHeight = 10.0
        gauge.indicatorTickScale = 1.0
        gauge.indicatorTickOpacity = 1.0
        
    }
    
    

}
