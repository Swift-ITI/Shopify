//
//  ViewController.swift
//  Shopify
//
//  Created by Adham Samer on 17/02/2023.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var OfferCV: UICollectionView!
    @IBOutlet weak var BrandsCV: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        OfferCV.delegate = self
        OfferCV.dataSource = self
        
        BrandsCV.dataSource = self
        BrandsCV.delegate = self

        
        let nib = UINib(nibName: "BrandCVCell", bundle: nil)
        OfferCV.register(nib,forCellWithReuseIdentifier: "offerbrandcell")
        BrandsCV.register(nib, forCellWithReuseIdentifier: "offerbrandcell")
        
        let fav = UIBarButtonItem(image: UIImage(systemName: "heart.fill"),style: .plain , target: self, action: #selector(navfav))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "BeigeColor")
        
        let cartt = UIBarButtonItem(image: UIImage(systemName: "cart.fill"), style: .plain, target: self, action: #selector(navcart))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "BeigeColor")
        navigationItem.rightBarButtonItems = [fav , cartt]
        
        /*let search =  UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(search))
         self.navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "AccentColor")
         navigationItem.leftBarButtonItem = search*/
        OfferCV.layer.cornerRadius = 20
        OfferCV.layer.borderWidth = 5
        OfferCV.layer.borderColor = UIColor(named: "BeigeColor")?.cgColor
        
        BrandsCV.layer.cornerRadius = 20
        BrandsCV.layer.borderWidth = 5
        BrandsCV.layer.borderColor = UIColor(named: "BeigeColor")?.cgColor
    }
    
    @objc func navfav()
    {
        let FavouriteStoryBoardd = UIStoryboard(name: "OthersSB", bundle: nil)
        let favobj = FavouriteStoryBoardd.instantiateViewController(withIdentifier: "favid") as! WishListVC
        self.navigationController?.pushViewController(favobj, animated: true)
    }
    @objc func navcart()
    {
        let CartStoryBoard = UIStoryboard(name: "OthersSB", bundle: nil)
        let cartobj =
        CartStoryBoard.instantiateViewController(withIdentifier: "cartid") as! CartVC
        self.navigationController?.pushViewController(cartobj, animated: true)
    }
    /*@objc func search()
    {
        let searchobj = self.storyboard?.instantiateViewController(withIdentifier: "search") as! SearchViewController
        self.navigationController?.pushViewController(searchobj, animated: true)
    }*/
}
        
extension HomeVC : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
            case OfferCV:
                return 8
            case BrandsCV:
                return 10
            default:
                return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
            case OfferCV:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "offerbrandcell", for: indexPath) as! BrandCVCell
                
                cell.offerbrandimg.image = UIImage(named: "coupon")
                return cell
            case BrandsCV:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "offerbrandcell", for: indexPath) as! BrandCVCell
                cell.offerbrandimg.image = UIImage(named: "coupon")
                cell.layer.cornerRadius = 20
                cell.layer.borderColor = UIColor(named: "BeigeColor")?.cgColor
                cell.layer.borderWidth = 2
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                return cell
        }
    }

}
extension HomeVC : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
            case BrandsCV:
                let productobj : ProductsVC = self.storyboard?.instantiateViewController(withIdentifier: "productsid") as! ProductsVC
                self.navigationController?.pushViewController(productobj, animated: true)
            default:
                break
        }
    }
}

extension HomeVC : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
            case OfferCV:
                return CGSize(width: OfferCV.layer.frame.size.width - 16, height: OfferCV.layer.frame.size.height - 20)
            case BrandsCV:
                return CGSize(width: BrandsCV.layer.frame.size.width/2 - 16, height: BrandsCV.layer.frame.size.height/2 - 10)
            default:
                return CGSize(width: (UIScreen.main.bounds.size.width/2) - 50, height: (UIScreen.main.bounds.size.height/6) - 10)
        }
        
    }
}
