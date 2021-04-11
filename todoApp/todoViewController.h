//
//  todoViewController.h
//  todoApp
//
//  Created by ola abaza on 4/1/21.
//  Copyright © 2021 ola abaza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface todoViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,myProtocol>

@end

NS_ASSUME_NONNULL_END
