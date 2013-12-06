//
//  HAAppDelegate.m
//  HelloAX
//
//  Created by Sommer Panage on 12/5/13.
//  Copyright (c) 2013 Sommer Panage. All rights reserved.
//

#import "HAAppDelegate.h"
#import "HAMainViewController.h"

@implementation HAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [HAMainViewController new];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
