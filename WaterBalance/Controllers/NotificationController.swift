//
//  NotificationController.swift
//  WaterBalance
//
//  Created by Александра Маслова on 25.04.2023.
//


import UIKit
import UserNotifications

class NotificationController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var StartTime: UITextField!
    let startPicker = UIDatePicker()
    
    @IBOutlet weak var FinishTime: UITextField!
    let finishPicker = UIDatePicker()
    
    @IBOutlet weak var FrequencyOfTime: UITextField!
    
    let frequencyPicker = UIPickerView()
    let frequencyOptions = ["1", "2", "3"]
    
    @IBOutlet weak var Stack: UIStackView!
    @IBOutlet weak var TopStack: UIStackView!
    @IBOutlet weak var BottomStack: UIStackView!
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Stack.layer.cornerRadius = 15
        TopStack.layer.cornerRadius = 15
        BottomStack.layer.cornerRadius = 15
        
        FrequencyOfTime.text = "1"

        StartTime.inputView = startPicker
        startPicker.datePickerMode = .time
        FinishTime.inputView = finishPicker
        finishPicker.datePickerMode = .time
        FrequencyOfTime.inputView = frequencyPicker
        
        let pickerContainerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 220))
             
        pickerContainerView.backgroundColor = .white
        pickerContainerView.addSubview(startPicker)
        pickerContainerView.addSubview(finishPicker)
        pickerContainerView.addSubview(frequencyPicker)
        startPicker.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 110)
        finishPicker.frame = CGRect(x: 0, y: 110, width: view.frame.width, height: 110)
        frequencyPicker.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 220)
        frequencyPicker.delegate = self
        frequencyPicker.dataSource = self
        
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneButton], animated: true)
        
        StartTime.inputAccessoryView = toolbar
        FinishTime.inputAccessoryView = toolbar
        FrequencyOfTime.inputAccessoryView = toolbar
        
        if let startTime = userDefaults.string(forKey: "start_time") {StartTime.text = startTime}
        if let finishTime = userDefaults.string(forKey: "finish_time") {FinishTime.text = finishTime}
        if let frequency = userDefaults.string(forKey: "frequency") {FrequencyOfTime.text = frequency}

    }
    @objc func doneAction() {
        getDataFromPicker()
        view.endEditing(true)
        
        guard let startHour = Int((StartTime.text ?? "").prefix(2)),
                  let startMinute = Int((StartTime.text ?? "").suffix(2)),
                  let endHour = Int((FinishTime.text ?? "").prefix(2)),
                  let endMinute = Int((FinishTime.text ?? "").suffix(2)),
                  let frequencyInHours = Int(FrequencyOfTime.text ?? "") else {
            print("oops")
                      return
                  }

        
        scheduleNotification(startHour: startHour, startMinute: startMinute, endHour: endHour, endMinute: endMinute, frequencyInHours: frequencyInHours)
    }

    func getDataFromPicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        StartTime.text = formatter.string(from: startPicker.date)
        FinishTime.text = formatter.string(from: finishPicker.date)
        
        if let startDate = formatter.date(from: StartTime.text ?? ""),
           let finishDate = formatter.date(from: FinishTime.text ?? "") {
            if startDate > finishDate {
                FinishTime.text = formatter.string(from: startDate)
                finishPicker.date = startDate
            }
        }
        
        userDefaults.setValue(StartTime.text, forKey: "start_time")
        userDefaults.setValue(FinishTime.text, forKey: "finish_time")
    }


    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {return 1}
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {return frequencyOptions.count}
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {return frequencyOptions[row]}
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {FrequencyOfTime.text = frequencyOptions[row]}
    


    func scheduleNotification(startHour: Int, startMinute: Int, endHour: Int, endMinute: Int, frequencyInHours: Int) {
        let content = UNMutableNotificationContent()
        content.title = "WaterBalance"
        content.body = "It's time to drink water 💧"

        var dateComponents = DateComponents()
        dateComponents.hour = startHour
        dateComponents.minute = startMinute

        var trigger: UNCalendarNotificationTrigger?

        var requests = [UNNotificationRequest]() // Creating an array of requests
        let frequencyInMinutes = frequencyInHours * 60
        
        // Removing all pending notifications with the same identifier
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["WaterBalanceNotification"])

        while dateComponents.hour! < endHour || (dateComponents.hour! == endHour && dateComponents.minute! < endMinute) {
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: "WaterBalanceNotification\(dateComponents.hour!)\(dateComponents.minute!)", content: content, trigger: trigger)
            requests.append(request) // Adding a query to the array

            dateComponents.minute! += frequencyInMinutes

            // We are checking if we have gone beyond 60 minutes in an hour
            if dateComponents.minute! >= 60 {
                dateComponents.hour! += 1
                dateComponents.minute! -= 60
            }
        }
        for r in requests {
            UNUserNotificationCenter.current().add(r) { error in // Adding all requests at the same time
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                } else {
                    let date = "\(dateComponents.hour!):\(dateComponents.minute!)"
                    print("Notification scheduled successfully for time: \(date)")
                }
            }
        }
        
    }


    
    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error while requesting notification authorization: \(error.localizedDescription)")
            }
        }
    }
}
