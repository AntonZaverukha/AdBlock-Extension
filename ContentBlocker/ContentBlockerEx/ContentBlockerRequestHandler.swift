//
//  ContentBlockerRequestHandler.swift
//  ContentBlockerEx
//
//  Created by Anton on 15.04.2023.
//

import UIKit
import MobileCoreServices

class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
        let sharedContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.AntonZ.ContentBlocker")!
        let blockRulesURL = sharedContainer.appendingPathComponent("block_rules.json")

        if let contentBlockingRules = try? Data(contentsOf: blockRulesURL) {
            let itemProvider = NSItemProvider(item: contentBlockingRules as NSSecureCoding?, typeIdentifier: kUTTypeJSON as String)
            let item = NSExtensionItem()
            item.attachments = [itemProvider]
            context.completeRequest(returningItems: [item], completionHandler: nil)
        } else {
            context.completeRequest(returningItems: [], completionHandler: nil)
        }
    }
    
}
