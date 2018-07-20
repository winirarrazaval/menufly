//
//  OneRecipeViewController.swift
//  menufly
//
//  Created by winifred irarrazaval Oehninger on 7/16/18.
//  Copyright © 2018 winifred irarrazaval Oehninger. All rights reserved.
//

import UIKit

class OneRecipeViewController: UIViewController {
    @IBOutlet weak var recipeName: UILabel!
    
    @IBOutlet weak var recipePortions: UILabel!
    
    @IBOutlet weak var ingredientsTable: UITableView!
    
    @IBOutlet weak var recipePreparation: UITextView!
    
    var selectedDate:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myRecipe = theRecipes[myIndex]
        
        recipeName.text = myRecipe.name?.uppercased()
    
        recipePortions.text = myRecipe.portions! + " persons"
        
        recipePreparation.text = myRecipe.method

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addToCalendar" {
            let addToCalendarController = segue.destination as! AddToCalendarController
            addToCalendarController.recipeUid = theRecipes[myIndex].uid
            addToCalendarController.recipeName = theRecipes[myIndex].name
            addToCalendarController.recipeIngredients = theRecipes[myIndex].ingredients
            addToCalendarController.selectedDate = self.selectedDate
    }
    
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
