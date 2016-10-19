//
//  ImageViewer
//
//  Created by Dhaval on 4/13/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import "IVDownloadManager.h"
#import "IVImage.h"
#import "IVImageCollection.h"

@implementation IVDownloadManager

- (instancetype)initWithConfiguration:(NSURLSessionConfiguration *)configuration {
    if (self = [super init]) {
        _urlSession = [NSURLSession sessionWithConfiguration:configuration];
    }
    return self;
}

- (void)downloadFromUrlString:(NSString *)urlString {
    @throw [NSException exceptionWithName:@"UnimplementedMethodException"
                                   reason:@"downloadFromUrlString: is not implemented."
                                 userInfo:nil
            ];
}

@end
