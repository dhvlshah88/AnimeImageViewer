//
//  ImageViewer
//
//  Created by Dhaval on 4/13/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IVDownloadManagerDelegate.h"

@class IVImage;

@interface IVImageViewerController : UIViewController <IVDownloadManagerDelegate, UIScrollViewDelegate>

@property (nonatomic, readonly, strong) IVImage *image;

- (void)updateViewAppearence:(IVImage *)image;

@end
