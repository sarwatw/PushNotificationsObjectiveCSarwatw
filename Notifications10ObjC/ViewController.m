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

/*
@interface ViewController ()<PTPusherDelegate> {
    AppDelegate *appdelegate;
    PTPusher *_client;
}
@end*/
//@interface ViewController ()

//@end

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
    NSString *currentString = _pushNotificationText2.text;
    NSString *joinString=[NSString stringWithFormat:@"%@|%@|%@",currentString,@" applicationWillEnterForeground", appdelegate.timeString];
    
    _pushNotificationText2.text = joinString;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
NSLog(@"viewDidLoad");
    _pushNotificationText2.text = @"";
    //Instatiating Appdelegate
    if(!appdelegate)
    {
        appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    
    NSString *currentString = _pushNotificationText2.text;
    NSString *joinString=[NSString stringWithFormat:@"%@|%@|%@",currentString,@" viewDidLoad", appdelegate.timeString];
    _pushNotificationText2.text= joinString;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUIDueToLocalNotification:) name:@"notificationCameIn" object:nil];
}

-(void) updateUIDueToLocalNotification:(NSNotification *) notification{
    
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
    
    NSString *currentString = _pushNotificationText2.text;
    NSString *joinString=[NSString stringWithFormat:@"%@|%@|%@",currentString,@" viewDidAppear", appdelegate.timeString];
    
 /*   NSString *newString = [@"viewDidAppear" stringByAppendingString:appdelegate.timeString];

    _pushNotificationText2.text = newString;*/
    
    _pushNotificationText2.text = joinString;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [self getAllPhotosFromCamera];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
   
}


-(void) viewWillDisappear:(BOOL)animated
{/*[[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];*/
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"yourMessage" object:nil];
   // [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    NSLog(@"content being changed");
    /*
     Change notifications may be made on a background queue. Re-dispatch to the
     main queue before acting on the change as we'll be updating the UI.
     */
    __block BOOL reloadRequired = NO;
    __block NSIndexSet *removedIndex;
    __block NSIndexSet *insertedIndexes;
    
        // Loop through the section fetch results, replacing any fetch results that have been updated.
        NSMutableArray *updatedSectionFetchResults = [self.sectionFetchResults mutableCopy];
        //        __block BOOL reloadRequired = NO;
        [self.sectionFetchResults enumerateObjectsUsingBlock:^(PHFetchResult *collectionsFetchResult, NSUInteger index, BOOL *stop) {
            PHFetchResultChangeDetails *changeDetails = [changeInstance changeDetailsForFetchResult:collectionsFetchResult];
            removedIndex = changeDetails.removedIndexes;
            insertedIndexes = changeDetails.insertedIndexes;
            if (changeDetails != nil) {
                [updatedSectionFetchResults replaceObjectAtIndex:index withObject:[changeDetails fetchResultAfterChanges]];
                reloadRequired = YES;
                self.sectionFetchResults = updatedSectionFetchResults;
                if(insertedIndexes != nil){
                    [self->appdelegate uploadPhotoInBackground];
                }else{
                }
                
            }
            
        }];
        if (reloadRequired) {
            self.sectionFetchResults = updatedSectionFetchResults;
            
        }
        
    ;
    
}


-(void)getAllPhotosFromCamera{
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    // Store the PHFetchResult objects and localized titles for each section.
    self.sectionFetchResults = @[allPhotos, smartAlbums, topLevelUserCollections];
}
/*
-(NSMutableArray *)getNumberOfPhotoFromCameraRoll:(NSArray *)array{
    PHFetchResult *fetchResult = array[1];
    int index = 0;
    unsigned long pictures = 0;
    for(int i = 0; i < fetchResult.count; i++){
        unsigned long temp = 0;
        temp = [PHAsset fetchAssetsInAssetCollection:fetchResult[i] options:nil].count;
        if(temp > pictures ){
            pictures = temp;
            index = i;
        }
    }
    PHCollection *collection = fetchResult[index];
    
    if (![collection isKindOfClass:[PHAssetCollection class]]) {
        // return;
    }
    // Configure the AAPLAssetGridViewController with the asset collection.
    PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
    PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    self. assetsFetchResults = assetsFetchResult;
    self. assetCollection = assetCollection;
    self.numberOfPhotoArray = [NSMutableArray array];
    for (int i = 0; i<[assetsFetchResult count]; i++) {
        PHAsset *asset = assetsFetchResult[i];
        [self.numberOfPhotoArray addObject:asset];
    }
    NSLog(@"%lu",(unsigned long)[self.numberOfPhotoArray count]);
    return self.numberOfPhotoArray;
}

*/


@end

