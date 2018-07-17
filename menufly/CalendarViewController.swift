//
//  CalendarViewController.swift
//  menufly
//
//  Created by winifred irarrazaval Oehninger on 7/13/18.
//  Copyright © 2018 winifred irarrazaval Oehninger. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController {
    let formatter = DateFormatter()

    @IBOutlet weak var month: UILabel!
    
    @IBOutlet weak var year: UILabel!
    
    @IBOutlet weak var myCalendar: JTAppleCalendarView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myCalendar.visibleDates { dateSegment in
            self.setUpCalendarView(dateSegment: dateSegment)
        }
            
    }
    
    func setUpCalendarView(dateSegment: DateSegmentInfo){
        guard let date = dateSegment.monthDates.first?.date else {return}
        formatter.dateFormat = "MMM"
        month.text = formatter.string(from: date)
        
        formatter.dateFormat = "yyyy"
        year.text = formatter.string(from: date)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func configureCell(cell: JTAppleCell?, cellState: CellState) {
        guard let myCustomCell = cell as? CalendarCollectionViewCell else {return}
        
//        handleCellTextColor(cell: myCustomCell, cellState: cellState)
        handleCellVisibility(cell: myCustomCell, cellState: cellState)
        //handleCellSelection(cell: myCustomCell, cellState: cellState)
//
//        func handleCellTextColor(cell: CalendarCollectionViewCell, cellState: CellState ){
//            cell.textLabel.textColor = cellState.isSelected ? UIColor.pink : UIColor.white
        }
        
        func handleCellVisibility(cell: CalendarCollectionViewCell, cellState: CellState){
            cell.isHidden = cellState.dateBelongsTo == .thisMonth ? true:false
        }
        
//        func handleCellSelection(cell: CalendarCollectionViewCell, cellState: CellState){
//            cell.selectedView.isHidden = cellState.isSelected ? true:false
//        }
    

}

extension CalendarViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let myCustomCell = cell as! CalendarCollectionViewCell
        sharedFunctionToConfigureCell(myCustomCell: myCustomCell, cellState: cellState, date: date)
    }
    

    
    func sharedFunctionToConfigureCell(myCustomCell: CalendarCollectionViewCell, cellState: CellState, date: Date) {
        myCustomCell.dateLabel.text = cellState.text
//        if myCalendar.isDateInToday(date) {
//            myCustomCell.backgroundColor = UIColor.red
//        } else {
//            myCustomCell.backgroundColor = UIColor.white
//        }
    }
    
    

    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2018 07 01")!
        let endDate = formatter.date(from: "2018 12 31")!
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }

    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath ) as! CalendarCollectionViewCell
        cell.dateLabel.text = cellState.text
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(cell: cell, cellState: cellState)
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setUpCalendarView(dateSegment: visibleDates)
    }

}
