//
//  ViewController.swift
//  menufly
//
//  Created by winifred irarrazaval Oehninger on 7/3/18.
//  Copyright © 2018 winifred irarrazaval Oehninger. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate{
    
       var ref:DatabaseReference?
    
    
    @IBOutlet weak var LogInRegisterToggle: UISegmentedControl!
    
    var isSignIn:Bool = true
    
    @IBOutlet weak var signInLabel: UILabel!
    
    @IBOutlet weak var SignInButtonOn: UIButton!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ref = Database.database().reference()
        
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
        
        
        
     
    }
    
    
    
    @IBAction func handleLogout(_ sender: Any) {
        if Auth.auth().currentUser?.uid != nil {
            do {
                print("user signed out")
        try Auth.auth().signOut()
            } catch let logoutError {
                print(logoutError)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func SignRegisterChanged(_ sender: UISegmentedControl) {
        isSignIn = !isSignIn
        
        if isSignIn{
            signInLabel.text = "Sign In"
            SignInButtonOn.setTitle("Sign In", for: .normal)
        } else {
            signInLabel.text = "Register"
            SignInButtonOn.setTitle("Register", for: .normal)
        }
        
    }
    
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        if isSignIn {
            guard let theEmail = email.text, let thePassword = password.text else {
                print("form is not valid")
                return
            }
            Auth.auth().signIn(withEmail: theEmail, password: thePassword, completion: {(AuthDataResult, error) in
                if error != nil {
                    print(error!)
                    return
                }
                self.performSegue(withIdentifier: "goToHome", sender: self)
            })
        } else {
            print(123)
            guard let theEmail = email.text, let thePassword = password.text, let theName = username.text else {
                print("form is not valid")
                return
            }
            Auth.auth().createUser(withEmail: theEmail, password: (thePassword), completion: { (authResult, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                guard let uid = authResult?.user.uid else {
                    return
                }
                
                let values = ["name" : theName, "email" : theEmail]
                
                self.ref?.child("users").child(uid).updateChildValues(values, withCompletionBlock: {(err, ref) in
                    if err != nil {
                        print(err!)
                        return
                    }
                    print("saved user \(theName) into database")
                    self.performSegue(withIdentifier: "goToHome", sender: self)
                })
            }
            )
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        email.resignFirstResponder()
        password.resignFirstResponder()
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }
    
    

    
}
