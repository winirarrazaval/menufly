//
//  CreateRecipeViewController.swift
//  menufly
//
//  Created by winifred irarrazaval Oehninger on 7/11/18.
//  Copyright © 2018 winifred irarrazaval Oehninger. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CreateRecipeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
 
   
    
   
    
    
    var ref: DatabaseReference?
    
    var recipe: Dictionary = [String: Any]()
    
    var ingredients:Array = [AnyObject]()
    
    @IBOutlet weak var recipeName: UITextField!
    
    @IBOutlet weak var recipePortion: UITextField!
    
    @IBOutlet weak var recipeMethod: UITextView!
    
    @IBOutlet weak var recipeIngredient: UITextField!
    
    @IBOutlet weak var recipeIngredientQuantity: UITextField!
    
    @IBOutlet weak var recipeIngredientMeasurment: UITextField!
    
   
    @IBOutlet weak var ingredientsTable: UITableView!
    
    var selectedDate = Date()
    
    
    var ingredientsList = [String]()
    
    var theIngredientName:String = ""
    var theIngredientQuantity:String = ""
    var theIngredientMeasurement:String = ""
    
    
    var measurementArray = ["","grms", "kg", "ml","liter", "teasspoon", "tablespoon", "pinch", "unit", "cups",  "pounds", "oz", "gallon", "quater"]
    
    var chosenMeasure = 0
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeBuildingCell", for: indexPath)
        cell.textLabel?.text = ingredientsList[indexPath.row]
        return cell
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return measurementArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return measurementArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.recipeIngredientMeasurment.text = self.measurementArray[row]
        chosenMeasure = row

    }
    


    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        createDayPicker()
        createToolBar()
        
        ingredientsTable.layer.masksToBounds = true
    
        
        recipeMethod!.layer.borderWidth = 1
        recipeMethod!.layer.borderColor = UIColor.lightGray.cgColor
        
        ingredientsTable!.layer.borderWidth = 1
        ingredientsTable!.layer.borderColor = UIColor.lightGray.cgColor
        
        


    }

    func createDayPicker() {
        let dayPicker = UIPickerView()
        dayPicker.delegate = self
        
        recipeIngredientMeasurment.inputView  = dayPicker
    }
    
    func createToolBar(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        recipeIngredientMeasurment.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func addIngredient(_ sender: Any) {
        var ingredient = [String: String]()
        ingredient["name"] = recipeIngredient.text
        ingredient["quantity"] = recipeIngredientQuantity.text
        
        
        recipeIngredientMeasurment.text = measurementArray[chosenMeasure]
        ingredient["measurement"] = recipeIngredientMeasurment.text
        
        theIngredientName = recipeIngredient.text!
        theIngredientQuantity = recipeIngredientQuantity.text!
        theIngredientMeasurement = recipeIngredientMeasurment.text!
        
        ingredientsList.append("\(theIngredientQuantity) \(theIngredientMeasurement) of \(theIngredientName)")
        print(ingredientsList)
        ingredients.append(ingredient as AnyObject)
        ingredientsTable.reloadData()
    }
    
    
    @IBAction func addRecipe(_ sender: Any) {
        let userUID = Auth.auth().currentUser?.uid
        
        recipe =    ["name" : recipeName.text as Any,
                     "portions": recipePortion.text as Any,
                     "method" : recipeMethod.text as Any,
                     "ingredients" : ingredients as Any,
                     "userUID" : userUID as Any
        ]
        
        
        
        ref?.child("recipes").childByAutoId().setValue(recipe)
        
        navigationController?.popViewController(animated: true)
        //presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    
 


}
