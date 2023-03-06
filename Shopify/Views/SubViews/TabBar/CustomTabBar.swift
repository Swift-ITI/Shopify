//
//  CustomTabBar.swift
//  Shopify
//
//  Created by Adham Samer on 23/02/2023.
//

import UIKit

class CustomTabBar: UITabBarController {

    var nsDefault = UserDefaults()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.layer.cornerRadius = 20
        if !nsDefault.bool(forKey: "isLogged") {
            let loginVC = UIStoryboard(name: "AuthenticationSB", bundle: nil).instantiateViewController(withIdentifier: "loginVC")
            navigationController?.pushViewController(loginVC, animated: true)
        }
       
        // Do any additional setup after loading the view.
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
