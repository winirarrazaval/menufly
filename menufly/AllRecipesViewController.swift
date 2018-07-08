//
//  AllRecipesViewController.swift
//  menufly
//
//  Created by winifred irarrazaval Oehninger on 7/5/18.
//  Copyright © 2018 winifred irarrazaval Oehninger. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AllRecipesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var allRecipes = [String] ()
    
    var databaseHandle:DatabaseHandle?
    var ref:DatabaseReference?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.dataSource = self
        tableView.delegate = self

        ref = Database.database().reference()
        
         databaseHandle = ref?.child("recipes").observe(.childAdded, with: { (snapshot) in
            print(snapshot.value! )
            let recipe = snapshot.childSnapshot(forPath: "name").value as! String
            
                self.allRecipes.append(recipe)
                self.tableView.reloadData()
                    
                }
            )
            
    }
            
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell")
        cell?.textLabel?.text = allRecipes[indexPath.row]
        
        return cell!
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
