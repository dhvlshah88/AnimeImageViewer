//
//  ImageViewer
//
//  Created by Dhaval on 4/13/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import "IVImageViewerController.h"
#import "IVImage.h"
#import "IVDownloadManager.h"
#import "IVImageDownloadManager.h"
#import <Masonry.h>
#import "SWRevealViewController.h"

@interface IVImageViewerController ()

@property (nonatomic, strong) UIImageView *originalImageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) IVImageDownloadManager *downloadManager;
@property (nonatomic, strong) NSURLSessionConfiguration *configuration;
@property (nonatomic, strong) NSArray *previewActions;

@end

@implementation IVImageViewerController

- (instancetype)init {
    if (self = [super init]) {
        _configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set navigation bar title
    self.navigationItem.title = self.image.caption ? self.image.caption : NSLocalizedString(@"Image Viewer", nil);
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
    //Set hidesBarsOnTap property to show/hide on single tap
    self.navigationController.hidesBarsOnTap = true;
    self.navigationItem.leftBarButtonItem = [self.splitViewController displayModeButtonItem];
    self.navigationItem.leftItemsSupplementBackButton = true;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
//    SWRevealViewController *revealController = [self revealViewController];
//    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
//    UIBarButtonItem *leftMenuButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Menu", nil) style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
//    leftMenuButton.tintColor = [UIColor whiteColor];
//    self.navigationItem.leftBarButtonItem = leftMenuButton;
//    
    [self downloadImage];
    
    _scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    self.scrollView.scrollEnabled = true;
    self.scrollView.clipsToBounds = false;
    self.scrollView.backgroundColor =[UIColor clearColor];
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = false;
    self.scrollView.showsHorizontalScrollIndicator = false;
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _originalImageView = [[UIImageView alloc] init];
    [self.scrollView addSubview:self.originalImageView];
    self.originalImageView.userInteractionEnabled = true;
    self.originalImageView.contentMode = UIViewContentModeCenter;
    self.originalImageView.backgroundColor = [UIColor clearColor];
    [self.originalImageView sizeToFit];
    [self.originalImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
    }];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLayoutSubviews {
    self.scrollView.contentSize = self.originalImageView.bounds.size;
}

//Show/hide status bar when navigationBar is shown/hidden
- (BOOL)prefersStatusBarHidden {
    return self.navigationController.isNavigationBarHidden;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //Set navigation bar hidden for initial load
    self.navigationController.navigationBarHidden = true;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //Set navigation bar hidden for initial load
    self.navigationController.navigationBarHidden = false;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    self.scrollView.contentSize = self.originalImageView.image.size;
    [self.view layoutIfNeeded];
}

#pragma mark IVDownloadDelegate

// This delegate method handle's displaying actual size image once the downloading of image is completed.
- (void)didFinishDownloadingImageMetadata:(IVDownloadManager *)downloadManager {
    UIImage *image = [UIImage imageWithData:self.downloadManager.imageData];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.originalImageView.image = image;
        self.originalImageView.center = self.view.center;
        self.scrollView.contentSize = self.originalImageView.image.size;
        [self checkIfImageNeedsScrolling];
    });
}

#pragma mark UIViewControllerPreviewingDelegate

- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    if (self.previewActions == nil) {
        UIPreviewAction *shareAction = [UIPreviewAction
                                        actionWithTitle:NSLocalizedString(@"Share", nil)
                                        style:UIPreviewActionStyleDefault
                                        handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
                                            // ... code to handle action here
                                        }];
        _previewActions = @[shareAction];
    }
    
    return self.previewActions;
}

#pragma mark Public Method

- (void)updateViewAppearence:(IVImage *)image {
    _image = image;
    self.originalImageView.image = nil;
    [self downloadImage];
}

#pragma mark Private methods

//This method instantiates nsurlsession and start download task to download image.
- (void)downloadImage {
    if (self.image) {
        _downloadManager = [[IVImageDownloadManager alloc] initWithConfiguration:self.configuration];
        self.downloadManager.downloadDelegate = self;
        [self.downloadManager downloadFromUrlString:self.image.originalUrl];
    }
}

//This checks if image size is smaller than scroll size, then disable scrolling.
- (void)checkIfImageNeedsScrolling {
    CGSize contentSize = self.originalImageView.image.size;
    CGSize scrollViewSize = self.scrollView.bounds.size;
    
    if (scrollViewSize.height > contentSize.height || scrollViewSize.width > contentSize.width) {
        [self.originalImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.scrollView);
        }];
        [self.view layoutIfNeeded];
    }
}

@end
