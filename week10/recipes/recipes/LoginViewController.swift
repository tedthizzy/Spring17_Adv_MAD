//
//  LoginViewController.swift
//  recipes
//
//  Created by Aileen Pierce on 3/22/17.
//  Copyright © 2017 Aileen Pierce. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self

        // Do any additional setup after loading the view.
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        guard let authentication = user.authentication
            else {
                return
            }
        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                          accessToken: authentication.accessToken)
        
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            // ...
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print("User logged in with Google")
            
            //create a UIAlertController object
            let alert=UIAlertController(title: "Firebase", message: "Welcome to Firebase " + (user?.displayName)!, preferredStyle: UIAlertControllerStyle.alert)
            //create a UIAlertAction object for the button
            let okAction=UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {action in
                //perform segue
                self.performSegue(withIdentifier: "showRecipes", sender: nil)
            })
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        try! FIRAuth.auth()!.signOut()
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
