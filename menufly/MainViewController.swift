//
//  MainViewController.swift
//  menufly
//
//  Created by winifred irarrazaval Oehninger on 7/3/18.
//  Copyright © 2018 winifred irarrazaval Oehninger. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class MainViewController: UIViewController {
    
    var ref:DatabaseReference?
    
    var currentUser = Auth.auth().currentUser?.uid
    var currentUserName = Auth.auth().currentUser?.email

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleLogOut(_ sender: Any) {
    
        do {
            try Auth.auth().signOut()
          self.performSegue(withIdentifier: "unwindToViewController1", sender: self)
            
        } catch let signOutErr {
            print("Failed to sign out:", signOutErr)
        }
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "myRecipes" {
            let myRecipesController = segue.destination as! AllTheRecipesViewController
            myRecipesController.userUid = self.currentUser
            myRecipesController.userName = "My recipes"
            
        }
//        if segue.identifier == "toCalendar" {
//            let myCalendarController = segue.destination as! CalendarController
//            myCalendarController.selectedDateDate = Date()
//        }
    }
    

    @IBAction func unwindToMain(_ sender: UIStoryboardSegue){
        
    }

}
