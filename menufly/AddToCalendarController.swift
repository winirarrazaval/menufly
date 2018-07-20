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
        let calendarRecipeRef = "calendarByRecipe/" + (self.recipeUid) + "/" + (self.loggedInUser!.uid )
        
        
        let calendarUserData = [ "date": formatter.string(from: date) ,
                                  "recipeName": self.recipeName]
        let calendarRecipeData = [ "date": formatter.string(from: date) ,
                                  "email": "" ]
            let childUpdates = [ calendarUserRef: calendarUserData,
                                 calendarRecipeRef: calendarRecipeData]
            
            ref.updateChildValues(childUpdates)
        
         func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showCalendar" {
                let calendarController = segue.destination as! CalendarController
                    calendarController.startDate = Date()
            }
        }
        
        performSegue(withIdentifier: "showCalendar", sender: self)
        
    }
    
    
    
}



