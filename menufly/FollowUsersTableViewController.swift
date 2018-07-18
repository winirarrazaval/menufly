//
//  FollowUsersTableViewController.swift
//  menufly
//
//  Created by winifred irarrazaval Oehninger on 7/12/18.
//  Copyright © 2018 winifred irarrazaval Oehninger. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class FollowUsersTableViewController: UITableViewController, UISearchResultsUpdating {
    
    let searchController = UISearchController(searchResultsController: nil)

    @IBOutlet var followUsersTable: UITableView!
    
    var usersArray = [NSDictionary]()
    var filteredUsers = [NSDictionary]()
    
    var ref = Database.database().reference()
    
    let loggedInUser = Auth.auth().currentUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self as UISearchResultsUpdating
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        

        
        ref.child("users").observe(.childAdded) { (snapshot) in
            print(snapshot.key)
        }
        
        
        
        ref.child("users").queryOrdered(byChild: "email").observe(.childAdded, with: {(snapshot) in
            
            let key = snapshot.key
            let snapshot = snapshot.value as? NSDictionary
            snapshot?.setValue(key, forKey: "uid")
            self.usersArray.append(snapshot!)
            //handle situatino when user is other
//            if (key as String == self.loggedInUser.uid) {
//                print("same as logged in user")
//            } else {
//
//            }
//
            self.followUsersTable.insertRows(at: [IndexPath(row:self.usersArray.count-1, section:0)], with: UITableViewRowAnimation.automatic)
            
        }) {(error) in
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
        
        if searchController.isActive && searchController.searchBar.text != ""{
        return filteredUsers.count
        } else {
            return self.usersArray.count
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(searchText: self.searchController.searchBar.text!)
        
    }
    
    func filterContent(searchText: String){
        self.filteredUsers = self.usersArray.filter{ user in
            let email = user["email"] as? String
            return (email?.lowercased().contains(searchText.lowercased()))!
        }
        tableView.reloadData()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let user : NSDictionary
        
        if searchController.isActive && searchController.searchBar.text != ""{
            user = filteredUsers[indexPath.row]
        } else {
            user = self.usersArray[indexPath.row]
        }
        
        cell.textLabel?.text = user["email"] as? String
        cell.detailTextLabel?.text = user["name"] as? String

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let showUserProfileController = segue.destination as! UserProfileViewController
        
        showUserProfileController.loggedInUser = self.loggedInUser
        
        if let indexPath = tableView.indexPathForSelectedRow {
            let user = usersArray[indexPath.row]
            showUserProfileController.otherUser = user
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "showUser", sender: self)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
