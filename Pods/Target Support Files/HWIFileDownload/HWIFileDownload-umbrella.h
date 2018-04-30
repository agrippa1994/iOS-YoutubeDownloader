#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "HWIBackgroundSessionCompletionHandlerBlock.h"
#import "HWIFileDownloadDelegate.h"
#import "HWIFileDownloader.h"
#import "HWIFileDownloadItem.h"
#import "HWIFileDownloadProgress.h"

FOUNDATION_EXPORT double HWIFileDownloadVersionNumber;
FOUNDATION_EXPORT const unsigned char HWIFileDownloadVersionString[];

