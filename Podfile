platform :ios, '11.0'
use_frameworks!

def all_pods
    pod 'MMYoutubeMP4Extractor'
    pod 'HCYoutubeParser', :git => 'https://github.com/smudgeio/HCYoutubeParser.git', :branch => 'master'
    pod 'HWIFileDownload', :git => 'https://github.com/agrippa1994/HWIFileDownload.git', :branch => 'delete'
end

target "YoutubeDownloader" do
    all_pods
end

target "YoutubeDownloaderAction" do
	all_pods
end

target "YoutubeDownloaderTests" do
    all_pods
end

