//
//  ViewController.m
//  ImageViewer
//
//  Created by Dhaval on 4/13/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import "IVImagesController.h"
#import "IVDownloadManager.h"
#import "IVImageDownloadManager.h"
#import "IVImageCollectionDownloadManager.h"
#import "Masonry.h"
#import "IVImageTableViewCell.h"
#import "IVImage.h"
#import "IVImageViewerController.h"
#import "SWRevealViewController.h"

NSString * const kIVImagesJsonUrl = @"http://www.crunchyroll.com/mobile-tech-challenge/images.json";
NSString * const kIVImagesTableViewCellIdentifier = @"kIVImagesTableViewCellIdentifier";

@interface IVImagesController ()

@property (nonatomic, strong) IVDownloadManager *downloadManager;
@property (nonatomic, strong) NSArray *metadataOfImages;
@property (nonatomic, strong) UITableView *imagesTableView;
@property (nonatomic, strong) IVImageViewerController *imageViewerController;
@property (nonatomic, strong) NSCache *imageCache;
@property (nonatomic, strong) UIAlertController *alertController;

@end

@implementation IVImagesController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationItem.title = NSLocalizedString(@"Images", nil);
    self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
    
    [self downloadJsonData];
    
    _imagesTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.imagesTableView];
    self.imagesTableView.delegate = self;
    self.imagesTableView.dataSource = self;
    self.imagesTableView.rowHeight = 120;
    self.imagesTableView.backgroundColor = [UIColor clearColor];
    
    [self.imagesTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(self.view);
        make.size.equalTo(self.view);
    }];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.splitViewController.delegate = self;
    
    if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)] && (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable)) {
        [self registerForPreviewingWithDelegate:self sourceView:self.imagesTableView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    if (self.metadataOfImages) {
        count = self.metadataOfImages.count;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IVImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIVImagesTableViewCellIdentifier];
    
    if (!cell) {
        cell = [[IVImageTableViewCell alloc] initWithReuseIdentifier:kIVImagesTableViewCellIdentifier];
        
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.selectedBackgroundView.backgroundColor = [UIColor lightGrayColor];
    }
    
    if (!self.metadataOfImages) {
        return cell;
    }
    
    IVImage *image = [self.metadataOfImages objectAtIndex:indexPath.row];
    cell.thumbnailImageView.image = nil;
    cell.caption.text = image.caption;
    
    if (image.caption.length == 0) {
        cell.caption.text = NSLocalizedString(@"Missing Caption!", nil);
    }
    
    if (image.thumbnailUrl) {
        NSString *url = image.thumbnailUrl;
        if ([self.imageCache objectForKey:url]) {
            cell.thumbnailImageView.image = [self.imageCache objectForKey:url];
        } else {
            NSURL *imageUrl = [[NSURL alloc] initWithString:url];
            [[self.downloadManager.urlSession dataTaskWithURL:imageUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (!error) {
                    UIImage *image = [UIImage imageWithData:data];
                    [self.imageCache setObject:image forKey:url];
                    if (image) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            IVImageTableViewCell *cell = (id)[tableView cellForRowAtIndexPath:indexPath];
                            if (cell) {
                                cell.thumbnailImageView.image = image;
                            }
                        });
                    }
                }
            }] resume];
        }
    }
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    UINavigationController *imageViewerNavigationController = nil;
    
    IVImage *selectedImage =[self.metadataOfImages objectAtIndex:indexPath.row];
    
    // Grab a handle to the reveal controller, as if you'd do with a navigtion controller via self.navigationController.
    //    SWRevealViewController *revealController = self.revealViewController;
    //
    //    if ([self alertWhenMissingUrl:selectedImage]) {
    //        _imageViewerController = [[IVImageViewerController alloc] initWithImage:selectedImage];
    //        UIViewController *imageViewerNavigationController = [[UINavigationController alloc] initWithRootViewController:self.imageViewerController];
    //        [revealController pushFrontViewController:imageViewerNavigationController animated:YES];
    //    }
    
    if ([self alertWhenMissingUrl:selectedImage]) {
        if (self.splitViewController.collapsed) {
            _imageViewerController = [[IVImageViewerController alloc] init];
            imageViewerNavigationController = [[UINavigationController alloc] initWithRootViewController:self.imageViewerController];
        } else {
            imageViewerNavigationController = self.splitViewController.viewControllers[self.splitViewController.viewControllers.count - 1];
            if ([imageViewerNavigationController.topViewController isKindOfClass:[IVImageViewerController class]]) {
                _imageViewerController = (IVImageViewerController *)imageViewerNavigationController.topViewController;
            }
        }
        [self.imageViewerController updateViewAppearence:selectedImage];
    }
    
    [self.splitViewController showDetailViewController:imageViewerNavigationController sender:self];
}

#pragma mark IVDownloadDelegate

- (void)didFinishDownloadingImageMetadata:(IVDownloadManager *)downloadManager {
    if ([downloadManager isKindOfClass:[IVImageCollectionDownloadManager class]]) {
        _metadataOfImages = ((IVImageCollectionDownloadManager *)downloadManager).imagesMetadataCollection;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.imagesTableView reloadData];
        });
    }
}

#pragma mark UISplitViewControllerDelegate

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    
    if (![secondaryViewController isKindOfClass:[UINavigationController class]]) {
        return false;
    }
    
    UINavigationController *navVC = (UINavigationController *)secondaryViewController;
    if (![navVC.topViewController isKindOfClass:[IVImageViewerController class]]) {
        return false;
    }
    
    if (((IVImageViewerController *)navVC.topViewController).image != nil) {
        return false;
    }
    
    return true;
}

#pragma mark UIViewControllerPreviewingDelegate

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    NSIndexPath *indexPath = [self.imagesTableView indexPathForRowAtPoint:location];
    IVImage *selectedImage =[self.metadataOfImages objectAtIndex:indexPath.row];
    UINavigationController *imageViewerNavigationController = nil;
    
    if (selectedImage) {
        IVImageTableViewCell *cell = [self.imagesTableView cellForRowAtIndexPath:indexPath];
        
        if (cell) {
            previewingContext.sourceRect = cell.frame;
        }
        
        if ([self alertWhenMissingUrl:selectedImage]) {
            if (self.splitViewController.collapsed) {
                _imageViewerController = [[IVImageViewerController alloc] init];
                imageViewerNavigationController = [[UINavigationController alloc] initWithRootViewController:self.imageViewerController];
            } else {
                imageViewerNavigationController = self.splitViewController.viewControllers[self.splitViewController.viewControllers.count - 1];
                if ([imageViewerNavigationController.topViewController isKindOfClass:[IVImageViewerController class]]) {
                    _imageViewerController = (IVImageViewerController *)imageViewerNavigationController.topViewController;
                }
            }
            [self.imageViewerController updateViewAppearence:selectedImage];
            return self.imageViewerController;
        }
    }
    
    return nil;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self showDetailViewController:viewControllerToCommit sender:self];
}

#pragma mark Private method
// This method instantiates nsurlsession instance and starts download json data.
- (void)downloadJsonData {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _downloadManager = [[IVImageCollectionDownloadManager alloc] initWithConfiguration:configuration];
    self.downloadManager.downloadDelegate = self;
    [self.downloadManager downloadFromUrlString:kIVImagesJsonUrl];
}

//This method shows alert when original url value is nil and return false so no imageViewerConroller is created.
- (BOOL)alertWhenMissingUrl:(IVImage *)image {
    if (!image.originalUrl) {
        _alertController = [UIAlertController
                            alertControllerWithTitle:NSLocalizedString(@"No URL", nil)
                            message:NSLocalizedString(@"No image to display here, url is missing!", nil)
                            preferredStyle:UIAlertControllerStyleAlert
                            ];
        [self.alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.alertController dismissViewControllerAnimated:true completion:nil];
            _alertController = nil;
        }]];
        
        [self presentViewController:self.alertController animated:true completion:nil];
        return false;
    }
    return true;
}

@end
