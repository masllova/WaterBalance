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
    let frequencyOptions = [" ", "1", "2", "3"]
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestNotificationAuthorization()
        
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
        
        userDefaults.set(StartTime.text, forKey: "start_time")
                userDefaults.set(FinishTime.text, forKey: "finish_time")
                userDefaults.set(FrequencyOfTime.text, forKey: "frequency")
        scheduleNotification()
    }
    
    func getDataFromPicker() {
        let formater = DateFormatter()
        formater.dateFormat = "HH:mm"
        StartTime.text = formater.string(from: startPicker.date)
       
        FinishTime.text = formater.string(from: finishPicker.date)
        
        // мин значение для finishPicker
        if let startDate = StartTime.text {
            formater.dateFormat = "HH:mm"
            let date = formater.date(from: startDate)
            finishPicker.minimumDate = date
        }
    }

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {return 1}
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {return frequencyOptions.count}
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {return frequencyOptions[row]}
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {FrequencyOfTime.text = frequencyOptions[row]}
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "WaterBalance"
        content.body = "It's time to drink water 💧"
        content.sound = .default

        let startTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: startPicker.date)
        let finishTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: finishPicker.date)

        let frequency = Double(FrequencyOfTime.text ?? "1") ?? 1.0
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: frequency * 60 * 60, repeats: true)
        let identifier = "MyAppNotification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error while scheduling notification: \(error.localizedDescription)")
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
