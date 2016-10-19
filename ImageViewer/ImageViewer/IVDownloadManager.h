//
//  ImageViewer
//
//  Created by Dhaval on 4/13/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IVDownloadManagerDelegate.h"

@interface IVDownloadManager : NSObject

@property (nonatomic, strong, readonly) NSURLSession *urlSession;
@property (nonatomic, weak) id<IVDownloadManagerDelegate> downloadDelegate;

- (instancetype)initWithConfiguration:(NSURLSessionConfiguration *)configuration;

- (void)downloadFromUrlString:(NSString *)urlString;

@end
