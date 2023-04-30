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
        let formater = DateFormatter()
        formater.dateFormat = "HH:mm"
        StartTime.text = formater.string(from: startPicker.date)
       
        FinishTime.text = formater.string(from: finishPicker.date)
        
        // min value for finishPicker
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
    


    func scheduleNotification(startHour: Int, startMinute: Int, endHour: Int, endMinute: Int, frequencyInHours: Int) {
        let content = UNMutableNotificationContent()
        content.title = "WaterBalance"
        content.body = "It's time to drink water 💧"

        var dateComponents = DateComponents()
        dateComponents.hour = startHour
        dateComponents.minute = startMinute

        var trigger: UNCalendarNotificationTrigger?

        var requests = [UNNotificationRequest]() // Создаем массив запросов
        
        let frequencyInMinutes = frequencyInHours * 60 // Переводим период в минуты

        while dateComponents.hour! < endHour || (dateComponents.hour! == endHour && dateComponents.minute! < endMinute) {
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: "WaterBalanceNotification\(dateComponents.hour!)\(dateComponents.minute!)", content: content, trigger: trigger)
            requests.append(request) // Добавляем запрос в массив

            dateComponents.minute! += frequencyInMinutes

            // Проверяем, не вышли ли мы за пределы 60 минут в часе
            if dateComponents.minute! >= 60 {
                dateComponents.hour! += 1
                dateComponents.minute! -= 60
            }
        }
        for r in requests {
            UNUserNotificationCenter.current().add(r) { error in // Добавляем все запросы одновременно
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
