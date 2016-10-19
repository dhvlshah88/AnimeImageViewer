//
//  ImageViewer
//
//  Created by Dhaval on 4/13/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//
//  Collection class to store IVImage objects 

#import <Foundation/Foundation.h>

@interface IVImageCollection : NSObject

//This property contains array of IVImage object.
@property (nonatomic, readonly, strong) NSArray *images;

- (instancetype)initWithMetadataOfImages:(NSArray *)metadataOfImages;

@end
