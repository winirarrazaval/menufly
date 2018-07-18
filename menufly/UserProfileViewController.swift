//
//  UserProfileViewController.swift
//  menufly
//
//  Created by winifred irarrazaval Oehninger on 7/12/18.
//  Copyright © 2018 winifred irarrazaval Oehninger. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class UserProfileViewController: UIViewController {

    @IBOutlet weak var followButton: UIButton!
    
    @IBOutlet weak var name: UILabel!
    
    var loggedInUser = Auth.auth().currentUser
    
    var otherUser:NSDictionary = [:]
    
    var ref = Database.database().reference()
    
    var loggedInUserData:NSDictionary = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref.child("users").child(self.loggedInUser!.uid ).observe(.value) { (snapshot) in
            self.loggedInUserData = snapshot.value as! NSDictionary
            self.loggedInUserData.setValue(self.loggedInUser?.uid, forKey: "uid")
        }
        
        ref.child("users").child(self.otherUser["uid"] as! String).observe(.value) { (snapshot) in
        let uid = self.otherUser["uid"] as! String
            self.otherUser = snapshot.value as! NSDictionary
            self.otherUser.setValue(uid, forKey: "uid")
        }
        
        ref.child("following").child(self.loggedInUser!.uid ).child(self.otherUser["uid"] as! String).observe(.value) { (snapshot) in
            if snapshot.exists() {
                self.followButton.setTitle("Unfollow", for: .normal)
            } else {
                self.followButton.setTitle("Follow", for: .normal)
            }
        }
        
        self.name.text = self.otherUser["email"] as? String
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func didTapFollow(_ sender: Any) {
        let followersRef = "followers/\(self.otherUser["uid"] as! String)/\(self.loggedInUserData["uid"] as! String)"
        let followingRef = "following/" + (self.loggedInUserData["uid"] as! String) + "/" + (self.otherUser["uid"] as! String)
        
        if (self.followButton.titleLabel?.text == "Follow"){
            let followersData = [ "name": self.loggedInUserData["name"] as! String,
                                  "email": self.loggedInUserData["email"] as! String]
            let followingData = [ "name": self.otherUser["name"] as! String,
                                  "email": self.otherUser["email"] as! String]
            let childUpdates = [ followersRef: followersData,
                                 followingRef: followingData]
            
            ref.updateChildValues(childUpdates)
            
            let followersCount:Int
            let followingCount:Int
            
            if (self.otherUser["followersCount"] == nil) {
                followersCount = 1
            } else {
                followersCount = self.otherUser["followersCount"] as! Int + 1
            }
            
            if (self.loggedInUserData["followingCount"] == nil){
                followingCount = 1
            } else {
                followingCount = self.loggedInUserData["followingCount"] as! Int + 1
            }
            
            ref.child("users").child(self.loggedInUserData["uid"] as! String).child("followingCount").setValue(followingCount)
            
            ref.child("users").child(self.otherUser["uid"] as! String).child("followersCount").setValue(followersCount)
        }
        else {
            
            ref.child("users").child(self.loggedInUserData["uid"] as! String).child("followingCount").setValue(self.loggedInUserData["followingCount"] as! Int-1)
            
            ref.child("users").child(self.otherUser["uid"] as! String).child("followersCount").setValue(self.otherUser["followersCount"] as! Int-1)
            
            let followersRef = "followers/\(self.otherUser["uid"] as! String)/\(self.loggedInUserData["uid"] as! String)"
            let followingRef = "following/" + "/" + (self.loggedInUserData["uid"] as! String) + "/" + (self.otherUser["uid"] as! String)
            
            let childUpdates = [followingRef: NSNull(), followersRef: NSNull()]
            
            ref.updateChildValues(childUpdates)
        }
            
        }
        
    }
    


