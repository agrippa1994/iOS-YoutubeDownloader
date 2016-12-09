//
//  VideoListTableViewController.swift
//  YoutubeDownloader
//
//  Created by Manuel Leitold on 09.12.16.
//  Copyright © 2016 leitold. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class VideoListTableViewController: UITableViewController, AVPlayerViewControllerDelegate {

    var videos: [Video]!
    var playerViewController: AVPlayerViewController?
    var player: AVPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadVideos(reloadTable: false)
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        for video in videos {
            print("Video: \(video.path)")
        }
        
        NotificationCenter.default.addObserver(forName: .UIApplicationDidEnterBackground, object: nil, queue: OperationQueue.main) { _ in
            self.playerViewController?.player = nil
        }
        
        
        NotificationCenter.default.addObserver(forName: .UIApplicationWillEnterForeground, object: nil, queue: OperationQueue.main) { _ in
            self.loadVideos()

            if self.player != nil {
                self.playerViewController?.player = self.player
            }
        }
        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let video = videos[indexPath.row]
        cell.imageView?.image = UIImage(data: video.thumbnail as! Data)!
        cell.textLabel?.text = video.title
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let video = videos[indexPath.row]
        
        let url = URL(fileURLWithPath: video.path!, isDirectory: false)
        let asset = AVURLAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)

        playerViewController = AVPlayerViewController()
        playerViewController?.player = self.player
        playerViewController?.delegate = self

        present(self.playerViewController!, animated: true, completion: nil)
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let video = videos[indexPath.row]
            VideoRepository.shared.deleteVideo(video: video)
            loadVideos()
        }
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func loadVideos(reloadTable: Bool = true) {
        self.videos = VideoRepository.shared.fetchVideos()
        if reloadTable { tableView.reloadData() }
    }

}
