//
//  ProfileViewModel.swift
//  Shopify
//
//  Created by Michael Hany on 01/03/2023.
//

import Foundation

class ProfileView
{
    var bindResultToProfileVC : (()->()) = {}
    var userResult : User?
    {
        didSet
        {
            bindResultToProfileVC()
        }
    }
    
    func getUser (id : Int)
    {
        FetchUserData.fetchURLUser(compeletionHandeler: {result in self.userResult = result?.customers}, id: id)
    }
}
