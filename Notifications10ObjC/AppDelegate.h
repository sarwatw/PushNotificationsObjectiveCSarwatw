//
//  AppDelegate.h
//  Notifications10ObjC
//
//  Created by SYS004 on 9/24/16.
//  Copyright © 2016 Kode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "Log.h"
#import <Photos/Photos.h>
#import "ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate, NSURLSessionDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *strDeviceToken;
@property (nonatomic, retain) NSString *timeString;
@property (strong, nonatomic) ViewController *myViewController;
+(NSString *) key;
-(void) uploadValue;
-(void) uploadPhoto;


-(void)uploadLastTakenPhoto:(NSString*)keyName urlconfig:(NSURLSessionConfiguration*)nsurlconfig session:(NSURLSession*) session;
-(void)uploadPhotoInBackground:(PHAsset*)asset keyName:(NSString*)keyName urlconfig:(NSURLSessionConfiguration*)nsurlconfig session:(NSURLSession*) session;

@end

