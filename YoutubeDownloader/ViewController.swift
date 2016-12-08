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
        
        MMYoutubeMP4Extractor.sharedInstance()
            .mp4(fromYoutubeURL: "https://www.youtube.com/watch?v=uRlaAlVid7o") { url, error in
                print("URL: \(url), error: \(error)")
                
                OperationQueue.main.addOperation {
                    self.player = AVPlayer(url: url!)
                    self.playerViewController = AVPlayerViewController()
                    self.playerViewController?.player = self.player
                    self.show(self.playerViewController!, sender: self)
                }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

