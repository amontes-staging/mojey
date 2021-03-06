//
//  MessagesViewController.swift
//  MojeyMessage
//
//  Created by Todd Bowden on 8/9/19.
//  Copyright © 2020 Mojey. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController, MainViewControllerDelegate, TranscriptViewControllerDelegate {
  
    let keychain = Keychain(accessGroup: Constants.accessGroup)
    var transcriptViewController: TranscriptViewController?
    var mainViewController: MainViewController?

    //var message: MSMessage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0.2, alpha: 1)
        CloudId.shared.listenForCloudIdChanges()


    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.

        // Use this method to configure the extension and restore previously stored state.
        print(conversation.selectedMessage?.url ?? "")
        print(presentationStyle.rawValue)
        DeviceKey.createDeviceKeyIfNone { (deviceKey, error) in

        }
        self.addMainOrTranscriptViewController(conversation: conversation)
    }

    private func addMainOrTranscriptViewController(conversation: MSConversation) {
        if presentationStyle == .transcript {
            print("TR -- conversation \(conversation)")
            //print("ACTIVE CONVERSATIOM \(self.activeConversation)")
            //guard let message = conversation.selectedMessage else { return }
            guard let transcriptViewController = try? TranscriptViewController(conversation: conversation) else { return }
            self.transcriptViewController = transcriptViewController
            //transcriptViewController.delegate = self
            self.addChild(transcriptViewController)
            self.view.addSubview(transcriptViewController.view)
        } else {
            print("ADD Main VC")
            let mainViewController = MainViewController(conversation: conversation)
            self.mainViewController = mainViewController
            mainViewController.delegate = self
            self.addChild(mainViewController)
            self.view.addSubview(mainViewController.view)
        }
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
    
        // Use this method to prepare for the change in presentation style.
        mainViewController?.willTransition(to: presentationStyle)
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
    
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }




    // MARK: MainVC delegate

    func mainViewControllerGetActiveConversation() -> MSConversation? {
        return self.activeConversation
    }

    func mainViewControllerGetPresentationStyle() -> MSMessagesAppPresentationStyle {
        return self.presentationStyle
    }

    func mainViewControllerRequestPresentationStyle(style: MSMessagesAppPresentationStyle) {
        print("!!!!mainViewControllerRequestPresentationStyle \(style.rawValue)")
        self.requestPresentationStyle(style)
    }


    func transcriptViewControllerGetActiveConversation() -> MSConversation? {
        return self.activeConversation
    }


    override func contentSizeThatFits(_ size: CGSize) -> CGSize {
        print("CSTF max = \(size)")
        return transcriptViewController?.contentSizeThatFits(size) ?? CGSize.zero
    }

}
