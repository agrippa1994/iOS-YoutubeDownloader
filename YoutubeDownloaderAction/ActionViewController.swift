//
//  ActionViewController.swift
//  YoutubeDownloaderAction
//
//  Created by Manuel Leitold on 09.12.16.
//  Copyright © 2016 leitold. All rights reserved.
//

import UIKit
import MobileCoreServices
import HWIFileDownload

let kAppId = "group.software.leitold.YoutubeDownloader"

class ActionViewController: UIViewController, HWIFileDownloadDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var downloadButton: UIBarButtonItem!

    private var videoInformation: YoutubeVideoInformation? {
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
    
    private var downloader: HWIFileDownloader!
    private var downloadIdentifier = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.videoInformation = nil
        self.downloader = HWIFileDownloader(delegate: self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.extensionContext!.inputItems.count != 1 {
            return alertAndExit(title: "Error", message: "Only one URL is supported")
        }

        for item in self.extensionContext!.inputItems as! [NSExtensionItem] {
            for provider in item.attachments! as! [NSItemProvider] {
                if provider.hasItemConformingToTypeIdentifier(kUTTypeText as String) {
                    provider.loadItem(forTypeIdentifier: kUTTypeText as String, options: nil) { data, error in
                        guard let url = URL(string: data as! String) else {
                            return self.alertAndExit(title: "Error", message: "No valid URL")
                        }

                        YoutubeAPI.retrieveVideoInformation(url: url) { info, error in
                            OperationQueue.main.addOperation {
                                self.videoInformation = info
                            }
                        }
                    }
                }
            }
        }
    }

    private func close() {
        if !downloadIdentifier.isEmpty {
            self.downloader.cancelDownload(withIdentifier: downloadIdentifier)
            downloadIdentifier = ""
        }
        videoInformation = nil
        let ctx = self.extensionContext!
        ctx.completeRequest(returningItems: ctx.inputItems, completionHandler: nil)
    }
    
    private func alertAndExit(title: String, message: String) {
        let sheet = UIAlertController(title: title, message: message, preferredStyle: .alert)
        sheet.addAction(UIAlertAction(title: "OK", style: .default) { _ in self.close() })
        self.present(sheet, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        close()
    }
    
    @IBAction func download(_ sender: Any) {
        guard let info = self.videoInformation else {
            return self.alertAndExit(title: "Error", message: "No video information")
        }
        
        if !downloadIdentifier.isEmpty {
            return self.alertAndExit(title: "Error", message: "Download is still in progress")
        }
        
        downloadIdentifier = UUID().uuidString + ".mp4"
        self.downloader.startDownload(withIdentifier: downloadIdentifier, fromRemoteURL: info.url)
    }
    
    // mark: Info
    public func downloadDidComplete(withIdentifier aDownloadIdentifier: String, localFileURL aLocalFileURL: URL) {
        if self.videoInformation != nil {
            do {
                let video = try VideoRepository.shared.addVideo(information: self.videoInformation!, localPath: aLocalFileURL)
                Persistence.shared.container.viewContext.insert(video)
                try Persistence.shared.save()
            } catch {
                return alertAndExit(title: "Error", message: "Video couldn't be stored, error \(error)")
            }
        } else {
            return alertAndExit(title: "Error", message: "Video information is invalid")
        }
        close()
    }
    
    public func downloadFailed(withIdentifier aDownloadIdentifier: String, error anError: Error, httpStatusCode aHttpStatusCode: Int, errorMessagesStack anErrorMessagesStack: [String]?, resumeData aResumeData: Data?) {
        self.alertAndExit(title: "Error", message: "Error while downloading: \(anErrorMessagesStack)")
    }
    
    public func incrementNetworkActivityIndicatorActivityCount() {}
    public func decrementNetworkActivityIndicatorActivityCount() {}
    
    public func downloadProgressChanged(forIdentifier aDownloadIdentifier: String) {
        guard let progress = downloader.downloadProgress(forIdentifier: aDownloadIdentifier) else {
            return
        }
        self.progressView.progress = progress.downloadProgress
    }

    public func localFileURL(forIdentifier aDownloadIdentifier: String, remoteURL aRemoteURL: URL) -> URL? {
        let documentPath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: kAppGroupName)
        return URL(string: aDownloadIdentifier, relativeTo: documentPath)
    }
    
    public func download(atLocalFileURL aLocalFileURL: URL, isValidForDownloadIdentifier aDownloadIdentifier: String) -> Bool {
        return true
    }
    
    func customizeBackgroundSessionConfiguration(_ aBackgroundSessionConfiguration: URLSessionConfiguration) {
        aBackgroundSessionConfiguration.sharedContainerIdentifier = kAppGroupName
    }
    
}
