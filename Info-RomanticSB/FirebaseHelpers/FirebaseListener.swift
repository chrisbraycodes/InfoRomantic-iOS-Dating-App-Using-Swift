//
//  FirebaseListener.swift
//  Info-RomanticSB
//
//  Created by Christopher Bray on 11/25/22.
//

import Foundation
import Firebase


class FirebaseListener {
    
    static let shared = FirebaseListener()
    
    private init() {}
    
    //MARK: - FUser
    func downloadCurrentUserFromFirebase(userId: String, email: String) {
        
        FirebaseReference(.User).document(userId).getDocument { (snapshot, error) in
            
            guard let snapshot = snapshot else { return }
            
            if snapshot.exists {
                
                let user = FUser(_dictionary: snapshot.data() as! NSDictionary)
                user.saveUserLocally()
                
                user.getUserAvatarFromFirestore { (didSet) in
                    
                }
                
            } else {
                //first login
                
                if let user = userDefaults.object(forKey: nCURRENTUSER) {
                    FUser(_dictionary: user as! NSDictionary).saveUserToFireStore()
                }
            }
        }
    }
    
    func downloadUsersFromFirebase(isInitialLoad: Bool, limit: Int, lastDocumentSnapshot: DocumentSnapshot?, completion: @escaping (_ users: [FUser], _ snapshot: DocumentSnapshot?) ->Void) {
        
        var query: Query!
        var users: [FUser] = []
        
        if isInitialLoad {
            query = FirebaseReference(.User).order(by: nREGISTEREDDATE, descending: true).limit(to: limit)
            print("first \(limit) users loading")
            
        } else {
            
            if lastDocumentSnapshot != nil {
                query = FirebaseReference(.User).order(by: nREGISTEREDDATE, descending: true).limit(to: limit).start(afterDocument: lastDocumentSnapshot!)
                
                print("next \(limit) user loading")

            } else {
                print("last snapshot is nil")
            }
        }
        
        if query != nil {
            
            query.getDocuments { (snapShot, error) in
                
                guard let snapshot = snapShot else { return }
                
                if !snapshot.isEmpty {
                    
                    for userData in snapshot.documents {
                        
                        let userObject = userData.data() as NSDictionary
                        
                        
                        if !(FUser.currentUser()?.likedIdArray?.contains(userObject[nOBJECTID] as! String) ?? false) && FUser.currentId() != userObject[nOBJECTID] as! String {
                            
                            users.append(FUser(_dictionary: userObject))
                        }
                    }
                    
                    completion(users, snapshot.documents.last!)
                    
                } else {
                    print("no more users to fetch")
                    completion(users, nil)
                }
                
            }
            
        } else {
            completion(users, nil)
        }
    }
    
    
    func downloadUsersFromFirebase(withIds: [String], completion: @escaping (_ users: [FUser]) -> Void) {
        
        var usersArray: [FUser] = []
        var counter = 0
        
        for userId in withIds {
            
            FirebaseReference(.User).document(userId).getDocument { (snapshot, error) in
                
                guard let snapshot = snapshot else { return }
                
                if snapshot.exists {
                    
                    usersArray.append(FUser(_dictionary: snapshot.data()! as NSDictionary))
                    counter += 1
                    
                    if counter == withIds.count {
                        
                        completion(usersArray)
                    }
                    
                } else {
                    completion(usersArray)
                }
            }
        }
    }
    
    
    //MARK: - Likes
    func downloadUserLikes(completion: @escaping (_ likedUserIds: [String]) -> Void) {
        
        FirebaseReference(.Like).whereField(nLIKEDUSERID, isEqualTo: FUser.currentId()).getDocuments { (snapshot, error) in
            
            var allLikedIds: [String] = []
            
            guard let snapshot = snapshot else {
                completion(allLikedIds)
                return
            }
            
            if !snapshot.isEmpty {
                
                for likeDictionary in snapshot.documents {
                    
                    allLikedIds.append(likeDictionary[nUSERID] as? String ?? "")
                }
                
                completion(allLikedIds)
            } else {
                print("No likes found")
                completion(allLikedIds)
            }
        }
    }

    
    
    func checkIfUserLikedUs(userId: String, completion: @escaping (_ didLike: Bool) -> Void) {
        
        FirebaseReference(.Like).whereField(nLIKEDUSERID, isEqualTo: FUser.currentId()).whereField(nUSERID, isEqualTo: userId).getDocuments { (snapshot, error) in
            
            guard let snapshot = snapshot else { return }
            
            completion(!snapshot.isEmpty)
        }
    }
    
    
    //MARK: - Match
    func downloadUserMatches(completion: @escaping (_ matchedUserIds: [String]) -> Void) {
        
        let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        
        FirebaseReference(.Match).whereField(nMEMBERIDS, arrayContains: FUser.currentId()).whereField(nDATE, isGreaterThan: lastMonth).order(by: nDATE, descending: true).getDocuments { (snapshot, error) in
            
            var allMatchedIds: [String] = []
            
            guard let snapshot = snapshot else { return }
            
            if !snapshot.isEmpty {
                
                for matchDictionary in snapshot.documents {
                    
                    allMatchedIds += matchDictionary[nMEMBERIDS] as? [String] ?? [""]
                }
                
                completion(removeCurrentUserIdFrom(userIds: allMatchedIds))
                
            } else {
                print("No Matches found")
                completion(allMatchedIds)
            }
        }
    }
    
    
    func saveMatch(userId: String) {
        
        let match = MatchObject(id: UUID().uuidString, memberIds: [FUser.currentId(), userId], date: Date())
        match.saveToFireStore()
    }
    
    
    //MARK: - RecentChats
    func downloadRecentChatsFromFireStore(completion: @escaping (_ allRecents: [RecentChat]) -> Void) {
        
        FirebaseReference(.Recent).whereField(nSENDERID, isEqualTo: FUser.currentId()).addSnapshotListener { (querySnapshot, error) in
            
            var recentChats: [RecentChat] = []
            
            guard let snapshot = querySnapshot else { return }
            
            if !snapshot.isEmpty {
                
                for recentDocument in snapshot.documents {
                    
                    if recentDocument[nLASTMESSAGE] as! String != "" && recentDocument[nCHATROOMID] != nil && recentDocument[nOBJECTID] != nil {
                        
                        recentChats.append(RecentChat(recentDocument.data()))
                    }
                }
                
                recentChats.sort(by: { $0.date > $1.date })
                completion(recentChats)
                
            } else {
                completion(recentChats)
            }
        }
    }


    
}
