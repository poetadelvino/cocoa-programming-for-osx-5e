//
//  ChatWindowController.swift
//  Chatter
//
//  Created by Juan Pablo Claude on 2/23/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa

private let ChatWindowControllerDidSendMessageNotification = "com.bignerdranch.chatter.ChatWindowControllerDidSendMessageNotification"
private let ChatWindowControllerMessageKey = "com.bignerdranch.chatter.ChatWindowControllerMessageKey"


class ChatWindowController: NSWindowController {
    
    dynamic var log: NSAttributedString = NSAttributedString(string: "")
    dynamic var message: String?
    
    // NSTextView does not support weak references.
    @IBOutlet var textView: NSTextView!
    
    
    override var windowNibName: String {
        return "ChatWindowController"
    }
    

    override func windowDidLoad() {
        super.windowDidLoad()

        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self,
                                       selector: Selector("receiveDidSendMessageNotification:"),
                                       name: ChatWindowControllerDidSendMessageNotification,
                                       object: nil)
    }
    
    
    deinit {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self)
    }
    
    
    // MARK: - Actions
    @IBAction func send(sender: AnyObject) {
        sender.window?.endEditingFor(nil)
        if let message = message {
            let userInfo = [ChatWindowControllerMessageKey : message]
            let notificationCenter = NSNotificationCenter.defaultCenter()
            notificationCenter.postNotificationName(ChatWindowControllerDidSendMessageNotification,
                                                    object: self,
                                                  userInfo: userInfo)
        }
        message = ""
    }
    
    
    // MARK: - Notifications
    // ChatWindowControllerDidSendMessageNotification
    func receiveDidSendMessageNotification(note: NSNotification) {
        let mutableLog = log.mutableCopy() as! NSMutableAttributedString
                                        
        if log.length > 0 {
            mutableLog.appendAttributedString(NSAttributedString(string: "\n"))
        }
        
        let userInfo = note.userInfo! as! [String : String]
        let message = userInfo[ChatWindowControllerMessageKey]!
                                        
        let logLine = NSAttributedString(string: message)
        mutableLog.appendAttributedString(logLine)
        
        log = mutableLog.copy() as! NSAttributedString
        
        textView.scrollRangeToVisible(NSRange(location: log.length, length: 0))
    }
    
}
