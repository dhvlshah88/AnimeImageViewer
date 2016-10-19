//
//  ViewController.h
//  ImageViewer
//
//  Created by Dhaval on 4/13/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IVDownloadManagerDelegate.h"

@interface IVImagesController : UIViewController<IVDownloadManagerDelegate, UITableViewDelegate, UITableViewDataSource, UISplitViewControllerDelegate, UIViewControllerPreviewingDelegate>

@end

