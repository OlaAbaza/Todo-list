//
//  myProtocol.h
//  todoApp
//
//  Created by ola abaza on 4/1/21.
//  Copyright © 2021 ola abaza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tasks.h"
NS_ASSUME_NONNULL_BEGIN

@protocol myProtocol <NSObject>
-(void)addTask: (Tasks*) task;
-(void)updateTask: (Tasks*) oldTask : (Tasks*) newTask;

@end

NS_ASSUME_NONNULL_END
