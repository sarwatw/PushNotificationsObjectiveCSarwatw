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
}


-(void) viewWillDisappear:(BOOL)animated
{/*[[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];*/
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"yourMessage" object:nil];
}





@end

