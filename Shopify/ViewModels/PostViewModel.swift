//
//  PostViewModel.swift
//  Shopify
//
//  Created by Adham Samer on 03/03/2023.
//

import Foundation
class PostUserViewModel {
    func postCustomer(target: EndPoints,parameters:[String:Any]){
        NetworkServices.postData(url: target.path, parameters: parameters )
    }
}
