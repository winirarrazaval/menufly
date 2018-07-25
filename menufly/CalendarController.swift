//
//  CalendarController.swift
//  menufly
//
//  Created by winifred irarrazaval Oehninger on 7/18/18.
//  Copyright © 2018 winifred irarrazaval Oehninger. All rights reserved.
//

import UIKit
import JTAppleCalendar
import Firebase
import FirebaseDatabase

class CalendarController: UIViewController, UITableViewDataSource, UITableViewDelegate {
 
    
    @IBOutlet weak var myCalendar: JTAppleCalendarView!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var year: UILabel!
    
    
    @IBOutlet weak var recipesTable: UITableView!
    
    
    
    
    
    let currentUserUid = Auth.auth().currentUser?.uid
    
    var databaseRef = Database.database().reference()
    var listRecipes = [Recipes]()
    var uidList = [String?]()
    var theIndex = 0
    
    var startDate = Date()
    
    var selectedDate:String!
//    var selectedDateDate:Date!
    
    var allSelectedDates = [String]()
    
    var allSelectedDatesRecipes = [Recipes]()
    
    
    let formatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpCalendarView()
        
        listRecipes = []
        recipesTable.delegate = self
        recipesTable.dataSource = self
        
   //     fetchRecipes()
    
        
    }
    
    func setUpCalendarView(){
        myCalendar.minimumLineSpacing = 0
        myCalendar.minimumInteritemSpacing = 0
        
      myCalendar.allowsMultipleSelection = true
        
        myCalendar.visibleDates {(visibleDates) in
          self.setupViewsFromCalendar(from: visibleDates)
        }
        
        myCalendar.selectDates( [startDate] )
        myCalendar.scrollToDate(startDate, animateScroll: false)
    
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViewsFromCalendar(from visibleDates: DateSegmentInfo){
        guard let date = visibleDates.monthDates.first?.date else {return}
        
        self.formatter.dateFormat = "yyyy"
        self.year.text = self.formatter.string(from: date)
        
        self.formatter.dateFormat = "MMMM"
        self.month.text = self.formatter.string(from: date).uppercased()
    }
    
    
    func fetchRecipes(){
     

        databaseRef.child("calendarByDate").child(self.currentUserUid! ).child(selectedDate).queryOrdered(byChild: "recipeName").observe(.childAdded, with: { (snapshot) in
            if snapshot.childSnapshot(forPath: "userUID").value != nil {
                //   let recipeUserUid = snapshot.childSnapshot(forPath: "userUID").value
                //    if  (self.userUid?.isEqual(recipeUserUid))! {
                if  ((snapshot.value as? [String: AnyObject]) != nil){
                 
                    let recipe = Recipes()
                    recipe.uid = snapshot.key as String
                    recipe.name = snapshot.childSnapshot(forPath: "recipeName").value as? String
                    //recipe.ingredients = snapshot.childSnapshot(forPath: "ingredients").value as Any
                    //recipe.method = snapshot.childSnapshot(forPath: "method").value as? String
                    recipe.portions = snapshot.childSnapshot(forPath: "portions").value as? String
                    
                    self.listRecipes.append(recipe)
                    self.uidList.append(snapshot.key as String)
                    self.allSelectedDatesRecipes.append(recipe)
                    
                    DispatchQueue.global(qos: .background).async {
                        // Background Thread
                        DispatchQueue.main.async {
                            // Run UI Updates or call completion block
                            self.recipesTable.reloadData()
                            
                            let indexPaths = [NSIndexPath]()
                            
                            self.recipesTable.insertRows(at: indexPaths as [IndexPath], with: .none)
                            //    self.tableView.scrollToRow(at: indexPaths.last as! IndexPath, at: .bottom, animated: true)
                        }
                    }
                }
            }
        })
    }
    
   
    
    

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return allRecipes.count
        if allSelectedDates.count > 1 {
            return allSelectedDatesRecipes.count
        } else {
            if selectedDate == nil {
                return 0
            }
            return listRecipes.count }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell =  self.recipesTable.dequeueReusableCell(withIdentifier: "caledarRecipecell", for: indexPath) as! RecipeCalendarCell
        if allSelectedDates.count > 1 {
         
            cell.recipeName.text = allSelectedDatesRecipes[indexPath.row].name?.uppercased()
            let portions = allSelectedDatesRecipes[indexPath.row].portions
            if portions != nil {
                cell.recipePortions.text = ("\( allSelectedDatesRecipes[indexPath.row].portions!.uppercased()) people ")
            } else {
                    cell.recipePortions.text = ""
                }
        }
         else {
            if selectedDate == nil {
                return cell
            } else {
             
            cell.recipeName.text = listRecipes[indexPath.row].name?.uppercased() }
            let portions = listRecipes[indexPath.row].portions
            if portions != nil {
                cell.recipePortions.text = ("\( listRecipes[indexPath.row].portions!.uppercased()) people ")
            } else {
                cell.recipePortions.text = ""
            }
        }
        cell.recipeName.textColor = UIColor.darkGray
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
        
            
            formatter.dateFormat = "yyyy MM dd"
            
            
            if allSelectedDates.count > 1 {
                
                let calendarUserRef = "calendarByUser/\(self.currentUserUid!)/\(self.allSelectedDatesRecipes[indexPath.row].uid as String!)"
                let calendarUserDateRef = "calendarByDate/\(self.currentUserUid!)/\(self.selectedDate! as! String)/\(self.allSelectedDatesRecipes[indexPath.row].uid! as! String)"
                
                
                let childUpdates = [ calendarUserRef: NSNull(),
                                     calendarUserDateRef: NSNull()]
                
                allSelectedDatesRecipes.remove(at: indexPath.row)
                
                databaseRef.updateChildValues(childUpdates)
            } else {
                
                let calendarUserRef = "calendarByUser/\(self.currentUserUid!)/\(self.listRecipes[indexPath.row].uid as String!)"
                let calendarUserDateRef = "calendarByDate/\(self.currentUserUid!)/\(self.selectedDate! as! String)/\(self.listRecipes[indexPath.row].uid! as! String)"
                
                let childUpdates = [ calendarUserRef: NSNull(),
                                     calendarUserDateRef: NSNull()]
                
                listRecipes.remove(at: indexPath.row)
                uidList.remove(at: indexPath.row)
                
                 databaseRef.updateChildValues(childUpdates)
            }
            
           
            
          
            
            recipesTable.reloadData()
        }
    }
    
    
    @IBAction func addRecipe(_ sender: Any) {
      self.performSegue(withIdentifier: "chooseRecipeFromCalendar", sender: self)
        
    }
    
    @IBAction func createShoppingList(_ sender: Any) {
        print(allSelectedDatesRecipes)
      
        
        var shoppingListRecipes = [String]()
            for recipe in allSelectedDatesRecipes {
            shoppingListRecipes.append(recipe.uid! as String)
            }
        
        let shoppingListReference = "byUsersShoppingList/\((Auth.auth().currentUser?.uid)!)"
        let childUpdates = [shoppingListReference: NSNull()]
        databaseRef.updateChildValues(childUpdates)
        
        databaseRef.child("byUsersShoppingList").child(currentUserUid!).child("recipes").setValue(shoppingListRecipes)
        
        
     
        
        performSegue(withIdentifier: "shoppingList", sender: self)
        
    }
    
    @IBAction func unwindToCalendar(_ sender: UIStoryboardSegue) {
        
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

    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
       
            formatter.dateFormat = "yyyy MM dd"
            formatter.timeZone = Calendar.current.timeZone
            formatter.locale = Calendar.current.locale
            
            let startDate = formatter.date(from: "2018 07 18")!
            let endDate = formatter.date(from: "2018 12 31")!
            
            let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: 1)
            return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CalendarCell else {return}
        validCell.selectedView.isHidden = false
        validCell.dayLabel.textColor = UIColor.darkGray
        
        formatter.dateFormat = "yyyy MM dd"
        
        for date in self.myCalendar.selectedDates {
            let thisDate = formatter.string(from: date)
            if !allSelectedDates.contains(thisDate) {
                allSelectedDates.append(thisDate)}
        }
        
        
        if allSelectedDates.count > 1 {
            allSelectedDatesRecipes = []
            for date in allSelectedDates {
                selectedDate = date
                fetchRecipes()
            }
        } else  {
            
            
            selectedDate = formatter.string(from: cellState.date)
//            selectedDateDate = cellState.date
            
            listRecipes = []
            uidList = []
            
            fetchRecipes()
            
        }
        
  
        
        
        recipesTable.reloadData()
        
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CalendarCell else {return}
        print(cellState)
        validCell.selectedView.isHidden = true
        validCell.dayLabel.textColor = UIColor.white
        
        
        formatter.dateFormat = "yyyy MM dd"
        
        let thisDate = formatter.string(from: cellState.date)
        
        if let index = allSelectedDates.index(of: thisDate) {
            allSelectedDates.remove(at: index)
           
        }
        
        
            if allSelectedDates.count > 1 {
                allSelectedDatesRecipes = []
                for date in allSelectedDates {
                    selectedDate = date
                    fetchRecipes()
                }
            } else  {
                    if allSelectedDates.count == 0 {
                        allSelectedDatesRecipes = []
                        selectedDate = nil
                        listRecipes = []
                        
                        recipesTable.reloadData()
                        
                    } else {
                   
                    selectedDate = formatter.string(from: cellState.date)
                    
                    listRecipes = []
                    uidList = []
                    
                    fetchRecipes()
                    
                }
            }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
       setupViewsFromCalendar(from: visibleDates)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "header", for: indexPath) as! CalendarHeader
        return header
    }
    
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 50)
    }
    
    
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseRecipeFromCalendar" {
            let myRecipesController = segue.destination as! AllTheRecipesViewController
            myRecipesController.userUid = self.currentUserUid
            myRecipesController.userName = "My recipes"
            myRecipesController.selectedDate = self.selectedDate
        }
//    if segue.identifier == "shoppingList" {
//        let myShoppingListController = segue.destination as! ShoppingListViewController
//        myShoppingListController.recipes = self.allSelectedDatesRecipes
//    }
    }
    
    @IBAction func unwindToFriends(_ sender: UIStoryboardSegue) {
    }
    
}
