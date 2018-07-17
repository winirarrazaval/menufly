//
//  AllTheRecipesViewController.swift
//  menufly
//
//  Created by winifred irarrazaval Oehninger on 7/11/18.
//  Copyright © 2018 winifred irarrazaval Oehninger. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

 var theRecipes = [Recipes]()
 var myIndex = 0



class AllTheRecipesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellId = "cellId"
    

    var userUid:String!
   
    var databaseHandle:DatabaseHandle?
    var ref:DatabaseReference?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        theRecipes = []
        
        tableView.dataSource = self
        tableView.delegate = self
        
        ref = Database.database().reference()
        fetchRecipes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchRecipes(){
        databaseHandle = ref?.child("recipes").observe(.childAdded, with: { (snapshot) in
            if snapshot.childSnapshot(forPath: "userUID").value != nil {
                let recipeUserUid = snapshot.childSnapshot(forPath: "userUID").value
                if  (self.userUid?.isEqual(recipeUserUid))! {
                    if  ((snapshot.value as? [String: AnyObject]) != nil){
                        let recipe = Recipes()
                        recipe.name = snapshot.childSnapshot(forPath: "name").value as? String
                        recipe.ingredients = snapshot.childSnapshot(forPath: "ingredients").value as Any
                        recipe.method = snapshot.childSnapshot(forPath: "method").value as? String
                        recipe.portions = snapshot.childSnapshot(forPath: "portions").value as? String
                        theRecipes.append(recipe)
                        
                        DispatchQueue.global(qos: .background).async {
                            // Background Thread
                            DispatchQueue.main.async {
                                // Run UI Updates or call completion block
                                self.tableView.reloadData()
                                
                                let indexPaths = [NSIndexPath]()
                                
                                self.tableView.insertRows(at: indexPaths as [IndexPath], with: .none)
                            //    self.tableView.scrollToRow(at: indexPaths.last as! IndexPath, at: .bottom, animated: true)
                            }
                        }
                    }
                }
            }
        })
    }
    
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return allRecipes.count
        return theRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "postCell")
        //cell?.textLabel?.text = allRecipes[indexPath.row]
        //return cell!
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        cell.textLabel?.text = theRecipes[indexPath.row].name
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            theRecipes.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        performSegue(withIdentifier: "test", sender: self)
    }

    
   
}
