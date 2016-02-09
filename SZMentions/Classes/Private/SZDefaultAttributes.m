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

+ (NSArray<SZAttribute *> *)defaultTextAttributes
{
    return @[[self defaultColor]];
}

+ (NSArray<SZAttribute *> *)defaultMentionAttributes
{
    return @[[self mentionColor]];
}

+ (SZAttribute *)defaultColor
{
    SZAttribute *defaultColor = [[SZAttribute alloc] initWithAttributeName:NSForegroundColorAttributeName
                                                            attributeValue:[UIColor greenColor]];
    return defaultColor;
}

+ (SZAttribute *)mentionColor
{
    SZAttribute *mentionColor = [[SZAttribute alloc] initWithAttributeName:NSForegroundColorAttributeName
                                                            attributeValue:[UIColor blueColor]];
    return mentionColor;
}

@end
