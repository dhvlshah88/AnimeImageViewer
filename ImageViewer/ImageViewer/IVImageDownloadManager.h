//
//  IVImageDownloadManager.h
//  ImageViewer
//
//  Created by Dhaval on 4/13/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import "IVDownloadManager.h"

@interface IVImageDownloadManager : IVDownloadManager

@property (nonatomic, strong, readonly) NSData *imageData;

@end
