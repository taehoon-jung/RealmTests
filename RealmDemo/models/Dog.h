//
//  Dog.h
//  RealmDemo
//
//  Created by taehoon.jung on 2016. 11. 13..
//  Copyright © 2016년 thlife. All rights reserved.
//

#import <Realm/Realm.h>

@class Person;

// Dog model
@interface Dog : RLMObject

@property NSInteger idx;

@property NSString *name;
@property NSDate *createDate;
@property Person   *owner;

@end
RLM_ARRAY_TYPE(Dog) // define RLMArray<Dog>

// Person model
@interface Person : RLMObject

@property NSString      *name;
@property NSDate        *birthdate;
@property NSString      *address;

@property RLMArray<Dog *><Dog> *dogs;

@end
RLM_ARRAY_TYPE(Person) // define RLMArray<Person>









