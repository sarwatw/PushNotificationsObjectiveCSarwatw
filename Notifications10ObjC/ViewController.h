//
//  ViewController.h
//  Notifications10ObjC
//
//  Created by SYS004 on 9/24/16.
//  Copyright © 2016 Kode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Log.h"
@interface ViewController : UIViewController

//@property (weak, nonatomic) IBOutlet UILabel *pushNotificationText;
@property (weak, nonatomic) IBOutlet UITextView *pushNotificationText2;
-(void) updateUI:(NSNotification *) notification;
-(void) updateUIDueToLocalNotification:(NSNotification *) notification;
 //(void)handleChangedLibrary:(PHChange *)changeInstance;



@end

