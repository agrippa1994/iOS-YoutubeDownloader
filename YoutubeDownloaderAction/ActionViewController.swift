//
//  ActionViewController.swift
//  YoutubeDownloaderAction
//
//  Created by Manuel Leitold on 09.12.16.
//  Copyright © 2016 leitold. All rights reserved.
//
/////////////////////////////////////////////////////////////////////////////////////////////////

import UIKit
import MobileCoreServices
import HWIFileDownload

/////////////////////////////////////////////////////////////////////////////////////////////////

let kAppId = "group.software.leitold.YoutubeDownloader"

/////////////////////////////////////////////////////////////////////////////////////////////////

class ActionViewController: UIViewController {

    /////////////////////////////////////////////////////////////////////////////////////////////////

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var downloadButton: UIBarButtonItem!

    var videoInformation: YoutubeVideoInformationProtocol? {
        didSet {
            print("New videoInformation: \(videoInformation)")
            if let info = videoInformation {
                self.imageView.image = info.thumbnail
                self.navigationItem.prompt = info.title
                self.downloadButton.isEnabled = true
            } else {
                self.imageView.image = nil
                self.navigationItem.prompt = ""
                self.downloadButton.isEnabled = false
            }
        }
    }
    
    var downloader: HWIFileDownloader!
    var downloadIdentifier = ""

    var isDownloadActive: Bool {
        return downloader.hasActiveDownloads()
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // delete any previously downloaded file fragments from the temporary directory
        do {
            try TmpCleaner.cleanTemporaryPath()
            NSLog("Cleared temporary dir")
        } catch {
            NSLog("Cleaning temporary dir failed: \(error)")
        }

        // set explicitly the video information to nil
        // Buttons and other UI elements are greyed out
        self.videoInformation = nil
        
        // Initialize downloader and set its delegate
        self.downloader = HWIFileDownloader(delegate: self)
        

        // extract input from the host application and retrieve Youtube video information
        let extractor = ExtensionExtractor(items: self.extensionContext?.inputItems as! [NSExtensionItem])
        extractor.extract { [weak self] url, error in
            if error != nil {
                switch error! {
                case .InvalidArguments: self?.alertAndExit(title: "Error", message: "Only one URL is supported")
                case .InvalidUrl:       self?.alertAndExit(title: "Error", message: "No valid URL")
                }
            } else {
                YoutubeAPI.retrieveVideoInformation(url: url!) { [weak self]  info, error in
                    OperationQueue.main.addOperation { [weak self] in
                        if info == nil {
                            self?.alertAndExit(title: "Error", message: "Couldn't fetch any video information")
                            return
                        }
                        self?.videoInformation = info
                    }
                }
            }
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // invalidate background URL threads
        self.downloader.invalidate()
        self.downloader = nil
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////

    func close() {
        // cancel pending download
        if isDownloadActive {
            self.downloader.cancelDownload(withIdentifier: downloadIdentifier)
            downloadIdentifier = ""
        }

        // delete video information
        videoInformation = nil
        
        // return to the host application
        let ctx = self.extensionContext!
        ctx.completeRequest(returningItems: ctx.inputItems, completionHandler: nil)
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////
    // shows an alert window and closes the Action Extension whenever the user clicks "OK"
    func alertAndExit(title: String, message: String) {
        let sheet = UIAlertController(title: title, message: message, preferredStyle: .alert)
        sheet.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in self?.close() })
        self.present(sheet, animated: true, completion: nil)
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////

    @IBAction func cancel(_ sender: Any) {
        if !downloader.hasActiveDownloads() {
            return close()
        }
        
        let sheet = UIAlertController(title: "Warning", message: "Download is still active! Do you want to cancel this download?", preferredStyle: .alert)
        sheet.addAction(UIAlertAction(title: "Yes", style: .destructive) { [weak self] _ in self?.close() })
        sheet.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        self.present(sheet, animated: true, completion: nil)
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////

    @IBAction func download(_ sender: Any) {
        guard let info = self.videoInformation else {
            return self.alertAndExit(title: "Error", message: "No video information")
        }
        
        if isDownloadActive {
            return self.alertAndExit(title: "Error", message: "Download is still in progress")
        }
        
        downloadIdentifier = UUID().uuidString + ".mp4"
        self.downloader.startDownload(withIdentifier: downloadIdentifier, fromRemoteURL: info.url)
        self.downloadButton.isEnabled = false
    }
}
