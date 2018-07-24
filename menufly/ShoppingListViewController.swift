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
    
    let ref = Database.database().reference()
    var uidsFetched = 0
    var recipesLoaded = 0
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        self.ingredientsNameArray.asObservable().subscribe(onNext: { arr in
            print(arr)
            self.shoppingList.reloadData()
        }).disposed(by: disposeBag)
        self.ingredientsMeasurementArray.asObservable().subscribe(onNext: { arr in
            print(arr)
            self.shoppingList.reloadData()
        }).disposed(by: disposeBag)
        self.ingredientsQuantityArray.asObservable().subscribe(onNext: { arr in
            print(arr)
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
        self.ref.child("byUsersShoppingList").child((Auth.auth().currentUser?.uid)!).child("recipes").observe(.childAdded, with: { (snapshot) in
                let uidString = "\(snapshot.value!)"
                
                self.recipesUids.append(uidString)
                self.getIngredients(recipeUid: uidString)
            }
        )
    }
    
    func getIngredients(recipeUid: String){
        self.ref.child("recipes").child(recipeUid).observe(.childAdded, with: { (othersnapshot) in
           // let ingredientsForShoppingList:NSDictionary
            //print(othersnapshot.value)
            let oneRecipeIngredients:NSArray = othersnapshot.children.allObjects as NSArray
            for ingre in oneRecipeIngredients {
                let ingredient = ingre as! DataSnapshot
                if ingredient.value is NSDictionary {
                    let ingredientData:NSDictionary = ingredient.value as! NSDictionary
                    //                    print("\(ingredientData["name"]!)")
                    self.ingredientsNameArray.value.append("\(ingredientData["name"]!)")
                    //                    print(Int("\(ingredientData["quantity"]!)")!)
                    self.ingredientsQuantityArray.value.append(Int("\(ingredientData["quantity"]!)")!)
                    //                    print("\(ingredientData["measurement"]!)")
                    self.ingredientsMeasurementArray.value.append("\(ingredientData["measurement"]!)")
                }
            }
        })
    }
    
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return ingredientsNameArray.value.count
        }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "shoppingListCell")
            cell.textLabel?.text = ingredientsNameArray.value[indexPath.row].uppercased()
            cell.textLabel?.textColor = UIColor.darkGray
            return cell
        }
    
    
}
