//
//  editViewController.h
//  todoApp
//
//  Created by ola abaza on 4/1/21.
//  Copyright © 2021 ola abaza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myProtocol.h"
#import "Tasks.h"
NS_ASSUME_NONNULL_BEGIN

@interface editViewController : UIViewController
@property Tasks *task;
@property id <myProtocol> pro;
@end

NS_ASSUME_NONNULL_END
