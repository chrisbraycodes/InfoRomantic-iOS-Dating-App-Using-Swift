//
//  ChatViewController.swift
//  Info-RomanticSB
//
//  Created by Christopher Bray on 12/3/22.
//

import Foundation
import MessageKit
import InputBarAccessoryView
import Firebase
import Gallery


class ChatViewController: MessagesViewController {
    
    //MARK: - Vars
    private var chatId = ""
    private var recipientId = ""
    private var recipientName = ""
    
    

    //MARK: - Inits
    init(chatId: String, recipientId: String, recipientName: String) {
        
        super.init(nibName: nil, bundle: nil)
        
        self.chatId = chatId
        self.recipientId = recipientId
        self.recipientName = recipientName
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    
}

