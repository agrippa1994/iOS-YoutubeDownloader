//
//  ViewController.swift
//  youtube
//
//  Created by Manuel Leitold on 08.12.16.
//  Copyright © 2016 leitold. All rights reserved.
//

import UIKit
import MMYoutubeMP4Extractor
import Foundation
import AVFoundation
import AVKit
import HCYoutubeParser
import HWIFileDownload

class ViewController: UIViewController {
    
    var playerViewController: AVPlayerViewController?
    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: .UIApplicationDidEnterBackground, object: nil, queue: OperationQueue.main) { _ in
            self.playerViewController?.player = nil
        }
        
        
        NotificationCenter.default.addObserver(forName: .UIApplicationWillEnterForeground, object: nil, queue: OperationQueue.main) { _ in
            if self.player != nil {
                self.playerViewController?.player = self.player
            }
        }
        /*
        MMYoutubeMP4Extractor.sharedInstance()
            .mp4(fromYoutubeURL: "https://www.youtube.com/watch?v=uRlaAlVid7o") { url, error in
                print("URL: \(url), error: \(error)")
                
                HCYoutubeParser.
                OperationQueue.main.addOperation {
                    self.player = AVPlayer(url: url!)
                    self.playerViewController = AVPlayerViewController()
                    self.playerViewController?.player = self.player
                    self.show(self.playerViewController!, sender: self)
                }
        }
         */
        
        let url = NSURL(string: "https://www.youtube.com/watch?v=uRlaAlVid7o")

        HCYoutubeParser.h264videos(withYoutubeURL: url! as URL!) {
            print("Details: \($0), error: \($1)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

