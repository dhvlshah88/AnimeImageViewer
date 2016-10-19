//
//  IVImage.h
//  ImageViewer
//
//  Created by Dhaval on 4/13/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IVImage : NSObject

@property (nonatomic, readonly, strong) NSString *originalUrl;
@property (nonatomic, readonly, strong) NSString *thumbnailUrl;
@property (nonatomic, readonly, strong) NSString *caption;

- (instancetype)initWithOriginalUrl:(NSString *)originalUrl thumbnailUrl:(NSString *)thumbnailUrl caption:(NSString *)caption;

@end
