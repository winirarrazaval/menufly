//
//  CalendarViewController.swift
//  menufly
//
//  Created by winifred irarrazaval Oehninger on 7/18/18.
//  Copyright © 2018 winifred irarrazaval Oehninger. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController, JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
     let formatter = DateFormatter()

     //@IBOutlet weak var calendarView: JTAppleCalendarView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Calendar Protocols
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let myCustomCell = cell as! CalendarCellView
        sharedFunctionToConfigureCell(myCustomCell: myCustomCell, cellState: cellState, date: date)
    }
    
    func sharedFunctionToConfigureCell(myCustomCell: CalendarCellView, cellState: CellState, date: Date) {
        myCustomCell.dayLabel.text = cellState.text
//        if testCalendar.isDateInToday(date) {
//            myCustomCell.backgroundColor = red
//        } else {
//            myCustomCell.backgroundColor = white
//        }
        // more code configurations
        // ...
        // ...
        // ...
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let myCustomCell = calendar.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCellView
        self.calendar(calendar, willDisplay: myCustomCell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return myCustomCell
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let startDate = Date()//formatter.date(from: "2018 01 01")!
        let endDate = formatter.date(from: "2081 12 01")!
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate,calendar: Calendar.current, generateInDates:.forAllMonths,generateOutDates:.tillEndOfRow,hasStrictBoundaries: true)
        
        return parameters
    }
    
    

}
