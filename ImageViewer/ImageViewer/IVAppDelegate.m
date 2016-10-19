//
//  AppDelegate.m
//  ImageViewer
//
//  Created by Dhaval on 4/13/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import "IVAppDelegate.h"
#import "IVImagesController.h"
#import "IVImageViewerController.h"
#import "SWRevealViewController.h"

@interface IVAppDelegate ()

@property (nonatomic, strong) UINavigationController *initialNavigationController;
@property (nonatomic, strong) IVImagesController *imagesController;
@property (nonatomic, strong) IVImageViewerController *imageViewerController;
@property (nonatomic, strong) SWRevealViewController *mainRevealController;
@property (nonatomic, strong) UISplitViewController *splitViewController;

@end

@implementation IVAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _imagesController = [[IVImagesController alloc] init];
    UINavigationController *imagesNavigationController = [[UINavigationController alloc] initWithRootViewController:self.imagesController];
    
    _imageViewerController = [[IVImageViewerController alloc] init];
    UINavigationController *imageViewerNavigationController = [[UINavigationController alloc] initWithRootViewController:self.imageViewerController];

    
    _splitViewController =  [[UISplitViewController alloc] init];
    self.splitViewController.viewControllers = [NSArray arrayWithObjects:imagesNavigationController, imageViewerNavigationController, nil];
    imageViewerNavigationController.topViewController.navigationItem.leftBarButtonItem = [self.splitViewController displayModeButtonItem];
    imageViewerNavigationController.topViewController.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.splitViewController.delegate = self;
    
    //This is helper view controller to setup side bar menu for app.
//    _mainRevealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:initialNavigationController];

    //create the window with the root controller
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.rootViewController = self.mainRevealController;
    self.window.rootViewController = self.splitViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if (![secondaryViewController isKindOfClass:[UINavigationController class]]) {
        return false;
    }

    UINavigationController *navVC = (UINavigationController *)secondaryViewController;
    if (![navVC.topViewController isKindOfClass:[IVImageViewerController class]]) {
        return false;
    }
    
    return true;
}

@end
