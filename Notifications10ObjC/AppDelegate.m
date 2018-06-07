//
//  AppDelegate.m
//  Notifications10ObjC
//
//  Created by SYS004 on 9/24/16.
//  Copyright © 2016 Kode. All rights reserved.
//

#import "AppDelegate.h"
#import <Photos/Photos.h>


#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

// define macro
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface AppDelegate ()

@end

@implementation AppDelegate

/*
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self registerForRemoteNotification];
    
    return YES;
}*/

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"didFinishLaunchingWithOptions");
 //   [self uploadPhoto];
    application.applicationIconBadgeNumber = 0;
    if( SYSTEM_VERSION_LESS_THAN( @"10.0" ) )
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound |    UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    }
    else
    {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error)
         {
             if( !error )
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [[UIApplication sharedApplication] registerForRemoteNotifications];
                 });

                 NSLog(@"Push registration success.");
             }
             else
             {
                 NSLog( @"Push registration FAILED" );
                 NSLog( @"ERROR: %@ - %@", error.localizedFailureReason, error.localizedDescription );
                 NSLog( @"SUGGESTIONS: %@ - %@", error.localizedRecoveryOptions, error.localizedRecoverySuggestion );
             }
         }];
    }
    
    _timeString = @"appDidFinishLaunchingWithOptions";
    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    
    NSLog(@"In applicationWillResignActive");
}

- (void)applicationDidFinishLaunching:(UIApplication *)app {
    
    NSLog(@"In applicationDidFinishLaunching");
    // Register for remote notifications.
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    // set minimum fetch interval
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
 //     [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"In applicationDidEnterBackground");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    NSLog(@"In applicationWillEnterForeground");
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   
    NSLog(@"In applicationDidBecomeActive");

}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
      [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
        NSLog(@"In applicationWillTerminate");
}

#pragma mark - Remote Notification Delegate // <= iOS 9.x


- (void)requestAuthorizationWithOptions:(UNAuthorizationOptions)options
                      completionHandler:(void (^)(BOOL granted, NSError *error))completionHandler{
    
    NSLog(@"In requestAuthorizationWithOptions");

}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *strDevicetoken = [[NSString alloc]initWithFormat:@"%@",[[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""]];
    
    NSLog(@"Device Token = %@",strDevicetoken);
    self.strDeviceToken = strDevicetoken;
}

-(void)uploadValue
{
    // https://stackoverflow.com/questions/7673127/how-to-send-post-and-get-request
    
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://coordinatorweb.azurewebsites.net/api/values?name=sarwatismail4&option=add"]];
    [req setHTTPMethod:@"POST"];
    NSString *bodyData = @"yoooo";
    [req setHTTPBody:[bodyData dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *postLength = [NSString stringWithFormat:@"%d",[bodyData length]];
    
    [req setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [req setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]
                                  dataTaskWithRequest: req
                                  completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error)
                                  {
                                      
                                      if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                          
                                          NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                                          
                                          NSLog(@"StatusCode%d",statusCode)
                                          if (statusCode != 200) {
                                              NSLog(@"dataTaskWithRequest HTTP status code: %d", statusCode);
                                              return;
                                          }
                                      }

                                      
                                      
                                      
                                      
                                  }];
    [task resume];
    
    
    
}


-(void)uploadPhoto
{
    NSLog(@"In uploadPhoto");
    
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    fetchOptions.fetchLimit = 10;
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
    PHAsset *lastAsset = [fetchResult lastObject];
    
    PHImageManager *manager = [PHImageManager defaultManager];
    
    PHImageRequestOptions *requestOptions = [PHImageRequestOptions new];
    requestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    requestOptions.synchronous = true;
    
    __block NSData *photoArray = nil;
    
    [manager requestImageForAsset:lastAsset
                       targetSize:PHImageManagerMaximumSize
                      contentMode:PHImageContentModeDefault
                          options:requestOptions
                    resultHandler:^void(UIImage *image, NSDictionary *info) {
                        NSData *imageData = UIImageJPEGRepresentation(image, 0.01);
                        
                        photoArray = imageData;
                    }];
    
    
    // https://stackoverflow.com/questions/7673127/how-to-send-post-and-get-request

    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://coordinatorweb.azurewebsites.net/api/values?name=sarwatismail7&option=add"]];
    [req setHTTPMethod:@"POST"];

    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[NSData dataWithData:photoArray]];
    [req setHTTPBody:postbody];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postbody length]];
    
    [req setValue:postLength forHTTPHeaderField:@"Content-Length"];
    //[req addValue:contentType forHTTPHeaderField: @"Content-Type"];
       [req setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    
   /* NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"uploadFileServer"];
    
     NSURLSessionUploadTask
    https://stackoverflow.com/questions/38581240/nsurlsessionuploadtask-example-in-objective-c
    */

    
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]
                                  dataTaskWithRequest: req
                                  completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error)
                                  {
                                      if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                          
                                          NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                                          
                                          NSLog(@"StatusCode%d",statusCode)
                                          if (statusCode != 200) {
                                              NSLog(@"dataTaskWithRequest HTTP status code: %d", statusCode);
                                              return;
                                          }
                                      }

                                  }];
    [task resume];
    
    
    
}

+ (NSString *)uuid
{
    NSString *UUID = [[NSUUID UUID] UUIDString];
    return UUID;
}

// background fetch
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"performFetchWithCompletionHandler");
    //Perform some operation
    completionHandler(UIBackgroundFetchResultNewData);
}


-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)notification
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

    NSLog(@"method didReceiveRemoteNotification - Received remote notification");
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm:ss"];
    _timeString = [outputFormatter stringFromDate:now];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationCameIn" object:nil];
    
    [self uploadValue];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"In method didFailToRegisterForRemoteNotificationsWithError");
    NSLog(@"%@ = %@", NSStringFromSelector(_cmd), error);
    NSLog(@"Error = %@",error);
}

#pragma mark - UNUserNotificationCenter Delegate // >= iOS 10

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    NSLog(@"willPresentNotification User Info = %@",notification.request.content.userInfo);
    
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)(void))completionHandler
{
    NSLog(@"didReceiveNotificationResponse User Info = %@",response.notification.request.content.userInfo);
    
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm:ss"];
    _timeString = [outputFormatter stringFromDate:now];
    
    completionHandler();
    
}




@end
