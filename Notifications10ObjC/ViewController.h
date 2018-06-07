//
//  ViewController.h
//  Notifications10ObjC
//
//  Created by SYS004 on 9/24/16.
//  Copyright © 2016 Kode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Log.h"
#import <Photos/Photos.h>
@interface ViewController : UIViewController

//@property (weak, nonatomic) IBOutlet UILabel *pushNotificationText;
@property (weak, nonatomic) IBOutlet UITextView *pushNotificationText2;
@property (nonatomic, strong) NSArray *sectionFetchResults;
@property (nonatomic, strong) PHFetchResult *assetsFetchResults;
@property (nonatomic, strong) PHAssetCollection *assetCollection;
@property (nonatomic, strong) NSMutableArray *numberOfPhotoArray;
-(void) updateUI:(NSNotification *) notification;
-(void) updateUIDueToLocalNotification:(NSNotification *) notification;
 //(void)handleChangedLibrary:(PHChange *)changeInstance;



@end

