//
//  Currency.swift
//  Shopify
//
//  Created by Michael Hany on 14/03/2023.
//

import Foundation

class CurrencyExchanger
{
    
    static var currencyExchanger = UserDefaults()
    static var money : Float?
    
    static func changeCurrency(cash: String) -> String
    {
        switch currencyExchanger.value(forKey: "CashType")
        {
        case "USD" as String:
            money = Float(cash)
            
        case "EGP" as String:
            money = (Float(cash) ?? 0.0) * 30
            
        default:
            print("Error in Currency Exchanger")
        }
        return "\(money ?? 0.0)"
    }
}
