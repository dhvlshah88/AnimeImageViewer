//
//  ImageViewer
//
//  Created by Dhaval on 4/13/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IVImageTableViewCell : UITableViewCell

@property (nonatomic, readonly, strong) UIImageView *thumbnailImageView;
@property (nonatomic, readonly, strong) UILabel *caption;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
