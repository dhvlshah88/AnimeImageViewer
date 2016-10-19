//
//  ImageViewer
//
//  Created by Dhaval on 4/13/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import "IVImageCollection.h"
#import "IVImage.h"

NSString * const kIVOriginalProperty = @"original";
NSString * const kIVThumbnailProperty = @"thumb";
NSString * const kIVCaptionProperty = @"caption";

@interface IVImageCollection () {
    NSMutableArray *_images;
}

@end

@implementation IVImageCollection

- (instancetype)initWithMetadataOfImages:(NSArray *)metadataOfImages {
    if (self = [super init]) {
        _images = [[NSMutableArray alloc] init];
        
        for (NSDictionary *currentMetadata in metadataOfImages) {
            IVImage *image = [[IVImage alloc]
                                initWithOriginalUrl:[self validateValueForKey:kIVOriginalProperty inMetadataDictionary:currentMetadata]
                                thumbnailUrl:[self validateValueForKey:kIVThumbnailProperty inMetadataDictionary:currentMetadata]
                                caption:[self validateValueForKey:kIVCaptionProperty inMetadataDictionary:currentMetadata]
                              ];
            [_images addObject:image];
        }
    }
    
    return self;
}

#pragma mark Private method

//This method validates json data, replaces any nsnull object with nil.
- (NSString *)validateValueForKey:(NSString *)key inMetadataDictionary:(NSDictionary *)metadataDictionary {
    if ([metadataDictionary[key] isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    return metadataDictionary[key];
}

@end
