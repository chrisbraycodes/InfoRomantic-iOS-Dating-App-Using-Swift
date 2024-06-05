//
//  MatchObject.swift
//  Info-RomanticSB
//
//  Created by Christopher Bray on 12/3/22.
//

import Foundation

struct MatchObject {
    
    let id: String
    let memberIds: [String]
    let date: Date
    
    var dictionary: [String : Any] {
        return [nOBJECTID : id, nMEMBERIDS : memberIds, nDATE : date]
    }
    
    func saveToFireStore() {
        
        FirebaseReference(.Match).document(self.id).setData(self.dictionary)
    }
}
