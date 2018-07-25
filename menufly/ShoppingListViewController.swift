//
//  ShoppingListViewController.swift
//  menufly
//
//  Created by winifred irarrazaval Oehninger on 7/20/18.
//  Copyright © 2018 winifred irarrazaval Oehninger. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import RxSwift

class ShoppingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var shoppingList: UITableView!
    
    var recipesUids = [String]()
    var ingredients = [NSDictionary]()
    
    var ingredientsNameArray = Variable<[String]>([])
    var ingredientsQuantityArray = Variable<[Int]>([])
    var ingredientsMeasurementArray = Variable<[String]>([])
    
    var ingredientsArray = Variable<[NSDictionary]>([])
    
    var shoppingListIngredients = [NSMutableDictionary]()
    
    var ingredientsListToShow = Variable<[NSMutableDictionary]>([])
    var ingredientsListToShowuid = [String]()
    
    let ref = Database.database().reference()
    var uidsFetched = 0
    var recipesLoaded = 0
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()

        self.ingredientsArray.asObservable().subscribe(onNext: { ingredient in
          
            self.checkForEquals()
            self.shoppingList.reloadData()
        }).disposed(by: disposeBag)
        
     
        
        shoppingList.dataSource = self
        shoppingList.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchData(){
        print("Begin fetchData")
        self.ref.child("byUsersShoppingList").child((Auth.auth().currentUser?.uid)!).child("recipes").observe(.childAdded, with: { (snapshot) in
            print("Inside callback for fetchData")
                let uidString = "\(snapshot.value!)"
                
                self.recipesUids.append(uidString)
                self.getIngredients(recipeUid: uidString)
            }
        )
        print("End fetchData")
    }
    
    func getIngredients(recipeUid: String){
        print("Begin getIngredients")
        self.ref.child("recipes").child(recipeUid).observe(.childAdded, with: { (othersnapshot) in
            print("Inside callback for getIngredients")
     
            let oneRecipeIngredients:NSArray = othersnapshot.children.allObjects as NSArray
            for ingre in oneRecipeIngredients {
                let ingredient = ingre as! DataSnapshot
                if ingredient.value is NSDictionary {
                    let ingredientData:NSDictionary = ingredient.value as! NSDictionary
        
                    self.ingredientsArray.value.append(ingredientData)

                }
            }
        })
        print("End getIngredients")
    }
    
    func checkForEquals(){
        print("Begin checkForEquals")
       
        for ingredient in ingredientsArray.value {
          let firstFilterIngredientArray = ingredientsArray.value.filter{ $0["name"] as! String == ingredient["name"] as! String}
            let ingredientArray = firstFilterIngredientArray.filter{ $0["measurement"] as! String == ingredient["measurement"] as! String}
            var counter = 0
            for one in ingredientArray {
          
                let number = one["quantity"]
                counter += Int(number as! String)!
            }
            print ("this is counter \(counter)")
            let shoppingIngredient:NSMutableDictionary = ["name" : ingredient["name"] as! String,
                                      "quantity" : String(counter),
                                      "measurement" : ingredient["measurement"] as! String]
            print(shoppingIngredient)
        
            let name:String = ingredient["name"] as! String
            let measurement:String = ingredient["measurement"] as! String
            
            if !(shoppingListIngredients.contains{ $0["name"] as! String == name && $0["measurement"] as! String == measurement }) {
                shoppingListIngredients.append(shoppingIngredient )
                print("the last \(shoppingListIngredients)")
                shoppingList.reloadData()
            } else {
               let index =  shoppingListIngredients.index(where: {$0["name"] as! String == name})
                shoppingListIngredients[index!]["quantity"] = String(counter )
            }
            
        }
        createIngredientsShoppingList()
     
    }
    
    func createIngredientsShoppingList (){
        ref.child("byUsersShoppingList").child((Auth.auth().currentUser?.uid)!).child("ingredientsShoppingList").setValue(shoppingListIngredients)
        
        retrieveIngredientsShoppingList()
        }
    
    func retrieveIngredientsShoppingList(){
        ref.child("byUsersShoppingList").child((Auth.auth().currentUser?.uid)!).child("ingredientsShoppingList").queryOrdered(byChild: "name").observe(.childAdded, with: { (snapshot) in
            print("data returnd")
            print("this is and ingredient in shopping list :\(snapshot)")
            
            let snapshotUid = snapshot.key
            let snapshot = snapshot.value as? NSMutableDictionary
            snapshot!["uid"] = snapshotUid
            
            let name = snapshot!["name"] as! String
            let quantity = snapshot!["quantity"] as! String
            
            if !self.ingredientsListToShowuid.contains(snapshotUid){
                self.ingredientsListToShow.value.append((snapshot)! )
            self.ingredientsListToShowuid.append(snapshotUid)
            } else {
                let index =  self.ingredientsListToShow.value.index(where: {$0["name"] as! String == name})
                self.ingredientsListToShow.value[index!]["quantity"] = quantity
            }
            print("the one and only ingredients array: \(self.ingredientsListToShow.value)")
            self.shoppingList.reloadData()
//
//            self.followingTableView.insertRows(at: [IndexPath(row:self.listFollowing.count-1,section:0)], with: UITableViewRowAnimation.automatic)
//
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
            return ingredientsListToShow.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           print("my shopping list \(ingredientsListToShow.value)")
         let cell =  shoppingList.dequeueReusableCell(withIdentifier: "shoppingListCell", for: indexPath) as! ShoppingListCell
            cell.ingredientName?.text = (ingredientsListToShow.value[indexPath.row]["name"] as! String).uppercased()
            cell.ingredientName?.textColor = UIColor.darkGray
        let thisQuantity = String(ingredientsListToShow.value[indexPath.row]["quantity"] as! String)
            cell.quantity?.text = "\(thisQuantity.uppercased()) \((ingredientsListToShow.value[indexPath.row]["measurement"] as! String).uppercased())"
            cell.quantity?.textColor = UIColor.darkGray
            return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ingredientsListToShow.value.remove(at: indexPath.item)
            shoppingList.deleteRows(at: [indexPath], with: .automatic)
            ref.child("byUsersShoppingList").child((Auth.auth().currentUser?.uid)!).child("ingredientsShoppingList").child((ingredientsListToShow.value[indexPath.row - 1]["uid"] as! String?)!).setValue(NSNull())
        }
    }
    
 
    @IBAction func editShoppingList(_ sender: Any) {
        self.shoppingList.isEditing = !self.shoppingList.isEditing
        navigationItem.title = (self.shoppingList.isEditing) ? "Editing" : "Shopping List"
        
    }
    
    
    @IBAction func deleteShoppingList(_ sender: Any) {
        let shoppingListReference = "byUsersShoppingList/\((Auth.auth().currentUser?.uid)!)"
        let childUpdates = [shoppingListReference: NSNull()]
        ref.updateChildValues(childUpdates)
        self.navigationController?.popViewController(animated: true)
    }
    
}
