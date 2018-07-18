//
//  CalendarController.swift
//  menufly
//
//  Created by winifred irarrazaval Oehninger on 7/18/18.
//  Copyright © 2018 winifred irarrazaval Oehninger. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarController: UIViewController {
    
    @IBOutlet weak var myCalendar: JTAppleCalendarView!
    
    let formatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpCalendarView()
        
    }
    
    func setUpCalendarView(){
        myCalendar.minimumLineSpacing = 0
        myCalendar.minimumInteritemSpacing = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension CalendarController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        // This function should have the same code as the cellForItemAt function
        let myCustomCell = cell as! CalendarCell
        sharedFunctionToConfigureCell(myCustomCell: myCustomCell, cellState: cellState, date: date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let myCustomCell = calendar.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCell
        sharedFunctionToConfigureCell(myCustomCell: myCustomCell, cellState: cellState, date: date)
        return myCustomCell
    }
    
    func sharedFunctionToConfigureCell(myCustomCell: CalendarCell, cellState: CellState, date: Date) {
        myCustomCell.dayLabel.text = cellState.text
        if cellState.isSelected {
            myCustomCell.selectedView.isHidden = false
            myCustomCell.dayLabel.textColor = UIColor.darkGray
        } else {
            myCustomCell.selectedView.isHidden = true
            myCustomCell.dayLabel.textColor = UIColor.white
        }
//        if myCalendar.isDateInToday(date) {
//            myCustomCell.backgroundColor = red
//        } else {
//            myCustomCell.backgroundColor = white
        
        // more code configurations
        // ...
        // ...
        // ...
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
       
            formatter.dateFormat = "yyyy MM dd"
            formatter.timeZone = Calendar.current.timeZone
            formatter.locale = Calendar.current.locale
            
            let startDate = formatter.date(from: "2018 07 18")!
            let endDate = formatter.date(from: "2018 12 31")!
            
            let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: 1)
//            , calendar: <#T##Calendar?#>, generateInDates: <#T##InDateCellGeneration?#>, generateOutDates: <#T##OutDateCellGeneration?#>, firstDayOfWeek: <#T##DaysOfWeek?#>, hasStrictBoundaries: <#T##Bool?#> ,
            return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CalendarCell else {return}
        validCell.selectedView.isHidden = false
        validCell.dayLabel.textColor = UIColor.darkGray
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CalendarCell else {return}
        validCell.selectedView.isHidden = true
        validCell.dayLabel.textColor = UIColor.white
    }
}
