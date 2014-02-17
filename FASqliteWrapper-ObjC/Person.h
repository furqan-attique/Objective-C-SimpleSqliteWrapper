//
//  Person.h
//  FASqliteWrapper-ObjC
//
//  Created by Furqan on 2/17/14.
//  Copyright (c) 2014 InnovativeApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *email;


-(id)initWithDictionary:(NSDictionary *)aDictionary;


@end
