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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"didFinishLaunchingWithOptions");
    
    // setting up location manager
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    [_locationManager setAllowsBackgroundLocationUpdates:YES];
    if([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]){
        [_locationManager requestAlwaysAuthorization];
    }else{
        [_locationManager startUpdatingLocation];
    }
    
      _deviceKey = [AppDelegate key];

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

-(void)uploadValue:(NSString*)message key:(NSString*)keyName
{
    NSLog(@"In uploadValue");
    NSString *url = [NSString stringWithFormat: @"https://coordinatorweb.azurewebsites.net/api/values?name=%@&option=add", keyName];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [req setHTTPMethod:@"POST"];

    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm:ss"];
    NSString *dateTimeString = [outputFormatter stringFromDate:now];
    
    NSString *bodyData = [NSString stringWithFormat: @"%@_%@", dateTimeString, message];
    
    [req setHTTPBody:[bodyData dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[bodyData length]];
    
    [req setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [req setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]
                                  dataTaskWithRequest: req
                                  completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error)
                                  {
                                      if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                          NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                                          NSLog(@"UploadValue: StatusCode%d",statusCode)
                                          if (statusCode != 200) {
                                              NSLog(@"dataTaskWithRequest HTTP status code: %d", statusCode);
                                              return;
                                          }
                                      }
                                  }];
    [task resume];
}


// verified that this method works when we use the localidentifier
-(PHAsset *) getAssetUsingIdentifier
{
    // get file name of last taken photo
    NSLog(@"In getAssetUsingIdentifier");
    
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
    
    // get the local identifier of the last photo taken
    PHAsset *lastAsset = [fetchResult lastObject];
    NSString *localIdentifier = lastAsset.localIdentifier;
    
    // now get the asset using the identifier
    PHFetchResult *fetchResult2 = [PHAsset fetchAssetsWithLocalIdentifiers:@[localIdentifier] options:nil];
    PHAsset *lastAssetRetreived = [fetchResult2 lastObject];
        return lastAssetRetreived;
}


-(void) saveimageindocument:(NSData*) imageData withimagename:(NSString*)imagename{
    
    NSString *writePath = [NSString stringWithFormat:@"%@/%@.png",[self getDocumentDirectory],imagename];
    
    if (![imageData writeToFile:writePath atomically:YES]) {
        // failure
        NSLog(@"image save failed to path %@", writePath);
        
    } else {
        // success.
        NSLog(@"image save Successfully to path %@", writePath);
    }
    
}
- (NSString*)getDocumentDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

-(void)uploadLastTakenPhoto:(NSString*)keyName urlconfig:(NSURLSessionConfiguration*)nsurlconfig session:(NSURLSession*) session;
{
    NSLog(@"In uploadLastTakenPhoto");
        PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
        fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
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
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"image.jpg"]; //Add the file name
    
    if(![photoArray writeToFile:filePath atomically:YES])
    {
        NSLog(@"local image save failed");
    }//Write the file
    
    
    // create a request

    NSString *url = [NSString stringWithFormat: @"https://coordinatorweb.azurewebsites.net/api/values?name=%@&option=add", keyName];
    
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [req setHTTPMethod:@"POST"];
    
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[NSData dataWithData:photoArray]];
    [req setHTTPBody:postbody];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postbody length]];
    
    [req setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [req setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:req fromFile:[NSURL fileURLWithPath:filePath]];
    
    
    NSLog(@"starting upload of photo");
    [uploadTask resume];
    NSLog(@"resume uploadtask called");
}

-(void)uploadPhotoInBackground:(PHAsset*)asset keyName:(NSString*)keyName urlconfig:(NSURLSessionConfiguration*)nsurlconfig session:(NSURLSession*) session
{
    NSLog(@"In uploadPhotoInBackground");
    
    PHImageManager *manager = [PHImageManager defaultManager];
    
    PHImageRequestOptions *requestOptions = [PHImageRequestOptions new];
    requestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    requestOptions.synchronous = true;
    
    __block NSData *photoArray = nil;
    
    [manager requestImageForAsset:asset
                       targetSize:PHImageManagerMaximumSize
                      contentMode:PHImageContentModeDefault
                          options:requestOptions
                    resultHandler:^void(UIImage *image, NSDictionary *info) {
                        NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
                        
                        photoArray = imageData;
                    }];
    

    //Create a file to upload
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"image.jpg"]; //Add the file name
    
    if(![photoArray writeToFile:filePath atomically:YES])
    {
        NSLog(@"local image save failed");
    }//Write the file
    
    NSString *url = [NSString stringWithFormat: @"https://coordinatorweb.azurewebsites.net/api/values?name=%@&option=add", keyName];

    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [req setHTTPMethod:@"POST"];
    
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[NSData dataWithData:photoArray]];
    [req setHTTPBody:postbody];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postbody length]];
    
    [req setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [req setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:req fromFile:[NSURL fileURLWithPath:filePath]];
  
 
    NSLog(@"About to call uploadTask resume");
    [uploadTask resume];
    NSLog(@"resume uploadtask called");
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    NSLog(@"In didSendBodyData");
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    
    NSLog(@"In URLSessionDidFinishEventsForBackgroundURLSession");

}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    NSLog(@"In didReceiveData");

}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        NSLog(@"%@ failed: %@", task.originalRequest.URL, error);
    }
}

          
+ (NSString *)key
{
    NSString *deviceName = [[UIDevice currentDevice] name];
    NSString *deviceNameNoSpace = [deviceName stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *UUID = [[NSUUID UUID] UUIDString];
    NSString *keyName = [NSString stringWithFormat: @"%@_%@", deviceNameNoSpace, UUID];
    
    NSLog(@"KeyName is %@", keyName);
    return keyName;
}



// background fetch
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"In performFetchWithCompletionHandler");
    NSString* keyname = [self deviceKey];
    [self uploadValue:@"performFetchWithCompletionHandler" key:keyname];
    
    [self.myViewController handlePhotoLibraryChanges:keyname];
    //Perform some operation
   completionHandler(UIBackgroundFetchResultNewData);
}


-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)notification
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

    NSLog(@"method didReceiveRemoteNotification - Received remote notification");
    
    NSString* keyname = [self deviceKey];
    [self uploadValue:@"didReceiveRemoteNotification-Silent" key:keyname];
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm:ss"];
    _timeString = [outputFormatter stringFromDate:now];

   // [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationCameIn" object:nil];
    
    [self.myViewController handlePhotoLibraryChanges:keyname];
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
    [outputFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm:ss"];
    _timeString = [outputFormatter stringFromDate:now];
    
    completionHandler();
    
}

#pragma mark - Lolcation Update
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertController *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
   // [errorAlert show];
}
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
        {
            // do some error handling
        }
            break;
        default:{
            [_locationManager startUpdatingLocation];
        }
            break;
    }
}
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
   // userLatitude =  [NSString stringWithFormat:@"%f", location.coordinate.latitude] ;
  //  userLongitude =  [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    NSLog(@"User location %@",location);
   // [_locationManager stopUpdatingLocation];
}


@end
