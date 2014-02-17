//
//  Person.m
//  FASqliteWrapper-ObjC
//
//  Created by Furqan on 2/17/14.
//  Copyright (c) 2014 InnovativeApps. All rights reserved.
//

#import "Person.h"

@implementation Person

-(id)initWithDictionary:(NSDictionary *)aDictionary
{
    self = [super init];
    if (self)
    {
        _name = ![aDictionary[@"name"] isEqual:[NSNull null]] ? aDictionary[@"name"] : @"";
        _email = ![aDictionary[@"email"] isEqual:[NSNull null]] ? aDictionary[@"email"] : @"";

    }
    return self;
}


@end
