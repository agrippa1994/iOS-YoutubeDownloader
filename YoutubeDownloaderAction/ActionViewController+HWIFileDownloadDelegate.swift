//
//  ActionViewController+HWIFileDownloadDelegate.swift
//  YoutubeDownloader
//
//  Created by Manuel Leitold on 11.12.16.
//  Copyright © 2016 leitold. All rights reserved.
//
/////////////////////////////////////////////////////////////////////////////////////////////////

import Foundation
import HWIFileDownload

/////////////////////////////////////////////////////////////////////////////////////////////////

extension ActionViewController : HWIFileDownloadDelegate {

    /////////////////////////////////////////////////////////////////////////////////////////////////

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

    /////////////////////////////////////////////////////////////////////////////////////////////////

    public func downloadFailed(withIdentifier aDownloadIdentifier: String, error anError: Error, httpStatusCode aHttpStatusCode: Int, errorMessagesStack anErrorMessagesStack: [String]?, resumeData aResumeData: Data?) {
        self.alertAndExit(title: "Error", message: "Error while downloading: \(anErrorMessagesStack)")
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////

    public func incrementNetworkActivityIndicatorActivityCount() {}

    /////////////////////////////////////////////////////////////////////////////////////////////////

    public func decrementNetworkActivityIndicatorActivityCount() {}

    /////////////////////////////////////////////////////////////////////////////////////////////////

    public func downloadProgressChanged(forIdentifier aDownloadIdentifier: String) {
        guard let progress = downloader.downloadProgress(forIdentifier: aDownloadIdentifier) else {
            return
        }
        self.progressView.progress = progress.downloadProgress
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////

    public func localFileURL(forIdentifier aDownloadIdentifier: String, remoteURL aRemoteURL: URL) -> URL? {
        let documentPath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: kAppGroupName)
        return URL(string: aDownloadIdentifier, relativeTo: documentPath)
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////

    public func download(atLocalFileURL aLocalFileURL: URL, isValidForDownloadIdentifier aDownloadIdentifier: String) -> Bool {
        return true
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////
    
    func customizeBackgroundSessionConfiguration(_ aBackgroundSessionConfiguration: URLSessionConfiguration) {
        aBackgroundSessionConfiguration.sharedContainerIdentifier = kAppGroupName
    }
}
