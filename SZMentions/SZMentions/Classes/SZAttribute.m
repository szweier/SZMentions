//
//  SZAttribute.m
//  SZMentions
//
//  Created by Steve Zweier on 12/19/15.
//  Copyright © 2015 Steven Zweier. All rights reserved.
//

#import "SZAttribute.h"

@implementation SZAttribute

- (instancetype)initWithAttributeName:(NSString *)attributeName attributeValue:(NSObject *)attributeValue
{
    self = [super init];

    if (self) {
        self.attributeName = attributeName;
        self.attributeValue = attributeValue;
    }

    return self;
}

@end