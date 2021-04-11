//
//  doneViewController.m
//  todoApp
//
//  Created by ola abaza on 4/1/21.
//  Copyright © 2021 ola abaza. All rights reserved.
//

#import "doneViewController.h"
#import "editViewController.h"
#import <UserNotifications/UserNotifications.h>
@interface doneViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *highPriority;
@property NSMutableArray *mediumPriority;
@property NSMutableArray *lowPriority;
@property NSMutableArray *tasks;
@property NSMutableArray *doneTasks;
@property NSUserDefaults *userDefaults;
@end
bool issorted;
@implementation doneViewController

- (IBAction)sortBtn:(id)sender {
    if(issorted)
           issorted=NO;
       else
          issorted=YES;
       [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    issorted=NO;
}
- (void)viewWillAppear:(BOOL)animated{
    _tasks=[NSMutableArray new];
    _doneTasks=[NSMutableArray new];
    _highPriority = [NSMutableArray new];
    _lowPriority = [NSMutableArray new];
    _mediumPriority = [NSMutableArray new];
    [self getFromUserDefaults];
    for(int i=0;i<[_tasks count];i++){
        if([[_tasks objectAtIndex:i] status]==0){
            //printf("kk");
            [_doneTasks addObject:[_tasks objectAtIndex:i]];
        }
     }
    for(int i=0;i<[_doneTasks count];i++){
       if([[_doneTasks objectAtIndex:i] pri]==0){
                        [_lowPriority addObject:[_doneTasks objectAtIndex:i]];
                    }
             if([[_doneTasks objectAtIndex:i] pri]==1){
                 [_mediumPriority addObject:[_doneTasks objectAtIndex:i]];
             }
             if([[_doneTasks objectAtIndex:i] pri]==2){
                 [_highPriority addObject:[_doneTasks objectAtIndex:i]];
             }
    }
    [self.tableView reloadData];
}
-(void)getFromUserDefaults{
        _userDefaults = [NSUserDefaults standardUserDefaults];
        if([_userDefaults objectForKey:@"data"]!=nil){
                NSData *encodedObject = [_userDefaults objectForKey:@"data"];
                NSMutableArray *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
                _tasks=object;

            }
    }


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        if (issorted) {
        return 3;
    }
    else
        return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!issorted) {
        return _doneTasks.count;
    }
    else if (section==0) {
            return _highPriority.count;
        } else if (section == 1 )
        {
            return _mediumPriority.count;
        }
    else if(section ==2)
        {
            return _lowPriority.count;
        }
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"forIndexPath:indexPath];
   UIImage *img;
    if(!issorted){
     if( [[_doneTasks objectAtIndex:indexPath.row] pri] ==2) {
           img = [UIImage imageNamed:@"ichigh"];
        cell.imageView.image = img;
        }
     else if( [[_doneTasks objectAtIndex:indexPath.row] pri] ==1) {
              img = [UIImage imageNamed:@"mid"];
           cell.imageView.image = img;
           }
     else{
         img = [UIImage imageNamed:@"low"];
              cell.imageView.image = img;
     }
  cell.textLabel.text=[[_doneTasks objectAtIndex:indexPath.row] name];
          //cell.textLabel.text=@"ola";
    }
    else{
       if (indexPath.section == 0) {
           cell.textLabel.text = [_highPriority[indexPath.row] name];
           img = [UIImage imageNamed:@"ichigh"];
           cell.imageView.image = img;
       }
       if (indexPath.section == 1) {
           cell.textLabel.text = [_mediumPriority[indexPath.row] name];
           img = [UIImage imageNamed:@"mid"];
           cell.imageView.image = img;
       }
       if (indexPath.section == 2) {
           cell.textLabel.text = [_lowPriority[indexPath.row] name];
           img = [UIImage imageNamed:@"low"];
           cell.imageView.image = img;
       }
               
    }
            
    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!issorted){
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {   [_tasks removeObject:[_doneTasks objectAtIndex:(int)indexPath.row]];
        [_doneTasks removeObject:[_doneTasks objectAtIndex:(int)indexPath.row]];
        [self addToUserDefault];
        
        [self.tableView reloadData];
        [self deleteCertainNotification:[_tasks objectAtIndex:(int)indexPath.row]];
    }
   }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString *num=@"Done:";
    
    if(issorted){
    switch (section) {
        case 0:
            num=@"High";
            break;
        case 1:
        num=@"Med";
        break;
            
        case 2:
        num= @"Low";
        break;
            
        default:
            break;
    }
        
    }
    return num;
}
-(void) deleteCertainNotification: (Tasks*) task
{
    NSArray *arr = [NSArray arrayWithObject:task.name];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removePendingNotificationRequestsWithIdentifiers:arr];
}

-(void)addToUserDefault{
    if([_userDefaults objectForKey:@"data"]!=nil){
            NSData *encodedObject = [_userDefaults objectForKey:@"data"];
            encodedObject = [NSKeyedArchiver archivedDataWithRootObject:_tasks];
            [_userDefaults setObject:encodedObject forKey:@"data"];
            [_userDefaults synchronize];
        }else{
            NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:_tasks];
            [_userDefaults setObject:encodedObject forKey:@"data"];
            [_userDefaults synchronize];
        }
}

@end
