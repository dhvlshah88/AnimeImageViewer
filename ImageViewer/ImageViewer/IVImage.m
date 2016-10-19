//
//  IVImage.m
//  ImageViewer
//
//  Created by Dhaval on 4/13/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import "IVImage.h"

@implementation IVImage

- (instancetype)initWithOriginalUrl:(NSString *)originalUrl thumbnailUrl:(NSString *)thumbnailUrl caption:(NSString *)caption {
    if (self = [super init]) {
        _originalUrl = originalUrl;
        _thumbnailUrl = thumbnailUrl;
        _caption = caption;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Original Url: %@\n Thumbnail Url: %@\n Caption: %@\n", self.originalUrl, self.thumbnailUrl, self.caption];
}

@end
