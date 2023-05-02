//
//  CalendarController.swift
//  WaterBalance
//
//  Created by Александра Маслова on 01.05.2023.
//

import UIKit
import CoreData

class CalendarController: UIViewController {
    
    let calendarView = UICalendarView()
    let decorationDatabase = MyDecorationDatabase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.calendar = Calendar(identifier: .gregorian)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.tintColor = UIColor(named: "darkBlueColor")
        calendarView.layer.cornerRadius = 12
        calendarView.backgroundColor = UIColor.clear
        calendarView.delegate = decorationDatabase
        
        view.addSubview(calendarView)
       
        NSLayoutConstraint.activate([
            calendarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calendarView.heightAnchor.constraint(equalToConstant: 425),
            calendarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 650)
        ])

    }
    
}

class MyDecorationDatabase: NSObject, UICalendarViewDelegate {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let blueColor = UIColor.cyan
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            let date = calendarView.calendar.date(from: dateComponents)!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: date)
            print("it is getDate: \(getDate())")
        if getDate().contains(where: { Calendar.current.isDate($0, inSameDayAs: date) }) {
                print("my date \(getDate())")
                let decoration = UICalendarView.Decoration.default(color: blueColor)
                return decoration
            }
            
            return nil
        }
        
    
    func getDate() -> [Date] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Water")
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        request.resultType = .dictionaryResultType
        request.propertiesToFetch = ["timestamp"]
        request.predicate = NSPredicate(format: "percent >= 100")
        
        do {
            let results = try context.fetch(request)
            let timestamps = results.compactMap { ($0 as? [String: Date])?["timestamp"] }
            let timestampsWithTimeZone = timestamps.map { $0.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT())) }
            return timestampsWithTimeZone
            
        } catch {
            print("Error fetching dates: \(error)")
            return []
        }
    }
}
