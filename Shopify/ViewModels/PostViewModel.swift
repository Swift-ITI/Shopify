//
//  PostViewModel.swift
//  Shopify
//
//  Created by Adham Samer on 03/03/2023.
//

import Foundation

class PostUserViewModel {
    var bindErrorToVC:(()->()) = {}
    var error:[String:Any]? {
        didSet{
            bindErrorToVC()
        }
    }
    func postCustomer(target: EndPoints,parameters:[String:Any]){
        NetworkServices.postData(url: target.path, parameters: parameters, err: {error in
            self.error = error
        } )
    }

}
