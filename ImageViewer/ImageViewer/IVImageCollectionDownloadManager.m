//
//  IVImageCollectionDownloadManager.m
//  ImageViewer
//
//  Created by Dhaval on 4/13/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import "IVImageCollectionDownloadManager.h"
#import "IVImageCollection.h"


@implementation IVImageCollectionDownloadManager

// This method to download json data using url string provided, convert json object to dictionary and saves it to imageMetadataCollection property
- (void)downloadFromUrlString:(NSString *)urlString {
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    __block NSArray *jsonObj = nil;
    NSURLSessionDataTask *dataTask = [self.urlSession dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
            if (httpResp.statusCode == 200) {
                NSError *jsonError;
                jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                if (!jsonError) {
                    IVImageCollection *imageCollection = [[IVImageCollection alloc] initWithMetadataOfImages:jsonObj];
                    _imagesMetadataCollection = imageCollection.images;
                    [self.downloadDelegate didFinishDownloadingImageMetadata:self];
                } else {
                    NSLog(@"Error: %@", error);
                }
            }
        }
    }];
    
    [dataTask resume];
}




@end
