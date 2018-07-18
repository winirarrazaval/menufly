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
    
    let outsideMonthColor = UIColor.lightGray
    let monthColor = UIColor.white
    let selectedMonthColor = UIColor.darkGray
    let currentDateSelectedViewColor = UIColor.magenta
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCalendarView()
        
        
        
    }
    
    
    func setUpCalendarView(){
        //spacing
        myCalendar.minimumLineSpacing = 0
        myCalendar.minimumInteritemSpacing = 0
        
        //Labels
            myCalendar.visibleDates { visibleDates in
             let date = visibleDates.monthDates.first?.date
            
            self.formatter.dateFormat = "MMM"
                self.month.text = self.formatter.string(from: date!)

            self.formatter.dateFormat = "yyyy"
                self.year.text = self.formatter.string(from: date!)

            }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func configureCell(cell: JTAppleCell?, cellState: CellState) {
        guard let myCustomCell = cell as? CalendarCollectionViewCell else {return}
        
        handleCellTextColor(cell: myCustomCell, cellState: cellState)
//        handleCellVisibility(cell: myCustomCell, cellState: cellState)
        handleCellSelection(cell: myCustomCell, cellState: cellState)
    }
    
    func handleCellTextColor(cell: JTAppleCell?, cellState: CellState ){
        guard let myCustomCell = cell as? CalendarCollectionViewCell  else {
            return
        }
        if cellState.isSelected {
            myCustomCell.dateLabel.textColor = self.selectedMonthColor
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                myCustomCell.dateLabel.textColor = self.monthColor
            } else {
                myCustomCell.dateLabel.textColor = self.outsideMonthColor
            }
        }

    }
        
  //  func handleCellVisibility(cell: JTAppleCell?, cellState: CellState){
       
//            cell.isHidden = cellState.dateBelongsTo == .thisMonth ? true:false
  // }
//
    func handleCellSelection(cell: JTAppleCell?, cellState: CellState){
        guard let myCustomCell = cell as? CalendarCollectionViewCell else {return }
        if cellState.isSelected {
            myCustomCell.selectedView.layer.cornerRadius =  15
            myCustomCell.selectedView.isHidden = false
        } else {
            myCustomCell.selectedView.isHidden = true
        }
    }
    

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
        if cellState.isSelected {
            cell.selectedView.isHidden = false} else {
            cell.selectedView.isHidden = true
        }
        
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(cell: cell, cellState: cellState)
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setUpCalendarView()
    }

}


