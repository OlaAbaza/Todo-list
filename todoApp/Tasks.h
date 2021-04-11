//
//  Tasks.h
//  todoApp
//
//  Created by ola abaza on 4/1/21.
//  Copyright © 2021 ola abaza. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Tasks : NSObject <NSCoding>
@property NSString *name;
@property NSString *desc;
@property int pri;
@property NSString* reminderDate;
@property int status;
@property NSString *dateOfCreation;

-(id)initWithValues:(NSString*)name : (NSString*)description : (int) pri :(int)stat :(NSString*) reminderDate;
@end

NS_ASSUME_NONNULL_END
