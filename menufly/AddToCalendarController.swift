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

class AddToCalendarController: UIViewController {
    
    var recipeUid: String!
    var recipeName: String!
    var recipeIngredients: Any!
    var selectedDate:String!

    @IBOutlet weak var recipe: UILabel!
    
    @IBOutlet weak var uid: UILabel!
    
    let date = Date()
    let formatter = DateFormatter()
    
    var ref = Database.database().reference()
    
    var loggedInUser = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipe.text = recipeName
    
    }


    
    var loggedInUserData:NSDictionary = [:]
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addToCalendar(_ sender: Any) {
        
        formatter.dateFormat = "yyyy MM dd"
    
        let calendarUserRef = "calendarByUser/\(self.loggedInUser!.uid )/\(self.recipeUid)"
        let calendarUserDateRef = "calendarByDate/" + (self.loggedInUser!.uid) + "/" + (self.selectedDate) + "/" +  (self.recipeUid)
        
        
        let calendarUserData = [ "date": selectedDate ,
                                  "recipeName": self.recipeName,
                                  "ingredients" : self.recipeIngredients]
        let calendarByDateData = [ "recipeName": self.recipeName ,
                                  "recipeUid": self.recipeUid,
                                  "ingredients": self.recipeIngredients]
        let childUpdates = [ calendarUserRef: calendarUserData as Any,
                                 calendarUserDateRef: calendarByDateData]
            
            ref.updateChildValues(childUpdates)
    
        
    }
    
    
    
}



