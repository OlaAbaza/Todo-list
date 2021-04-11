//
//  ViewController.h
//  todoApp
//
//  Created by ola abaza on 4/1/21.
//  Copyright © 2021 ola abaza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myProtocol.h"

@interface ViewController : UIViewController
@property id <myProtocol> pro;
@property BOOL isGranted;

@end

