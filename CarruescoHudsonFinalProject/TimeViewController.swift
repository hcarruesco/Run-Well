//
//  TimeViewController.swift
//  CarruescoHudsonFinalProject (iOS)
//
//  Created by Hudson Carruesco on 12/9/21.
//

import Foundation
import UIKit

class TimeViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var currentTimeButton: UIButton!
    @IBOutlet weak var timeSelectedDisplay: UILabel!
    
    // updates view with current time info
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDatePickerLimits()
        updateTimeDisplay()
    }
    
    // updates view with current time info each time the view appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateDatePickerLimits()
    }
    
    // makes sure the only times available to choose from are within the next 48 hours
    func updateDatePickerLimits() {
        datePicker.minimumDate = Date()
        datePicker.maximumDate = Date(timeIntervalSinceNow: 172800) // 48 hours in future
    }
    
    // fires when the current time button is pressed, meaning the user does not want forecasted weather data
    @IBAction func currentTimeButtonPressed(_ sender: UIButton) {
        TimeModel.shared.updateTime(selectedTime: Date(), isFutureTime: false)
        datePicker.date = Date()
        updateTimeDisplay()
    }
    
    // fires when the user is done selcting a time
    @IBAction func dateTimeChanged(_ sender: UIDatePicker) {
        TimeModel.shared.updateTime(selectedTime: datePicker.date, isFutureTime: true)
        updateTimeDisplay()
        updateDatePickerLimits()
    }
    
    // shows the user a printed out string of what time they selected
    func updateTimeDisplay() {
        timeSelectedDisplay.text = "(Time Selected:  \(TimeModel.shared.returnDateTimeString()))"
    }
}
