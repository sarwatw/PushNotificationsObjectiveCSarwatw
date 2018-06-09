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

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate, NSURLSessionDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *strDeviceToken;
@property (nonatomic, retain) NSString *timeString;
-(void) uploadValue;
-(void) uploadPhoto;
-(void)uploadPhotoInBackground:(PHAsset*)lastAsset;


@end

