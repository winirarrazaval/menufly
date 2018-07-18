//
//  MyFriendsTableViewController.swift
//  menufly
//
//  Created by winifred irarrazaval Oehninger on 7/12/18.
//  Copyright © 2018 winifred irarrazaval Oehninger. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

 var myFriends = [NSDictionary]()

class MyFriendsTableViewController: UITableViewController {
    
 
    var user = Auth.auth().currentUser
    var databaseRef = Database.database().reference()
    var listFollowing = [NSDictionary?]()
    var uidList = [String?]()
    var theIndex = 0
    
    @IBOutlet var followingTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get all the users the signed in user is following
        databaseRef.child("following").child(self.user!.uid ).queryOrdered(byChild: "email").observe(.childAdded, with: { (snapshot) in
            print("data returnd")
            print(snapshot)
            
            let snapshotUid = snapshot.key
            let snapshot = snapshot.value as? NSDictionary
            
            //add the users to the array
            self.listFollowing.append(snapshot)
            self.uidList.append(snapshotUid)
            
            self.followingTableView.insertRows(at: [IndexPath(row:self.listFollowing.count-1,section:0)], with: UITableViewRowAnimation.automatic)
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.listFollowing.count
    }
    
    //dismiss the modal and move back to the meViewController
    @IBAction func didTapDismiss(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "followingUserCell", for: indexPath)
        
        print(self.listFollowing[indexPath.row]!)
        
        cell.textLabel?.text = self.listFollowing[indexPath.row]?["email"] as? String
        cell.detailTextLabel?.text = "@"+(self.listFollowing[indexPath.row]?["name"] as? String)!
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        theIndex = myIndex
        performSegue(withIdentifier: "myFriendsRecipes", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "myFriendsRecipes" {
            let myRecipesController = segue.destination as! AllTheRecipesViewController
            myRecipesController.userUid = self.uidList[theIndex]
        }
    }
}
