//
//  DownloadViewController.swift
//  YoutubeDownloader
//
//  Created by Manuel Leitold on 09.12.16.
//  Copyright © 2016 leitold. All rights reserved.
//

import UIKit
import UICircularProgressRing
import HWIFileDownload
import HCYoutubeParser

@objc protocol DownloadViewControllerDelegate {
    func downloadFailed(error: Error)
    func youtubeInformationFailed(error: Error)
    func chooseResolution(resolutions: [String]) -> String

    func didDownloadVideo(location: URL, videoTitle: String)
}

class DownloadViewController: UIViewController, HWIFileDownloadDelegate {

    var url = URL(string: "https://www.youtube.com/watch?v=XSGCzq0Haw4")!
    weak var delegate: DownloadViewControllerDelegate?
    private var downloader: HWIFileDownloader!

    @IBOutlet weak var progressRing: UICircularProgressRingView!

    override func viewDidLoad() {
        super.viewDidLoad()

        downloader = HWIFileDownloader(delegate: self)
        YoutubeAPI.retrieveVideoInformation(url: url) { information, error in
            OperationQueue.main.addOperation {
                if error != nil {
                    self.delegate?.youtubeInformationFailed(error: error!)
                    return
                }

                self.downloader.startDownload(withIdentifier: information!.title, fromRemoteURL: information!.url)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public func downloadDidComplete(withIdentifier aDownloadIdentifier: String, localFileURL aLocalFileURL: URL) {
        print("downloadDidcomplete")
    }
    
    public func downloadFailed(withIdentifier aDownloadIdentifier: String, error anError: Error, httpStatusCode aHttpStatusCode: Int, errorMessagesStack anErrorMessagesStack: [String]?, resumeData aResumeData: Data?) {
        
    }
    
    public func incrementNetworkActivityIndicatorActivityCount() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    public func decrementNetworkActivityIndicatorActivityCount() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    public func downloadProgressChanged(forIdentifier aDownloadIdentifier: String) {
        guard let progress = downloader.downloadProgress(forIdentifier: aDownloadIdentifier) else {
            return
        }
        print("PROGRESS: \(progress)")
            self.progressRing.value = CGFloat(progress.downloadProgress) * 100
            //self.progressRing.setProgress(value: CGFloat(progress.downloadProgress) * 100, animationDuration: 0.1)
        
    }
    
    
    public func downloadPaused(withIdentifier aDownloadIdentifier: String, resumeData aResumeData: Data?) {
        
    }
    
    public func resumeDownload(withIdentifier aDownloadIdentifier: String) {
        
    }
    
    public func localFileURL(forIdentifier aDownloadIdentifier: String, remoteURL aRemoteURL: URL) -> URL? {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return URL(string: UUID().uuidString, relativeTo: documentPath)
    }
    
    public func download(atLocalFileURL aLocalFileURL: URL, isValidForDownloadIdentifier aDownloadIdentifier: String) -> Bool {
        print("download \(aLocalFileURL)")
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
