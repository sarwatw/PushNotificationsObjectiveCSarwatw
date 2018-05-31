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

    /*
    NSString *newString = [@"applicationWillEnterForeground" stringByAppendingString:appdelegate.timeString];
    
    _pushNotificationText2.text = newString;
    //_pushNotificationText.text = appdelegate.timeString;*/
    

    
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

    
    // self.client is a strong instance variable of class PTPusher
    /*
    _client = [PTPusher pusherWithKey:@"7296d78f40ffa0bc3a77" delegate:self encrypted:YES cluster:@"us2"];
    
    // subscribe to channel and bind to event
    PTPusherChannel *channel = [_client subscribeToChannelNamed:@"my-channel"];
    
    [channel bindToEventNamed:@"my-event" handleWithBlock:^(PTPusherEvent *channelEvent) {
        // channelEvent.data is a NSDictianary of the JSON object received
        NSString *message = [channelEvent.data objectForKey:@"message"];
        NSLog(@"message received: %@", message);
    }];

    [_client connect];*/
    
    NSString *currentString = _pushNotificationText2.text;
    NSString *joinString=[NSString stringWithFormat:@"%@|%@|%@",currentString,@" viewDidLoad", appdelegate.timeString];
    _pushNotificationText2.text= joinString;
    /*
    NSString *newString = [@"viewDidLoad" stringByAppendingString:appdelegate.timeString];
    
    _pushNotificationText2.text = newString;*/
    //_pushNotificationText.text = appdelegate.timeString;
    
 /*   [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUI:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUIDueToLocalNotification:) name:@"notificationCameIn" object:nil];
}

-(void) updateUIDueToLocalNotification:(NSNotification *) notification{
    
    NSString *currentString = _pushNotificationText2.text;
    NSString *joinString=[NSString stringWithFormat:@"%@|%@|%@",currentString,@" updateUIDueToLocalNotification", appdelegate.timeString];
    _pushNotificationText2.text= joinString;

    /*
    NSString *newString = [@"updateUIDueToLocalNotification called"
                           stringByAppendingString:appdelegate.timeString];
    // NSString *newString2 = [newString
    //stringByAppendingString:methodName];
    
    _pushNotificationText2.text = newString;*/

}

- (void) updateUI:(NSNotification *) notification{
    
    NSString *currentString = _pushNotificationText2.text;
    NSString *joinString=[NSString stringWithFormat:@"%@|%@|%@",currentString,@" updateUI", appdelegate.timeString];
    _pushNotificationText2.text= joinString;
    
    /*
    NSString *newString = [@"updateUI called from "
                           stringByAppendingString:appdelegate.timeString];
   // NSString *newString2 = [newString
                           //stringByAppendingString:methodName];
    
    _pushNotificationText2.text = newString;
    */
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

