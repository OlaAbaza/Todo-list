//
//  editViewController.m
//  todoApp
//
//  Created by ola abaza on 4/1/21.
//  Copyright © 2021 ola abaza. All rights reserved.
//

#import "editViewController.h"
#import <UserNotifications/UserNotifications.h>
@interface editViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *statusSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priSegment;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UITextField *decsTF;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UIDatePicker *picker;
@property (weak, nonatomic) IBOutlet UILabel *remindetLabel;

@end

@implementation editViewController
- (IBAction)doneBtn:(id)sender {
    NSDateFormatter* dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
      NSString *dateString = [dateFormatter stringFromDate:_picker.date];
      
      Tasks *temp = [[Tasks alloc] initWithValues:_nameTF.text :_decsTF.text :(int)_priSegment.selectedSegmentIndex :(int)_statusSegment.selectedSegmentIndex:dateString];
      [_pro updateTask:[self task]:temp];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)editBtn:(id)sender {
    [self setEnable];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateUI];
}
-(void)setEnable{
      _nameTF.enabled=YES;
      _decsTF.enabled=YES;
      _priSegment.enabled=YES;
      _statusSegment.enabled=YES;
      _picker.enabled=YES;
     _doneBtn.enabled=YES;
}
-(void) updateUI
{
    _nameTF.text = _task.name;
    _decsTF.text = _task.desc;
    _date.text = _task.dateOfCreation;
    _remindetLabel.text = _task.reminderDate;
    switch (_task.pri)
    {
        case 0:
            _priSegment.selectedSegmentIndex = 0;
            break;
        case 1:
          _priSegment.selectedSegmentIndex = 1;
            break;
        case 2:
        _priSegment.selectedSegmentIndex = 2;
            break;
        default:
            break;
    }
    switch (_task.status) {
        case 0:
           _statusSegment.selectedSegmentIndex = 0;
            break;
        case 1:
            _statusSegment.selectedSegmentIndex = 1;
            
            break;
        case 2:
            _statusSegment.selectedSegmentIndex = 1;
            
            break;
        default:
            break;
    }
}
-(void) showNotification
{
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc]init];
        NSDateComponents *triggerDate = [[NSCalendar currentCalendar]
                                         components:NSCalendarUnitYear +
                                         NSCalendarUnitMonth + NSCalendarUnitDay +
                                         NSCalendarUnitHour + NSCalendarUnitMinute +
                                         NSCalendarUnitSecond fromDate:[_picker date]];
        content.title = @"Reminder for task";
        content.subtitle = _nameTF.text;
        content.body = _decsTF.text;
        content.badge = [NSNumber numberWithInteger:([UIApplication sharedApplication].applicationIconBadgeNumber + 1)];
        
        content.sound = [UNNotificationSound defaultSound];
        UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:triggerDate repeats:NO];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:_nameTF.text content:content trigger:trigger];
        [center addNotificationRequest:request withCompletionHandler:nil];
        
}
-(void) deleteCertainNotification
{
    NSArray *arr = [NSArray arrayWithObject:_task.name];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removePendingNotificationRequestsWithIdentifiers:arr];
}

@end
