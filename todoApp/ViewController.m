//
//  ViewController.m
//  todoApp
//
//  Created by ola abaza on 4/1/21.
//  Copyright © 2021 ola abaza. All rights reserved.
//

#import "ViewController.h"
#import "Tasks.h"
#import <UserNotifications/UserNotifications.h>
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *desc;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *pri;
@property NSUserDefaults *userDefaults;
@property NSMutableArray *currentData;
@end

@implementation ViewController
- (IBAction)addTask:(id)sender {
     NSDateFormatter* dateFormatter = [NSDateFormatter new];
      [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:_datePicker.date];
    
    Tasks *temp = [[Tasks alloc] initWithValues:_name.text :_desc.text :(int)_pri.selectedSegmentIndex :2:dateString];
    [_pro addTask:temp];
    [self showNotification];
   // [self addToUserDefault:temp];

    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)addToUserDefault:(Tasks *)temp {
    if([_userDefaults objectForKey:@"data"]!=nil){
            NSData *encodedObject = [_userDefaults objectForKey:@"data"];
            NSMutableArray *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
            _currentData=object;
            [_currentData addObject:temp];
            encodedObject = [NSKeyedArchiver archivedDataWithRootObject:_currentData];
            [_userDefaults setObject:encodedObject forKey:@"data"];
            [_userDefaults synchronize];
        }else{
            [_currentData addObject:temp];
            NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:_currentData];
            [_userDefaults setObject:encodedObject forKey:@"data"];
            [_userDefaults synchronize];
        }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _userDefaults = [NSUserDefaults standardUserDefaults];
    _currentData = [NSMutableArray new];
    // Do any additional setup after loading the view.
}
-(void) showNotification
{    if(_isGranted){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc]init];
        NSDateComponents *triggerDate = [[NSCalendar currentCalendar]
                                         components:NSCalendarUnitYear +
                                         NSCalendarUnitMonth + NSCalendarUnitDay +
                                         NSCalendarUnitHour + NSCalendarUnitMinute +
                                         NSCalendarUnitSecond fromDate:[_datePicker date]];
        content.title = @"Reminder for task";
        content.subtitle = _name.text;
        content.body = _desc.text;
        content.badge = [NSNumber numberWithInteger:([UIApplication sharedApplication].applicationIconBadgeNumber + 1)];
        
        content.sound = [UNNotificationSound defaultSound];
        UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:triggerDate repeats:NO];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:_name.text content:content trigger:trigger];
        [center addNotificationRequest:request withCompletionHandler:nil];
}
        
}


@end
