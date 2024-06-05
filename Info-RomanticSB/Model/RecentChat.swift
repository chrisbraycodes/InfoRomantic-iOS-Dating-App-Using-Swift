//
//  RecentChat.swift
//  Info-RomanticSB
//
//  Created by Christopher Bray on 12/3/22.
//

import Foundation
import UIKit
import Firebase

class RecentChat {
    
    var objectId = ""
    var chatRoomId = ""
    var senderId = ""
    var senderName = ""
    var receiverId = ""
    var receiverName = ""
    var date = Date()
    var memberIds = [""]
    var lastMessage = ""
    var unreadCounter = 0
    var avatarLink = ""
    
    var avatar: UIImage?
    
    var dictionary: NSDictionary {
        
        return NSDictionary(objects: [self.objectId,
                                      self.chatRoomId,
                                      self.senderId,
                                      self.senderName,
                                      self.receiverId,
                                      self.receiverName,
                                      self.date,
                                      self.memberIds,
                                      self.lastMessage,
                                      self.unreadCounter,
                                      self.avatarLink
        ],
                            forKeys: [nOBJECTID as NSCopying,
                                      nCHATROOMID as NSCopying,
                                      nSENDERID as NSCopying,
                                      nSENDERNAME as NSCopying,
                                      nRECEIVERID as NSCopying,
                                      nRECEIVERNAME as NSCopying,
                                      nDATE as NSCopying,
                                      nMEMBERIDS as NSCopying,
                                      nLASTMESSAGE as NSCopying,
                                      nUNREADCOUNTER as NSCopying,
                                      nAVATARLINK as NSCopying
                            ])
    }
    
    
    init() { }
    
    init(_ recentDocument: Dictionary<String, Any>) {
        
        objectId = recentDocument[nOBJECTID] as? String ?? ""
        chatRoomId = recentDocument[nCHATROOMID] as? String ?? ""
        senderId = recentDocument[nSENDERID] as? String ?? ""
        senderName = recentDocument[nSENDERNAME] as? String ?? ""
        receiverId = recentDocument[nRECEIVERID] as? String ?? ""
        receiverName = recentDocument[nRECEIVERNAME] as? String ?? ""
        date = (recentDocument[nDATE] as? Timestamp)?.dateValue() ?? Date()
        memberIds = recentDocument[nMEMBERIDS] as? [String] ?? [""]
        lastMessage = recentDocument[nLASTMESSAGE] as? String ?? ""
        unreadCounter = recentDocument[nUNREADCOUNTER] as? Int ?? 0
        avatarLink = recentDocument[nAVATARLINK] as? String ?? ""
        
    }
    
    //MARK: - Saving
    func saveToFireStore() {
        
        FirebaseReference(.Recent).document(self.objectId).setData(self.dictionary as! [String : Any])
    }
    
    func deleteRecent() {
        
        FirebaseReference(.Recent).document(self.objectId).delete()
    }

}

