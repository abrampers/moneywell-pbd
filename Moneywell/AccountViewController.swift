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
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        logoutButton.layer.cornerRadius = 15
        nameLabel.text = UserDefaults.user?.name
        emailLabel.text = UserDefaults.user?.email
        profileImage.isHidden = true
        
        fetchImage()
    }
    
    private func fetchImage() {
        if let url = UserDefaults.user?.imageURL {
            print(url)
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let imageData = urlContents {
                        self?.profileImage.image = UIImage(data: imageData)
                        self?.spinner.stopAnimating()
                        self?.profileImage.isHidden = false
                    } else {
                        self?.profileImage.image = UIImage(named: "user")
                        self?.spinner.stopAnimating()
                        self?.profileImage.isHidden = false
                    }
                }
            }
        } else {
            self.profileImage.image = UIImage(named: "user")
            self.spinner.stopAnimating()
            self.profileImage.isHidden = false
        }
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signOut()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
//        UIApplication.shared.keyWindow?.rootViewController = initial
        UIApplication.setRootView(initial!, options: UIApplication.logoutAnimation)
        UserDefaults.isLoggedIn = false
    }
    
    @IBAction func questionsButtonTapped(_ sender: UIButton) {
        print("tapped")
        let email = "abram.perdanaputra@gmail.com"
        let subject = "Here's%20my%20question%20about%20Moneywell"
        if let url = URL(string: "mailto:\(email)?subject=\(subject)") {
            print("masuk")
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
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
