//
//  ProductDetailsVC.swift
//  Shopify
//
//  Created by Adham Samer on 21/02/2023.
//

import Cosmos
import Kingfisher
import UIKit

class ProductDetailsVC: UIViewController {
    private var flag: Bool = false
    var currentcellindex = 0
    var timer: Timer?
    var isDuplicated : Int = 2
    @IBOutlet var productname: UILabel!
    @IBOutlet var productprice: UILabel!
    @IBOutlet var pulldowncolor: UIButton!
    @IBOutlet var pulldownsize: UIButton!
    @IBOutlet var pagecontrol: UIPageControl!
    @IBOutlet var ItemCV: UICollectionView! {
        didSet {
            ItemCV.delegate = self
            ItemCV.dataSource = self
            ItemCV.layer.borderWidth = 2
            ItemCV.layer.borderColor = UIColor(named: "CoffeeColor")?.cgColor
            ItemCV.layer.masksToBounds = true
            ItemCV.layer.cornerRadius = 15
            let nib = UINib(nibName: "BrandCVCell", bundle: nil)
            ItemCV.register(nib, forCellWithReuseIdentifier: "offerbrandcell")
        }
    }

    @IBOutlet var reviewTableView: UITableView! {
        didSet {
            reviewTableView.delegate = self
            reviewTableView.dataSource = self
            reviewTableView.layer.borderColor = UIColor(named: "CoffeeColor")?.cgColor
            reviewTableView.layer.borderWidth = 1.5
            reviewTableView.layer.cornerRadius = 20
            let nibT = UINib(nibName: "ReviewTVCell", bundle: nil)
            reviewTableView.register(nibT, forCellReuseIdentifier: "reviewTVCell")
        }
    }

    @IBOutlet var productdescription: UITextView!
    @IBOutlet var favbtn: UIButton!

    var detailedProduct: Product?

    var cartVM: DraftOrderViewModel?
    var draftOrder: SingleDraftOrder?
    var nsDefault = UserDefaults()
    var lineItems: [[String: Any]] = []
    var lineItem: [String: Any] = [:]
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()
        productname.text = detailedProduct?.title
        productprice.text = detailedProduct?.variants?[0].price
        productdescription.text = detailedProduct?.body_html
        pagecontrol.numberOfPages = detailedProduct?.images?.count ?? 0
        productfilter(sender: pulldownsize)
        productfilter(sender: pulldowncolor)

        cartVM = DraftOrderViewModel()
        getOrders()
        
        
    }

    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(movetonext), userInfo: nil, repeats: true)
    }

    @objc func movetonext() {
        if currentcellindex < (detailedProduct?.images?.count ?? 0) - 1 {
            currentcellindex += 1
        } else {
            currentcellindex = 0
        }
        ItemCV.scrollToItem(at: IndexPath(item: currentcellindex, section: 0), at: .centeredHorizontally, animated: true)
        pagecontrol.currentPage = currentcellindex
    }

    @IBAction func addtocart(_ sender: Any) {
        // 6839029793046
        // fatma@gmail.com

        if nsDefault.value(forKey: "note") as? String == "first" {
            let params: [String: Any] = [
                "draft_order": [
               //     "note": "created",
                    "email": nsDefault.value(forKey: "customerEmail") as? String ?? "",
                    "currency": "EGP",
                    "line_items": [
                        [
                            "variant_id": detailedProduct?.variants?[0].id ?? 0,
                            "product_id": detailedProduct?.id ?? 0,
                            "title": detailedProduct?.title ?? "",
                            "vendor": detailedProduct?.vendor ?? "",
                            "quantity": 1,
                            "price": detailedProduct?.variants?[0].price ?? "",
                        ],
                    ],
                ],
            ]
            cartVM?.postNewDraftOrder(target: .alldraftOrders, params: params)

            cartVM?.bindErrorToCartVC = {
                DispatchQueue.main.async {
                    switch self.cartVM?.error?.keys.formatted() {
                    case "draft_order":
                        let draftOrderDict = self.cartVM?.error?["draft_order"] as? [String: Any]
                        self.nsDefault.set("created", forKey: "note")
                        self.nsDefault.set(draftOrderDict?["id"] as? Int, forKey: "draftOrderID")
                        print("draftOrderId=\(self.nsDefault.value(forKey: "draftOrderID") as? Int ?? 0)")
                    case "error":
                        print("Error Found")
                    default:
                        print("Default")
                    }
                }
            }
        } else {
            getOrders()
            draftOrder?.draft_order?.line_items?.forEach({ item in
                if  item.product_id == detailedProduct?.id {
                    print("ddddddddddddddd")
                    isDuplicated = 1
                }
            })
        }
        
        switch isDuplicated {
        case 1:
            print("don't save")
        case 2:
            self.lineItem = [
                "variant_id": detailedProduct?.variants?[0].id ?? 0,
                "product_id": detailedProduct?.id ?? 0,
                "title": self.detailedProduct?.title ?? "",
                "vendor": self.detailedProduct?.vendor ?? "",
                "quantity": 1,
                "price": self.detailedProduct?.variants?[0].price ?? "",
            ]
            self.lineItems.append(self.lineItem)

            let params = [
                "draft_order": [
                    "line_items": self.lineItems,
                ],
            ]

            self.cartVM?.editDraftOrder(target: .draftOrder(id: (self.nsDefault.value(forKey: "draftOrderID") as? Int ?? 0)), params: params)
        default:
            break
        }
        
    
    }

    func getOrders(){
        print("NS: \(String(describing: nsDefault.value(forKey: "draftOrderID")))")
        cartVM?.getDraftOrders(target: .draftOrder(id: (nsDefault.value(forKey: "draftOrderID") as? Int ?? 0)))
        cartVM?.bindDraftOrderToCartVC = {
            DispatchQueue.main.async {
                self.draftOrder = self.cartVM?.draftOrderResults
                //self.lineItems = self.cartVM?.draftOrderResults?.draft_orders?.first?.line_items as! [[String : Any]]
                for lineItem in self.draftOrder?.draft_order?.line_items ?? [] {
                    let tmp : [String : Any] = [
                        "variant_id": lineItem.variant_id ?? 0,
                        "product_id": lineItem.product_id ?? 0,
                        "title": lineItem.title ?? "",
                        "vendor": lineItem.vendor ?? "",
                        "quantity": 1,
                        "price": lineItem.price ?? "",
                    ]
                    self.lineItems.append(tmp)
                }
                print("ccccccccccccc\(self.lineItems)")
            }
        }
    }
    @IBAction func addtofavourite(_ sender: Any) {
        if flag == false {
            favbtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            flag = true
        } else {
            favbtn.setImage(UIImage(systemName: "heart"), for: .normal)
            flag = false
        }
    }

    func productfilter(sender: UIButton) {
        switch sender {
        case pulldowncolor:
            let c = { (_: UIAction) in }
            let colors = detailedProduct?.options?[1].values
            var colorsAction: [UIAction] = []
            for color in colors! {
                colorsAction.append(UIAction(title: color, handler: c))
            }
            pulldowncolor.menu = UIMenu(title: "", children: colorsAction)
            pulldowncolor.showsMenuAsPrimaryAction = true

        case pulldownsize:
            let c = { (_: UIAction) in
            }
            let sizes = detailedProduct?.options?[0].values
            var sizesAction: [UIAction] = []
            for size in sizes! {
                sizesAction.append(UIAction(title: size, handler: c))
            }
            pulldownsize.menu = UIMenu(title: "", children: sizesAction)
            pulldownsize.showsMenuAsPrimaryAction = true

        default:
            print("no")
        }
    }
}

// MARK: - Collection View Extension

extension ProductDetailsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailedProduct?.images?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "offerbrandcell", for: indexPath) as! BrandCVCell

        cell.offerbrandimg.kf.setImage(with: URL(string: detailedProduct?.images?[indexPath.row].src ?? ""))
        return cell
    }
}

extension ProductDetailsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ItemCV.layer.frame.size.width - 5, height: ItemCV.layer.frame.size.height - 5)
    }
}

// MARK: - Table View Extension

extension ProductDetailsVC: UITableViewDelegate {
}

extension ProductDetailsVC: UITableViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewTVCell", for: indexPath) as! ReviewTVCell

        return cell
    }
}
