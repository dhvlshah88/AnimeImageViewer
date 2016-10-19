//
//  ImageViewer
//
//  Created by Dhaval on 4/13/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import "IVImageTableViewCell.h"
#import "Masonry.h"

CGFloat const kIVImageViewHeight = 100.0;
CGFloat const kIVImageTableViewCellPadding = 10.0;

@implementation IVImageTableViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        
        _thumbnailImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.thumbnailImageView];
        [self.thumbnailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(kIVImageTableViewCellPadding);
            make.width.equalTo(@(kIVImageViewHeight));
            make.top.equalTo(self.contentView).with.offset(kIVImageTableViewCellPadding);
            make.bottom.equalTo(self.contentView).with.offset(-kIVImageTableViewCellPadding);
        }];
        self.thumbnailImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.thumbnailImageView.clipsToBounds = true;
        
        _caption = [[UILabel alloc] init];
        [self.contentView addSubview:self.caption];
        self.caption.font = [UIFont systemFontOfSize:15];
        self.caption.textColor = [UIColor blackColor];
        self.caption.numberOfLines = 0;
        self.caption.textAlignment = NSTextAlignmentLeft;
        self.caption.preferredMaxLayoutWidth = self.frame.size.width - kIVImageViewHeight - (2 * kIVImageTableViewCellPadding);
        
        [self.caption mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(kIVImageTableViewCellPadding);
            make.leading.equalTo(self.thumbnailImageView.mas_trailing).with.offset(kIVImageTableViewCellPadding);
            make.trailing.equalTo(self.contentView).with.offset(-kIVImageTableViewCellPadding);
            make.bottom.equalTo(self.contentView).with.offset(-kIVImageTableViewCellPadding);
        }];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end
