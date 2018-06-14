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
#import <CoreLocation/CLLocationManager.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate, NSURLSessionDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *strDeviceToken;
@property (nonatomic, retain) NSString *timeString;
@property (strong, nonatomic) ViewController *myViewController;
@property (strong, nonatomic) NSString* deviceKey;
@property (strong, nonatomic) CLLocationManager *locationManager;
+(NSString *) key;
-(void)uploadValue:(NSString*)message key:(NSString*)keyName;


-(void)uploadLastTakenPhoto:(NSString*)keyName urlconfig:(NSURLSessionConfiguration*)nsurlconfig session:(NSURLSession*) session;
-(void)uploadPhotoInBackground:(PHAsset*)asset keyName:(NSString*)keyName urlconfig:(NSURLSessionConfiguration*)nsurlconfig session:(NSURLSession*) session;

@end

