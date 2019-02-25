//
//  AccountViewController.swift
//  Moneywell
//
//  Created by Abram Situmorang on 25/02/19.
//  Copyright © 2019 Abram Situmorang. All rights reserved.
//

import UIKit
import GoogleSignIn

class AccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signOut()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
//        UIApplication.shared.keyWindow?.rootViewController = initial
        UIApplication.setRootView(initial!, options: UIApplication.logoutAnimation)
        UserDefaults.isLoggedIn = false
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
