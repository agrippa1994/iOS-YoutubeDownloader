//
//  VideoRepositoryTests.swift
//  YoutubeDownloader
//
//  Created by Manuel Leitold on 16.12.16.
//  Copyright © 2016 leitold. All rights reserved.
//

import XCTest
import CoreData
@testable import YoutubeDownloader

class VideoRepositoryTests: XCTestCase {

    var persistence: Persistence!
    var repository: VideoRepository!

    override func setUp() {
        super.setUp()
        persistence = Persistence.shared
        repository = VideoRepository.shared
    }

    override func tearDown() {
        super.tearDown()

        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Video")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        XCTAssert((try? persistence.container.viewContext.execute(request)) != nil)
    }
    
    func testIfEmpty() {
        XCTAssert(repository.fetchVideos().isEmpty)
    }

    func testAddVideoWithInvalidLocalPath() {
        let info = YoutubeVideoInformation(url: URL(string: "https://google.at")!, thumbnail: nil, title: "My video")

        do {
            let _ = try repository.addVideo(information: info, localPath: URL(string: "https://google.at")!)
            XCTFail("No exception occured")
        }
        catch let e as VideoValidationError {
            XCTAssertEqual(e, VideoValidationError.InvalidFilePath)
        }
        catch {
            XCTFail("Invalid error")
        }
    }
    
}
