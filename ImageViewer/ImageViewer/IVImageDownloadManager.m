//
//  IVImageDownloadManager.m
//  ImageViewer
//
//  Created by Dhaval on 4/13/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import "IVImageDownloadManager.h"

@implementation IVImageDownloadManager

// This method to download single image data using url string provided and saves response object in imageMetadata property.
- (void)downloadFromUrlString:(NSString *)urlString {
    NSURL *imageUrl = [[NSURL alloc] initWithString:urlString];
    [[self.urlSession dataTaskWithURL:imageUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            _imageData = data;
            [self.downloadDelegate didFinishDownloadingImageMetadata:self];
        } else {
            NSLog(@"Error: %@",error);
        }
    }] resume];
}

@end
