//
//  CalendarController.swift
//  menufly
//
//  Created by winifred irarrazaval Oehninger on 7/17/18.
//  Copyright © 2018 winifred irarrazaval Oehninger. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarController: UIViewController {
    
    let formatter = DateFormatter()
    
    @IBOutlet weak var calendarVIew: JTAppleCalendarView!

    override func viewDidLoad() {
        super.viewDidLoad()
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension CalendarController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        var parameters: ConfigurationParameters
        var startDate = Date()
        var endDate = Date()
        if let calendarStartDate = formatter.date(from: "2017 01 01"),
            let calendarEndndDate = formatter.date(from: "2017 12 31") {
            startDate = calendarStartDate
            endDate = calendarEndndDate
        }
        parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: 1)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let myCustomCell = cell as! CellView
        myCustomCell.dayLabel.text = cellState.text
        myCustomCell.dinner.text = "dinner"
        myCustomCell.luch.text = "lunch"
        
        if cellState.dateBelongsTo == .thisMonth {
            myCustomCell.dayLabel.textColor = UIColor.darkGray
        } else {
            myCustomCell.dayLabel.textColor = UIColor.lightGray
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CellView
        cell.dayLabel.text = cellState.text
        
        return cell
    }
    
    
}
