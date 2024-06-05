//
//  LikeObject.swift
//  Info-RomanticSB
//
//  Created by Christopher Bray on 12/3/22.
//

import Foundation

struct LikeObject {
    
    let id: String
    let userId: String
    let likedUserId: String
    let date: Date
    
    var dictionary: [String : Any] {
        return [nOBJECTID : id, nUSERID : userId, nLIKEDUSERID : likedUserId, nDATE : date]
    }
    
    func saveToFireStore() {
        
        FirebaseReference(.Like).document(self.id).setData(self.dictionary)
    }
}
