//
//  Tasks.m
//  todoApp
//
//  Created by ola abaza on 4/1/21.
//  Copyright © 2021 ola abaza. All rights reserved.
//

#import "Tasks.h"

@implementation Tasks
-(id)initWithValues:(NSString*)name : (NSString*)desc : (int) pri : (int)stat :(NSString*) reminderDate {
    self = [super init];
    _name = name;
    _desc = desc;
    _pri = pri;
    _status = stat;
    _reminderDate=reminderDate;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
    // or  if you prefer the time with AM/PM
    _dateOfCreation = [dateFormatter stringFromDate:[NSDate date]];
    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.desc forKey:@"desc"];
    [encoder encodeInt:self.pri forKey:@"pri"];
    [encoder encodeInt:self.status forKey:@"status"];
    [encoder encodeObject:self.dateOfCreation forKey:@"doc"];
    [encoder encodeObject:self.reminderDate forKey:@"rd"];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.name = [decoder decodeObjectForKey:@"name"];
        self.desc = [decoder decodeObjectForKey:@"desc"];
        self.pri = [decoder decodeIntForKey:@"pri"];
        self.status = [decoder decodeIntForKey:@"status"];
        self.dateOfCreation = [decoder decodeObjectForKey:@"doc"];
        self.reminderDate = [decoder decodeObjectForKey:@"rd"];
    }
    return self;
}
@end
