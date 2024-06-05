//
//  FCollectionReference.swift
//  Info-RomanticSB
//
//  Created by Christopher Bray on 12/3/22.
//

import Foundation
import FirebaseFirestore


enum FCollectionReference: String {
    case User
    case Like
    case Match
    case Recent
}


func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    
    return Firestore.firestore().collection(collectionReference.rawValue)
}
