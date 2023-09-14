//
//  MoreInfoViewController.swift
//  CarruescoHudsonFinalProject
//
//  Created by Hudson Carruesco on 12/14/21.
//

import Foundation
import UIKit

class MoreInfoViewController: UIViewController {
    
    @IBOutlet weak var tempInfoLabel: UILabel!
    @IBOutlet weak var precipInfoLabel: UILabel!
    @IBOutlet weak var AQIInfoLabel: UILabel!
    @IBOutlet weak var UVInfoLabel: UILabel!
    
    // displays more info about the scoring system
    override func viewDidLoad() {
        super.viewDidLoad()
        tempInfoLabel.text = "Temperature score is based on deviation from 66°F"
        precipInfoLabel.text = "Precipitation score is based on how much rain is estimated to fall"
        AQIInfoLabel.text = "AQI score is based on an AQI out of 5"
        UVInfoLabel.text = "UV score is based on a UV index out of 10"
    }
}
