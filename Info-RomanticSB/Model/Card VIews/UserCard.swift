//
//  UserCard.swift
//  Info-RomanticSB
//
//  Created by Christopher Bray on 12/1/22.
//

import Foundation
import Shuffle_iOS

class UserCard: SwipeCard {
    
    func configure(withModel model: UserCardModel) {
        content = UserCardContentView(withImage: model.image)
        footer = UserCardFooterView(withTitle: "\(model.name), \(model.age)",
            subTitle: model.job)
        
    }
}
