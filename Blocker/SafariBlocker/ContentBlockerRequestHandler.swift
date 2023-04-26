//
//  ContentBlockerRequestHandler.swift
//  SafariBlocker
//
//  Created by Anton on 13.04.2023.
//

import SafariServices

class RequestHandler: NSObject, NSExtensionRequestHandling {
    func beginRequest(with context: NSExtensionContext) {
        let fileURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.AntonZ.Blocker")!.appendingPathComponent("blockerList.json")
        
        let attachment = NSItemProvider(contentsOf: fileURL)!
        let item = NSExtensionItem()
        item.attachments = [attachment]
        
        context.completeRequest(returningItems: [item], completionHandler: nil)
    }
}
