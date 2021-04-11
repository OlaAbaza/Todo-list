//
//  progressViewController.h
//  todoApp
//
//  Created by ola abaza on 4/1/21.
//  Copyright © 2021 ola abaza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface progressViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,myProtocol>

@end

NS_ASSUME_NONNULL_END
