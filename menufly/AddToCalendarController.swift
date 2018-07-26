//
//  AddToCalendarController.swift
//  menufly
//
//  Created by winifred irarrazaval Oehninger on 7/19/18.
//  Copyright © 2018 winifred irarrazaval Oehninger. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import JTAppleCalendar

class AddToCalendarController: UIViewController, JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    var recipeUid: String!
    var recipeName: String!
    var recipeIngredients: Any!
    var selectedDate:String!
    var portions:String!

    @IBOutlet weak var recipe: UILabel!
    
    @IBOutlet weak var myCalendar: JTAppleCalendarView!
    
    let date = Date()
    let formatter = DateFormatter()
    
    
    var ref = Database.database().reference()
    
    var loggedInUser = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCalendarView()
        
        recipe.text = recipeName
    
    }


    
    var loggedInUserData:NSDictionary = [:]
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addToCalendar(_ sender: Any) {
        
       
        
        formatter.dateFormat = "yyyy MM dd"
        
        if selectedDate == nil {
            let today = Date()
            selectedDate = formatter.string(from: today)
        }
    
        let calendarUserRef = "calendarByUser/\(self.loggedInUser!.uid )/\(self.recipeUid)"
        let calendarUserDateRef = "calendarByDate/" + (self.loggedInUser!.uid) + "/" + (self.selectedDate) + "/" +  (self.recipeUid)
        
        
        let calendarUserData = [ "date": selectedDate ,
                                  "recipeName": self.recipeName,
                                  "ingredients" : self.recipeIngredients,
                                  "portions" : self.portions]
        let calendarByDateData = [ "recipeName": self.recipeName ,
                                  "recipeUid": self.recipeUid,
                                  "ingredients": self.recipeIngredients,
                                  "portions": self.portions]
        let childUpdates = [ calendarUserRef: calendarUserData as Any,
                             calendarUserDateRef: calendarByDateData]
            
            ref.updateChildValues(childUpdates)
    
        
    }
    
    func setUpCalendarView(){
        myCalendar.minimumLineSpacing = 0
        myCalendar.minimumInteritemSpacing = 0
        
        myCalendar.allowsMultipleSelection = false
        
//        myCalendar.visibleDates {(visibleDates) in
//            self.setupViewsFromCalendar(from: visibleDates)
//        }
        
        myCalendar.selectDates( [date] )
        myCalendar.scrollToDate(date, animateScroll: false)
        
        
        
    }
    
//    func setupViewsFromCalendar(from visibleDates: DateSegmentInfo){
//        guard let date = visibleDates.monthDates.first?.date else {return}
//        
//        self.formatter.dateFormat = "yyyy"
//        //self.year.text = self.formatter.string(from: date)
//        
//        self.formatter.dateFormat = "MMMM"
//        //self.month.text = self.formatter.string(from: date).uppercased()
//    }
    
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
        
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2018 07 18")!
        let endDate = formatter.date(from: "2018 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: 5)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CalendarCell else {return}
        validCell.selectedView.isHidden = false
        validCell.dayLabel.textColor = UIColor.darkGray
        
        formatter.dateFormat = "yyyy MM dd"
    
        
        selectedDate = formatter.string(from: date)
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CalendarCell else {return}
        print(cellState)
        validCell.selectedView.isHidden = true
        validCell.dayLabel.textColor = UIColor.white
        
        
        formatter.dateFormat = "yyyy MM dd"
        
        let today = Date()
        selectedDate = formatter.string(from: today)
        
        
        
        
    }
    
//    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
//        setupViewsFromCalendar(from: visibleDates)
//    }
//
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "header", for: indexPath) as! CalendarHeader
        return header
    }
    
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 50)
    }
    
//    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
//        return MonthSize(defaultSize: 50)
//}
}



