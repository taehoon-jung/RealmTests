//
//  Dog.m
//  RealmDemo
//
//  Created by taehoon.jung on 2016. 11. 13..
//  Copyright © 2016년 thlife. All rights reserved.
//

#import "Dog.h"


// Implementations
@implementation Dog

+ (NSString *)primaryKey {
    
    return @"name";
}

+ (NSDictionary *)defaultPropertyValues {
    
    return @{@"createDate": [NSDate date]};
}

- (NSString *)description {
    
    NSMutableString *str = [@"" mutableCopy];
    
    [str appendFormat:@"name: %@\n", self.name];
    [str appendFormat:@"createDate: %@\n", self.createDate];
    [str appendFormat:@"owner: %@\n", self.owner];
    
    return str;
}

@end // none needed


#pragma mark - Person

@implementation Person

+ (NSString *)primaryKey {
    
    return @"name";
}

- (NSString *)description {
    
    NSMutableString *str = [@"" mutableCopy];
    
    [str appendFormat:@"name: %@\n", self.name];
    [str appendFormat:@"birthdate: %@\n", self.birthdate];
    [str appendFormat:@"address: %@\n", self.address];
    
    return str;
}


@end // none needed


