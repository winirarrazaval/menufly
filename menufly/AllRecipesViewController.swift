//
//  AllRecipesViewController.swift
//  menufly
//
//  Created by winifred irarrazaval Oehninger on 7/5/18.
//  Copyright © 2018 winifred irarrazaval Oehninger. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class AllRecipesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    //var allRecipes = [String] ()
    let cellId = "cellId"
    var theRecipes = [Recipes]()
    
    var databaseHandle:DatabaseHandle?
    var ref:DatabaseReference?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.dataSource = self
        tableView.delegate = self

        ref = Database.database().reference()
<<<<<<< HEAD
       
=======
        fetchRecipes()
>>>>>>> workingversion
        
//         databaseHandle = ref?.child("recipes").observe(.childAdded, with: { (snapshot) in
//            print(snapshot.value! )
//            let recipe = snapshot.childSnapshot(forPath: "name").value as! String
//
//                self.allRecipes.append(recipe)
//                self.tableView.reloadData()
//
//                }
//            )
        
        
      
    }
    
    
            
    func fetchRecipes(){
        let uid = Auth.auth().currentUser?.uid
        print(uid!)
       
        databaseHandle = ref?.child("recipes").observe(.childAdded, with: { (snapshot) in
            if snapshot.childSnapshot(forPath: "userUID").value != nil {
                print("passed this")
                let recipeUserUid = snapshot.childSnapshot(forPath: "userUID").value
                if  (uid?.isEqual(recipeUserUid))! {
                    if  ((snapshot.value as? [String: AnyObject]) != nil){
                        let recipe = Recipes()
                        recipe.name = snapshot.childSnapshot(forPath: "name").value as? String
                        recipe.ingredients = snapshot.childSnapshot(forPath: "ingredients").value as Any
                        recipe.method = snapshot.childSnapshot(forPath: "method").value as? String
                        recipe.portions = snapshot.childSnapshot(forPath: "portions").value as? String
                        self.theRecipes.append(recipe)
                        
                        DispatchQueue.global(qos: .background).async {
                            // Background Thread
                            DispatchQueue.main.async {
                                // Run UI Updates or call completion block
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
    })
    }
<<<<<<< HEAD

        
    }
   
=======
>>>>>>> workingversion

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
