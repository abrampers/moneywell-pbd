//
//  MoneywellTabBarController.swift
//  Moneywell
//
//  Created by Abram Situmorang on 21/02/19.
//  Copyright © 2019 Abram Situmorang. All rights reserved.
//

import UIKit

class MoneywellTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        for vc in self.viewControllers! {
            vc.tabBarItem.title = nil
            vc.tabBarItem.imageInsets = UIEdgeInsets(top: 11, left: 0, bottom: -11, right: 0)
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
