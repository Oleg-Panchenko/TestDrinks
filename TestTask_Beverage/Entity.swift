//
//  Entity.swift
//  TestTask_Beverage
//
//  Created by Panchenko Oleg on 30.07.2022.
//

import Foundation

struct Coctail: Codable {
    var drinks: [Drinks]
}

struct Drinks: Codable {
    let drinkName: String?
    let drinkImageUrl: String?
    
    private enum CodingKeys: String, CodingKey {
        case drinkName = "strDrink"
        case drinkImageUrl = "strDrinkThumb"
    }
}
