//
//  AppDelegate.m
//  SZMentions
//
//  Created by Steve Zweier on 12/16/15.
//  Copyright © 2015 Steven Zweier. All rights reserved.
//

#import "AppDelegate.h"
#import "SZExampleViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    SZExampleViewController *viewController = [[SZExampleViewController alloc] init];
    [self.window setRootViewController:viewController];
    
    return YES;
}

@end
