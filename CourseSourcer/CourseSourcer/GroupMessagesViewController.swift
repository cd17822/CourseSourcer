//
//  GroupMessagesViewController.swift
//  CourseSourcer
//
//  Created by Charlie on 6/10/16.
//  Copyright © 2016 cd17822. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import SwiftyJSON
import RealmSwift

class GroupMessagesViewController: JSQMessagesViewController {
    var incomingBubble: JSQMessagesBubbleImage?
    var outgoingBubble: JSQMessagesBubbleImage?

    var messages = [JSQMessage]()
    var course: Course?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCourse()
        configureNavigationBar()
        configureSender()
        configureBubbles()
        configureJSQ()
        
        loadMessages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Personal
    
    func reloadMessagesView() {
        collectionView?.reloadData()
    }
    
    func configureCourse() {
        if let parent = tabBarController as? CourseViewController {
            course = parent.course
        }
    }
    
    func configureNavigationBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil) // DOESN'T WORK
        
        navigationItem.title = course!.name
    }
    
    func configureSender() {
        senderId = USER!.id
        senderDisplayName = USER!.name
    }
    
    func configureBubbles() {
        outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: pastelFromInt(course!.color))
        incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    func configureJSQ() {
        automaticallyScrollsToMostRecentMessage = true
        inputToolbar.contentView.leftBarButtonItem = nil // hides attachment button
        
        reloadMessagesView()
    }
    
    func loadMessages() {
        loadRealmMessages()
        reloadMessagesView()
        
        
        loadNetworkMessages() {
            self.loadRealmMessages()
            self.reloadMessagesView()
        }
    }
    
    func loadRealmMessages() {
        messages.removeAll()
        
        let realm = try! Realm()
        
        for realm_message in (course?.messages.sorted(byProperty: "created_at"))! {
            var message: JSQMessage {
                if realm_message.user_handle == handleOfEmail(USER!.email) {
                    return JSQMessage(senderId: senderId, displayName: senderDisplayName, text: realm_message.text) // add date param
                }else{
                    return JSQMessage(senderId: "Server", displayName: "Server", text: realm_message.text) // add date param
                }
            }
            
            messages.append(message)
        }
        
        finishReceivingMessage()
    }
    
    func loadNetworkMessages(_ callback: @escaping (Void) -> Void) {
        
        // &lastId=\((course?.messages.sorted("created_at").last?.id)!)
        
        GET("/group_messages/of_course/\(course!.id)/", callback: {(err: [String:AnyObject]?, res: JSON?) -> Void in
            if err != nil {
                showError(self)
            }else if res != nil {
                var network_messages = [GroupMessage]()
                
                for network_message in res!["group_messages"].arrayValue {
                    let message = GroupMessage()
                    message.id = network_message["id"].stringValue
                    message.text = network_message["text"].stringValue
                    message.score = network_message["score"].intValue
                    message.course = self.course
                    message.created_at = dateFromString(network_message["created_at"].stringValue)
                    message.user_handle = network_message["user_handle"].string
                    
                    network_messages.append(message)
                }
                
                let realm = try! Realm()
                try! realm.write {
                    for message in network_messages {
                        realm.add(message, update: true)
                    }
                }
                
                callback()
            }
        })
    }
    
    
    // MARK: - JSQ
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        
        return self.messages[indexPath.row]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didDeleteMessageAt indexPath: IndexPath!) {
        
        messages.remove(at: indexPath.row)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        switch(messages[indexPath.row].senderId) {
        case senderId:
            return outgoingBubble
        default:
            return incomingBubble
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        return nil
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        self.messages.append(message!)
        
        self.finishSendingMessage()
        
        POST("/group_messages", parameters: ["text":text,
                                             "course":course!.id],
                                callback: {(err: [String:AnyObject]?, res: JSON?) -> Void in
            if err != nil {
                showError(self, overrideAndShow: true)
            }
            
            self.loadMessages()
        })
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {}
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
