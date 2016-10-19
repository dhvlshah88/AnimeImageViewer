//
//  ImageViewer
//
//  Created by Dhaval on 4/13/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IVDownloadManager;

@protocol IVDownloadManagerDelegate <NSObject>

- (void)didFinishDownloadingImageMetadata:(IVDownloadManager *)downloadManager;

@end
