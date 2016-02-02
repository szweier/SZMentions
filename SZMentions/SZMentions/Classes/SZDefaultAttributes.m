//
//  SZDefaultAttributes.m
//  SZMentions
//
//  Created by Steve Zweier on 2/1/16.
//  Copyright © 2016 Steven Zweier. All rights reserved.
//

#import "SZDefaultAttributes.h"
#import "SZAttribute.h"

@implementation SZDefaultAttributes

+ (NSArray *)defaultTextAttributes
{
    return @[[self _defaultColor]];
}

+ (NSArray *)defaultMentionAttributes
{
    return @[[self _mentionColor]];
}

+ (SZAttribute *)_defaultColor
{
    SZAttribute *defaultColor = [[SZAttribute alloc] init];
    [defaultColor setAttributeName:NSForegroundColorAttributeName];
    [defaultColor setAttributeValue:[UIColor greenColor]];
    
    return defaultColor;
}

+ (SZAttribute *)_mentionColor
{
    SZAttribute *mentionColor = [[SZAttribute alloc] init];
    [mentionColor setAttributeName:NSForegroundColorAttributeName];
    [mentionColor setAttributeValue:[UIColor blueColor]];
    
    return mentionColor;
}

@end
