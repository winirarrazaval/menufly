//
//  FollowUsersViewController.swift
//  menufly
//
//  Created by winifred irarrazaval Oehninger on 7/12/18.
//  Copyright © 2018 winifred irarrazaval Oehninger. All rights reserved.
//

import UIKit

class FollowUsersViewController: UITableViewController {
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
 
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self as? UISearchResultsUpdating 
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
      
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
