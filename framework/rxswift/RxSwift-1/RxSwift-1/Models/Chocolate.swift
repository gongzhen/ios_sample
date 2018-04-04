//
//  Chocolate.swift
//  RxSwift-1
//
//  Created by ULS on 4/3/18.
//  Copyright © 2018 ULS. All rights reserved.
//

import Foundation

func ==(lhs: Chocolate, rhs: Chocolate) -> Bool {
    return true;
}

struct Chocolate :Equatable {
    let priceInDollars: Float
    let countryName: String
    let countryFlagEmoji: String
    
    // An array of chocolate from europe
    
    init(priceInDollars:Float, countryName:String, countryFlagEmoji: String) {
        self.priceInDollars = priceInDollars
        self.countryName = countryName
        self.countryFlagEmoji = countryFlagEmoji;
    }
    
    static let ofEurope: [Chocolate] = {
        let belgian = Chocolate(priceInDollars: 8,
                                countryName: "Belgium",
                                countryFlagEmoji: "🇧🇪")
        let british = Chocolate(priceInDollars: 7,
                                countryName: "Great Britain",
                                countryFlagEmoji: "🇬🇧")
        let dutch = Chocolate(priceInDollars: 8,
                              countryName: "The Netherlands",
                              countryFlagEmoji: "🇳🇱")
        let german = Chocolate(priceInDollars: 7,
                               countryName: "Germany", countryFlagEmoji: "🇩🇪")
        let swiss = Chocolate(priceInDollars: 10,
                              countryName: "Switzerland",
                              countryFlagEmoji: "🇨🇭")
        return [
            belgian,
            british,
            dutch,
            german,
            swiss,
        ]
    }()
}

extension Chocolate: Hashable {
    var hashValue: Int {
        return self.countryFlagEmoji.hashValue
    }
}
