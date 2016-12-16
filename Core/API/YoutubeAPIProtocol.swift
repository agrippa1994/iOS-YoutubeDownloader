//
//  YoutubeAPIProtocol.swift
//  YoutubeDownloader
//
//  Created by Manuel Leitold on 16.12.16.
//  Copyright © 2016 leitold. All rights reserved.
//
/////////////////////////////////////////////////////////////////////////////////////////////////

import Foundation

/////////////////////////////////////////////////////////////////////////////////////////////////

protocol YoutubeAPIProtocol {
    static func retrieveVideoInformation(url: URL, completion: @escaping (YoutubeVideoInformationProtocol?, Error?) -> Void)
}
