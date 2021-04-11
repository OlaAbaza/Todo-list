//
//  todoViewController.m
//  todoApp
//
//  Created by ola abaza on 4/1/21.
//  Copyright © 2021 ola abaza. All rights reserved.
//

#import "todoViewController.h"
#import "editViewController.h"
#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "Tasks.h"
@interface todoViewController (){
     BOOL isFiltered;
     NSMutableArray* filteredArr;

}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *tasks;
@property NSMutableArray *todoTasks;
@property NSUserDefaults *userDefaults;

@end
BOOL isGrantedNotificationAccess;
@implementation todoViewController
- (IBAction)addBtn:(id)sender {
    ViewController *vi=[self.storyboard instantiateViewControllerWithIdentifier:@"addViewC" ];
    vi.isGranted=isGrantedNotificationAccess;
    [vi setPro:self];
    
    [self.navigationController pushViewController:vi animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
     
    isFiltered=NO;
     [self notificationAuth];
   
    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    _tasks=[NSMutableArray new];
    filteredArr=[NSMutableArray new];
    _tasks=[NSMutableArray new];
    _todoTasks=[NSMutableArray new];
    [self getFromUserDefaults];
    for(int i=0;i<[_tasks count];i++){
        if([[_tasks objectAtIndex:i] status]==2){
            printf("_todoTasks");
            [_todoTasks addObject:[_tasks objectAtIndex:i]];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numRows = 0 ;
    if(isFiltered)
       {
           numRows =  [filteredArr count];
       }
       else
       {
           numRows = [_todoTasks count];
       }
    return  numRows;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {   [_tasks removeObject:[_todoTasks objectAtIndex:(int)indexPath.row]];
        [_todoTasks removeObjectAtIndex:(int)indexPath.row];
        [self addToUserDefault];
        
        [self.tableView reloadData];
        [self deleteCertainNotification:[_tasks objectAtIndex:(int)indexPath.row]];
    }
}
-(void) deleteCertainNotification: (Tasks*) task
{
    NSArray *arr = [NSArray arrayWithObject:task.name];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removePendingNotificationRequestsWithIdentifiers:arr];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"forIndexPath:indexPath];
   UIImage *img;
    if( [[_todoTasks objectAtIndex:indexPath.row] pri] ==2) {
          img = [UIImage imageNamed:@"ichigh"];
       cell.imageView.image = img;
       }
    else if( [[_todoTasks objectAtIndex:indexPath.row] pri] ==1) {
             img = [UIImage imageNamed:@"mid"];
          cell.imageView.image = img;
          }
    else{
        img = [UIImage imageNamed:@"low"];
             cell.imageView.image = img;
    }
    
    NSLog(@"%@",_tasks);
    NSMutableArray* arr = [NSMutableArray new];
     if(isFiltered)
     {
         arr = filteredArr;
         
     }
     else
     {
         arr =_todoTasks;
     }
    
 cell.textLabel.text=[[arr objectAtIndex:indexPath.row] name];
         // cell.textLabel.text=@"ola";
            
    return cell;
}

-(NSIndexPath*) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{

editViewController *vi=[self.storyboard instantiateViewControllerWithIdentifier:
                    @"viewC" ];
    if(isFiltered==YES){
        printf("kjk");
    vi.task=[filteredArr objectAtIndex:indexPath.row];
    }
    else{
        printf("kll");
    vi.task=[_todoTasks objectAtIndex:indexPath.row];
        
    }
    [vi setPro:self];
  
[self.navigationController pushViewController:vi animated:YES];
return indexPath;
}

- (void)addTask:(Tasks *)task {
    [_tasks addObject:task];
    [_todoTasks addObject:task];
    [self.tableView reloadData];
    [self addToUserDefault];
}

-(void) notificationAuth
{
    isGrantedNotificationAccess = NO;
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNAuthorizationOptions options = UNAuthorizationOptionSound+UNAuthorizationOptionAlert;
    [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        isGrantedNotificationAccess = granted;
    }];
}
- (void)updateTask:(Tasks *)oldTask : (Tasks *)newTask {
    [_tasks removeObject:oldTask];
    [_tasks addObject:newTask];
    [_todoTasks removeObject:oldTask];
    [_todoTasks addObject:newTask];
    if(isFiltered){
        [filteredArr removeObject:oldTask];
        [filteredArr addObject:newTask];
        
    }
    [self addToUserDefault];
    
    [self.tableView reloadData];
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
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    isFiltered = YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    filteredArr = [NSMutableArray new];
    if(searchText.length == 0)
    {
        isFiltered=NO;
    }
    
    else
    {
        isFiltered=YES;
        for (int i =0 ; i<[_todoTasks count]; i++) {
            NSRange stringRange = [[[_todoTasks objectAtIndex:i]name] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(stringRange.location != NSNotFound)
            {
                [filteredArr addObject:[_todoTasks objectAtIndex:i]];
            }
        }
        
        
    }
    [_tableView reloadData];
    
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_tableView resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    isFiltered=NO;
    [_tableView reloadData];
    
}

@end
