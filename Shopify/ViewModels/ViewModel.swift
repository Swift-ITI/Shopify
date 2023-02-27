//
//  ViewModel.swift
//  Shopify
//
//  Created by Adham Samer on 21/02/2023.
//

import Foundation
import UIKit

//class buttonss {
//    var viewController : UIViewController = UIViewController()
//
//    init(viewController: UIViewController) {
//        self.viewController = viewController
//    }
//
//func addBarButtonItems(){
//        let fav = UIButton()
//    fav.setImage(UIImage(systemName: "heart"), for: .normal)
//    fav.addTarget(viewController, action: #selector(navfav), for: .touchUpInside)
//        viewController.navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "BeigeColor")
//
//        let cart = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: viewController, action: #selector(navcart))
//        viewController.navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "BeigeColor")
//    viewController.navigationItem.rightBarButtonItem?.customView = fav as UIView
//     //   viewController.navigationItem.rightBarButtonItems = [fav as UIBarButtonItem , cart]
//
//        let search =  UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: viewController, action: #selector(navsearch))
//        viewController.navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "BeigeColor")
//        viewController.navigationItem.leftBarButtonItem = search
//
//    }
//
//    @objc func navfav()
//    {
//        let FavouriteStoryBoardd = UIStoryboard(name: "OthersSB", bundle: nil)
//        let favobj = FavouriteStoryBoardd.instantiateViewController(withIdentifier: "favid") as! WishListVC
//        viewController.navigationController?.pushViewController(favobj, animated: true)
//    }
//    @objc func navcart()
//    {
//        let CartStoryBoard = UIStoryboard(name: "OthersSB", bundle: nil)
//        let cartobj =
//        CartStoryBoard.instantiateViewController(withIdentifier: "cartid") as! CartVC
//        viewController.navigationController?.pushViewController(cartobj, animated: true)
//    }
//    @objc func navsearch()
//    {
//        print("aa")
////        let searchobj = self.storyboard?.instantiateViewController(withIdentifier: "search") as! SearchViewController
////        self.navigationController?.pushViewController(searchobj, animated: true)
//    }
//}
