//
//  ViewController.m
//  Notifications10ObjC
//
//  Created by SYS004 on 9/24/16.
//  Copyright © 2016 Kode. All rights reserved.
//

#import "ViewController.h"
//#import <Pusher/Pusher.h>
#import "AppDelegate.h"
#import <Photos/Photos.h>


@interface ViewController (){
    AppDelegate *appdelegate;
}

@end

@implementation ViewController

- (BOOL)redirectNSLog
{
    // Create log file
    [@"" writeToFile:@"/NSLog.txt" atomically:YES encoding:NSUTF8StringEncoding error:nil];
    id fileHandle = [NSFileHandle fileHandleForWritingAtPath:@"/NSLog.txt"];
    if (!fileHandle)
    {
        NSLog(@"Opening log failed");
        return NO;
    }
    // [fileHandle retain];
    
    // Redirect stderr
    int err = dup2([fileHandle fileDescriptor], STDERR_FILENO);
    if (!err) {
        NSLog(@"Couldn't redirect stderr");
        return NO;
    }
    
    return YES;
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"In applicationWillEnterForeground");
    NSString *currentString = _pushNotificationText2.text;
    NSString *joinString=[NSString stringWithFormat:@"%@|%@|%@",currentString,@" applicationWillEnterForeground", appdelegate.timeString];
    
    _pushNotificationText2.text = joinString;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.myViewController = self;

    NSLog(@"In viewDidLoad");
    _pushNotificationText2.text = @"";
    //Instatiating Appdelegate
    if(!appdelegate)
    {
        appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    
    if(!_configuration)
    {
        _configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"uploadFileServer"];
        
    }
    if(!_session)
    {
        _session = [NSURLSession sessionWithConfiguration:_configuration delegate:appdelegate delegateQueue:nil];
    }
    
    NSString *currentString = _pushNotificationText2.text;
    NSString *joinString=[NSString stringWithFormat:@"%@|%@|%@",currentString,@" viewDidLoad", appdelegate.timeString];
    _pushNotificationText2.text= joinString;
    
  //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUIDueToLocalNotification:) name:@"notificationCameIn" object:nil];
}

-(void) updateUIDueToLocalNotification:(NSNotification *) notification{
    NSLog(@"In updateUIDueToLocalNotification");
    NSString *currentString = _pushNotificationText2.text;
    NSString *joinString=[NSString stringWithFormat:@"%@|%@|%@",currentString,@" updateUIDueToLocalNotification", appdelegate.timeString];
    _pushNotificationText2.text= joinString;
    
}

- (void) updateUI:(NSNotification *) notification{
    
    NSString *currentString = _pushNotificationText2.text;
    NSString *joinString=[NSString stringWithFormat:@"%@|%@|%@",currentString,@" updateUI", appdelegate.timeString];
    _pushNotificationText2.text= joinString;
    
}

- (void) viewDidAppear:(BOOL)animated {
    NSLog(@"In viewDidAppear");
    NSString *currentString = _pushNotificationText2.text;
    NSString *joinString=[NSString stringWithFormat:@"%@|%@|%@",currentString,@" viewDidAppear", appdelegate.timeString];
    _pushNotificationText2.text = joinString;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"In viewWillAppear");
    [super viewWillAppear:animated];
    [self getAllPhotosFromCamera];
}


-(void) viewWillDisappear:(BOOL)animated
{   NSLog(@"In viewWillDisappear");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"yourMessage" object:nil];
}


-(void)handlePhotoLibraryChanges:(NSString*)keyName
{   NSLog(@"In handlePhotoLibraryChanges");
    __block BOOL reloadRequired = NO;
    __block NSIndexSet *insertedIndexes;
    
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *latestFetch = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
    
    NSMutableArray *changedObjects = [NSMutableArray arrayWithCapacity:500];
    PHFetchResult *updatedSectionFetchResults = self.sectionFetchResults;
    PHFetchResultChangeDetails *changeDetails = [PHFetchResultChangeDetails changeDetailsFromFetchResult:updatedSectionFetchResults toFetchResult:latestFetch changedObjects:changedObjects];
    insertedIndexes = changeDetails.insertedIndexes;
    if (changeDetails != nil) {
        updatedSectionFetchResults = [changeDetails fetchResultAfterChanges];
        reloadRequired = YES;
        self.sectionFetchResults = updatedSectionFetchResults;
        if(insertedIndexes != nil){
            NSUInteger count = [insertedIndexes count];
            NSLog(@"Found new photos: %d", count);
            NSArray *insertedObjects = changeDetails.insertedObjects;
            for (NSUInteger i = 0; i < count; i++) {
                PHAsset *asset = [insertedObjects objectAtIndex:i];
                [self->appdelegate uploadPhotoInBackground:asset keyName:keyName urlconfig:_configuration session:_session];
            }
        }
    }
    
    if (reloadRequired) {
        self.sectionFetchResults = updatedSectionFetchResults;
        
    }
    
}
- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    NSLog(@"In photoLibraryDidChange");
 
     /*Change notifications may be made on a background queue. Re-dispatch to the
     main queue before acting on the change as we'll be updating the UI.*/
    
    __block BOOL reloadRequired = NO;
    __block NSIndexSet *removedIndex;
    __block NSIndexSet *insertedIndexes;
    
    
    PHFetchResult *updatedSectionFetchResults = self.sectionFetchResults;
    PHFetchResultChangeDetails *changeDetails = [changeInstance changeDetailsForFetchResult:self.sectionFetchResults ];
    removedIndex = changeDetails.removedIndexes;
    insertedIndexes = changeDetails.insertedIndexes;
    if (changeDetails != nil) {
        //[updatedSectionFetchResults replaceObjectAtIndex:index withObject:[changeDetails fetchResultAfterChanges]];
        updatedSectionFetchResults = [changeDetails fetchResultAfterChanges];
        reloadRequired = YES;
        self.sectionFetchResults = updatedSectionFetchResults;
        if(insertedIndexes != nil){
            NSUInteger count = [insertedIndexes count];
            NSArray *insertedObjects = changeDetails.insertedObjects;
            NSString *key = [AppDelegate key];
            for (NSUInteger i = 0; i < count; i++) {
                PHAsset *asset = [insertedObjects objectAtIndex:i];
                [self->appdelegate uploadPhotoInBackground:asset keyName:key urlconfig:_configuration session:_session];
            }
        }
    }
    
    if (reloadRequired) {
        self.sectionFetchResults = updatedSectionFetchResults;
        
    }
}


-(void)getAllPhotosFromCamera{
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    // Store the PHFetchResult objects and localized titles for each section.
    self.sectionFetchResults = allPhotos;
    //self.sectionFetchResults = @[allPhotos, smartAlbums, topLevelUserCollections];
}

@end

