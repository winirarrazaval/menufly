//
//  TheRecipeViewController.swift
//  menufly
//
//  Created by winifred irarrazaval Oehninger on 7/11/18.
//  Copyright © 2018 winifred irarrazaval Oehninger. All rights reserved.
//

import UIKit

class TheRecipeViewController: UIViewController {
    
    @IBOutlet weak var recipeName: UILabel!
    
    @IBOutlet weak var portions: UILabel!
    
    @IBOutlet weak var ingredients: UILabel!
    
    
    @IBOutlet weak var preparation: UILabel!
    
    
    
    @IBOutlet weak var ingredientsTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let myRecipe = theRecipes[myIndex]
        
        
        recipeName.text = myRecipe.name!
        portions.text = "Portions:\(myRecipe.portions!)"
        preparation.text = "Preparation:\(myRecipe.method!)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
