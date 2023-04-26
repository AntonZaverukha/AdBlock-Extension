//
//  ContentBlockerManager.swift
//  Blocker
//
//  Created by Anton on 13.04.2023.
//

import Foundation
import SafariServices

class ContentBlockerManager {
    static let shared = ContentBlockerManager()

    private init() {}
    
    func isExtensionEnabled(completion: @escaping (Bool) -> Void) {
        SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: "AntonZ.Blocker.SafariBlocker") { state, error in
            completion(state?.isEnabled ?? false)
        }
    }
    
    func updateBlockerList(blockInstagram: Bool, completion: @escaping (Error?) -> Void) {
        let fileURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.AntonZ.Blocker")!.appendingPathComponent("blockerList.json")
        
        let rules: [String: Any] = [
            "action": [
                "type": "block"
            ],
            "trigger": [
                "url-filter": "https://www.instagram.com/*"
            ]
        ]
        
        let jsonArray: [Any] = blockInstagram ? [rules] : []
        
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonArray, options: [])
            try data.write(to: fileURL)
            completion(nil)
        } catch {
            completion(error)
        }
    }

    func enableInstagramBlocker(completion: ((Error?) -> Void)? = nil) {
        updateBlockerList(blockInstagram: true) { error in
            guard error == nil else {
                completion?(error)
                return
            }
            
            SFContentBlockerManager.reloadContentBlocker(withIdentifier: "AntonZ.Blocker.SafariBlocker", completionHandler: completion)
        }
    }

    func disableInstagramBlocker(completion: ((Error?) -> Void)? = nil) {
        updateBlockerList(blockInstagram: false) { error in
            guard error == nil else {
                completion?(error)
                return
            }
            
            SFContentBlockerManager.reloadContentBlocker(withIdentifier: "AntonZ.Blocker.SafariBlocker", completionHandler: completion)
        }
    }
}
