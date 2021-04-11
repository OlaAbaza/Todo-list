//
//  progressViewController.m
//  todoApp
//
//  Created by ola abaza on 4/1/21.
//  Copyright © 2021 ola abaza. All rights reserved.
//

#import "progressViewController.h"
#import "editViewController.h"
#import <UserNotifications/UserNotifications.h>
@interface progressViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *tasks;
@property NSMutableArray *inProgressTasks;
@property NSUserDefaults *userDefaults;
@property NSMutableArray *highPriority;
@property NSMutableArray *mediumPriority;
@property NSMutableArray *lowPriority;
@end
bool isSorted;
@implementation progressViewController
- (IBAction)sortBtn:(id)sender {
    if(isSorted)
        isSorted=NO;
    else
       isSorted=YES;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isSorted=NO;
}
- (void)viewWillAppear:(BOOL)animated{
    _highPriority = [NSMutableArray new];
    _lowPriority = [NSMutableArray new];
    _mediumPriority = [NSMutableArray new];
    _tasks=[NSMutableArray new];
    _inProgressTasks=[NSMutableArray new];
    [self getFromUserDefaults];
    for(int i=0;i<[_tasks count];i++){
        if([[_tasks objectAtIndex:i] status]==1){
            printf("kk");
            [_inProgressTasks addObject:[_tasks objectAtIndex:i]];
        }
     }
    for(int i=0;i<[_inProgressTasks count];i++){
           if([[_inProgressTasks objectAtIndex:i] pri]==0){
                            [_lowPriority addObject:[_inProgressTasks objectAtIndex:i]];
                        }
                 if([[_inProgressTasks objectAtIndex:i] pri]==1){
                     [_mediumPriority addObject:[_inProgressTasks objectAtIndex:i]];
                 }
                 if([[_inProgressTasks objectAtIndex:i] pri]==2){
                     [_highPriority addObject:[_inProgressTasks objectAtIndex:i]];
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
        if (isSorted) {
        return 3;
    }
    else
        return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!isSorted) {
        return _inProgressTasks.count;
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
    if(!isSorted){
     if( [[_inProgressTasks objectAtIndex:indexPath.row] pri] ==2) {
           img = [UIImage imageNamed:@"ichigh"];
        cell.imageView.image = img;
        }
     else if( [[_inProgressTasks objectAtIndex:indexPath.row] pri] ==1) {
              img = [UIImage imageNamed:@"mid"];
           cell.imageView.image = img;
           }
     else{
         img = [UIImage imageNamed:@"low"];
              cell.imageView.image = img;
     }
  cell.textLabel.text=[[_inProgressTasks objectAtIndex:indexPath.row] name];
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
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString *num=@"In progress:";
    
    if(isSorted==YES){
    
    
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
-(NSIndexPath*) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{

editViewController *vi=[self.storyboard instantiateViewControllerWithIdentifier:
                    @"viewC" ];
    vi.task=[_inProgressTasks objectAtIndex:indexPath.row];
    [vi setPro:self];
  
[self.navigationController pushViewController:vi animated:YES];
return indexPath;
}
- (void)updateTask:(Tasks *)oldTask : (Tasks *)newTask {
    [_tasks removeObject:oldTask];
    [_tasks addObject:newTask];
    [_inProgressTasks removeObject:oldTask];
    [_inProgressTasks addObject:newTask];
    [self addToUserDefault];
    
    [self.tableView reloadData];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isSorted){
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {   [_tasks removeObject:[_inProgressTasks objectAtIndex:(int)indexPath.row]];
        [_inProgressTasks removeObjectAtIndex:(int)indexPath.row];
        [self addToUserDefault];
        
        [self.tableView reloadData];
        [self deleteCertainNotification:[_tasks objectAtIndex:(int)indexPath.row]];
    }
    }
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
