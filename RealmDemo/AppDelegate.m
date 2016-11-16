//
//  AppDelegate.m
//  RealmDemo
//
//  Created by taehoon.jung on 2016. 11. 13..
//  Copyright © 2016년 thlife. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"

#import <Realm/Realm.h>
#import "Dog.h"

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
    splitViewController.delegate = self;
    
    
    [self performMigration];
    
    return YES;
}

- (void)performMigration {
    
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    config.schemaVersion = 4;
    
    config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemeVersion) {
        
        if (oldSchemeVersion < 1) {
            
            [migration enumerateObjects:NSStringFromClass([Person class])
                                  block:^(RLMObject * _Nullable oldObject, RLMObject * _Nullable newObject) {
                                      
                                      newObject[@"birthdate"] = [NSDate date];
                                      
                                  }];
            
        }
        
        if (oldSchemeVersion < 3) {
            
            [migration enumerateObjects:NSStringFromClass([Person class])
                                  block:^(RLMObject * _Nullable oldObject, RLMObject * _Nullable newObject) {
                                      
                                      newObject[@"address"] = @"서울특별시 중구 을지로 65 SK T-타워";
                                      
                                  }];
            
        }
        
        if (oldSchemeVersion < 4) {
            
            __block NSInteger idx = 0;
            [migration enumerateObjects:NSStringFromClass([Dog class])
                                  block:^(RLMObject * _Nullable oldObject, RLMObject * _Nullable newObject) {
                                      
                                      NSLog(@"idx: %zd", idx);
                                      newObject[@"idx"] = @(idx);
                                      
                                      idx++;
                                      
                                  }];
            
        }
    };
    
    [RLMRealmConfiguration setDefaultConfiguration:config];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[DetailViewController class]] && ([(DetailViewController *)[(UINavigationController *)secondaryViewController topViewController] detailItem] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}

@end
