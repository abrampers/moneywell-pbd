//
//  LoginViewController.swift
//  Moneywell
//
//  Created by Abram Situmorang on 25/02/19.
//  Copyright © 2019 Abram Situmorang. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    @IBOutlet weak var signInButton: GIDSignInButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Google Sign In
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.isLoggedIn {
            self.performSegue(withIdentifier: "loginSuccess", sender: self)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            let userObject: User = User(userId: user.userID, email: user.profile.email, name: user.profile.name, givenName: user.profile.givenName, familyName: user.profile.familyName, hasImage: user.profile.hasImage, imageURL: user.profile.imageURL(withDimension: 100))
            UserDefaults.idToken = user.authentication.idToken // Safe to send to the server
            UserDefaults.user = userObject
            UserDefaults.isLoggedIn = true
            
            self.performSegue(withIdentifier: "loginSuccess", sender: self)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        //
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
