//
//  WishListVC.swift
//  Shopify
//
//  Created by Michael Hany on 26/02/2023.
//

import UIKit

class WishListSeeMoreVC: UIViewController
{

    
    @IBOutlet var productsCollection: UICollectionView!
    {
        didSet
        {
            productsCollection.delegate = self
            productsCollection.dataSource = self
            let wishListCellNib = UINib(nibName: "WishListCell", bundle: nil)
            productsCollection.register(wishListCellNib, forCellWithReuseIdentifier: "wishListCell")
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cartButton(_ sender: Any)
    {
        performSegue(withIdentifier: "goToCart", sender: self)
        print("cart")
    }
    
}

extension WishListSeeMoreVC: UICollectionViewDelegate
{
    
}

extension WishListSeeMoreVC: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell : WishListCell = collectionView.dequeueReusableCell(withReuseIdentifier: "wishListCell", for: indexPath) as! WishListCell
        cell.layer.borderWidth = 5
        cell.layer.borderColor = UIColor(named:"CoffeeColor")?.cgColor
        cell.layer.cornerRadius = CGFloat(20)
        return cell
    }
}

extension WishListSeeMoreVC: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: productsCollection.layer.frame.size.width - 5, height: productsCollection.layer.frame.size.height/5 - 5)
    }
}
