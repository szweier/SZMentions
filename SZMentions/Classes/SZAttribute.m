//
//  SZAttribute.m
//  SZMentions
//
//  Created by Steve Zweier on 12/19/15.
//  Copyright © 2015 Steven Zweier. All rights reserved.
//

#import "SZAttribute.h"

@interface SZAttribute ()

/**
 @brief Name of the attribute to set on a string
 */
@property (nonatomic, strong) NSString *attributeName;

/**
 @brief Value of the attribute to set on a string
 */
@property (nonatomic, strong) NSObject *attributeValue;

@end

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