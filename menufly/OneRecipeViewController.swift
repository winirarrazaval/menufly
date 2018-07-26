//
//  OneRecipeViewController.swift
//  menufly
//
//  Created by winifred irarrazaval Oehninger on 7/16/18.
//  Copyright © 2018 winifred irarrazaval Oehninger. All rights reserved.
//

import UIKit

class OneRecipeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet weak var recipeName: UILabel!
    
    @IBOutlet weak var recipePortions: UILabel!
    
    @IBOutlet weak var ingredientsTable: UITableView!
    
    @IBOutlet weak var recipePreparation: UITextView!
    
     let ingredients = theRecipes[myIndex].ingredients
    
    var selectedDate:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myRecipe = theRecipes[myIndex]
        
        recipeName.text = myRecipe.name?.uppercased()
    
        recipePortions.text = myRecipe.portions! + " persons"
  
        recipePreparation.text = myRecipe.method
        
        ingredientsTable.delegate = self
        ingredientsTable.dataSource = self
        

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
            addToCalendarController.portions = theRecipes[myIndex].portions
    }
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return ingredients!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingredientsTable.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)
        let ingredient = ingredients![indexPath.row] as! NSDictionary
        cell.textLabel?.text = ("- \(ingredient["quantity"] as! String) \(ingredient["measurement"] as! String) of \(ingredient["name"] as! String) ")
        cell.textLabel?.textColor = UIColor.darkGray
        return cell
    }
    


}
