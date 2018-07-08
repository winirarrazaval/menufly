//
//  NewRecipeViewController.swift
//  menufly
//
//  Created by winifred irarrazaval Oehninger on 7/4/18.
//  Copyright © 2018 winifred irarrazaval Oehninger. All rights reserved.
//

import UIKit
import FirebaseDatabase

class NewRecipeViewController: UIViewController {
    
   
    var ref: DatabaseReference?
    
    var recipe: Dictionary = [String: Any]()
    
    var ingredients:Array = [AnyObject]()
    
    @IBOutlet weak var recipeName: UITextField!
    
    @IBOutlet weak var recipePortion: UITextField!
    
    @IBOutlet weak var recipeMethod: UITextField!
    
    @IBOutlet weak var recipeIngredient: UITextField!
    
    @IBOutlet weak var recipeIngredientQuantity: UITextField!
    
    @IBOutlet weak var recipeIngredientMeasurment: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func addIngredient(_ sender: Any) {
        var ingredient = [String: String]()
        ingredient["name"] = recipeIngredient.text
        ingredient["quantity"] = recipeIngredientQuantity.text
        ingredient["measurement"] = recipeIngredientMeasurment.text
        
        ingredients.append(ingredient as AnyObject)
    }
    
    

    

    @IBAction func addRecipe(_ sender: Any) {
        recipe =    ["name" : recipeName.text as Any,
                     "portions": recipePortion.text as Any,
                     "method" : recipeMethod.text as Any,
                     "ingredients" : ingredients as Any
            ]
        
        
        
        ref?.child("recipes").childByAutoId().setValue(recipe)
       
        //ref?.child("recipes").child().setValue(recipeName.text)
        
    
            presentingViewController?.dismiss(animated: true, completion: nil)
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
