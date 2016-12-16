//
//  ExtensionExtractor.swift
//  YoutubeDownloader
//
//  Created by Manuel Leitold on 11.12.16.
//  Copyright © 2016 leitold. All rights reserved.
//
/////////////////////////////////////////////////////////////////////////////////////////////////

import Foundation
import MobileCoreServices

/////////////////////////////////////////////////////////////////////////////////////////////////

enum ExtensionExtractorError: Error
{
    case InvalidArguments
    case InvalidUrl
}

/////////////////////////////////////////////////////////////////////////////////////////////////

class ExtensionExtractor {

    /////////////////////////////////////////////////////////////////////////////////////////////////

    private let items: [NSExtensionItem]

    /////////////////////////////////////////////////////////////////////////////////////////////////

    init(items: [NSExtensionItem]) {
        self.items = items
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////
    
    func extract(completion: @escaping (URL?, ExtensionExtractorError?) -> Void) {
        if items.count != 1 {
            return completion(nil, .InvalidArguments)
        }
        
        for item in items {
            for provider in item.attachments! as! [NSItemProvider] {
                if provider.hasItemConformingToTypeIdentifier(kUTTypeText as String) {
                    provider.loadItem(forTypeIdentifier: kUTTypeText as String, options: nil) { data, error in
                        guard let url = URL(string: data as! String) else {
                            return completion(nil, .InvalidUrl)
                        }
                        return completion(url, nil)
                    }
                }
            }
        }
    }
}
