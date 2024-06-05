//
//  RecentViewController.swift
//  Info-RomanticSB
//
//  Created by Christopher Bray on 12/3/22.
//

import UIKit

class RecentViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //MARK: - Vars
    var recentMatches:[FUser] = []
    var recentChats: [RecentChat] = []
    
    //MARK: - ViewLifeCycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        downloadMatches()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        downloadRecents()
    }
    
    
    
    //MARK: - Download
    private func downloadMatches() {
        
        FirebaseListener.shared.downloadUserMatches { (matchedUserIds) in
            
            if matchedUserIds.count > 0 {
                
                FirebaseListener.shared.downloadUsersFromFirebase(withIds: matchedUserIds) { (allUsers) in
                    
                    self.recentMatches = allUsers
                    
                    DispatchQueue.main.async {
                        //nide notification spinner
                        self.collectionView.reloadData()
                    }
                }
                
                
            } else {
                print("No matches")
                //note show activity indicator result
            }
        }
    }

    
    private func downloadRecents() {

        FirebaseListener.shared.downloadRecentChatsFromFireStore { (allChats) in

            self.recentChats = allChats
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    
    //MARK: - Navigation
    private func showUserProfileFor(user: FUser) {
        
        let profileView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ProfileTableView") as! UserProfileTableViewController
        
        profileView.userObject = user
        profileView.isMatchedUser = true
        self.navigationController?.pushViewController(profileView, animated: true)
    }

    private func goToChat(recent: RecentChat) {
        
        restartChat(chatRoomId: recent.chatRoomId, memberIds: recent.memberIds)
        
        let chatView = ChatViewController(chatId: recent.chatRoomId, recipientId: recent.receiverId, recipientName: recent.receiverName)
        
        chatView.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(chatView, animated: true)
    }
    
}



extension RecentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return recentChats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RecentTableViewCell
        
        cell.generateCell(recentChat: recentChats[indexPath.row])
        
        return cell
    }
 
}

extension RecentViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        goToChat(recent: recentChats[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        

        if editingStyle == .delete {
            
            let recent = self.recentChats[indexPath.row]
            recent.deleteRecent()
            
            self.recentChats.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}


extension RecentViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentMatches.count > 0 ? recentMatches.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! NewMatchCollectionViewCell
        
        if recentMatches.count > 0 {
            cell.setupCell(avatarLink: recentMatches[indexPath.row].avatarLink)
        }
        
        return cell
    }
    
}

extension RecentViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if recentMatches.count > 0 {
            showUserProfileFor(user: recentMatches[indexPath.row])
        }
        
    }
    
}
