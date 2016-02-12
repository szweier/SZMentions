//
//  SZMention.m
//  SZMentions
//
//  Created by Steve Zweier on 12/17/15.
//  Copyright © 2015 Steven Zweier. All rights reserved.
//

#import "SZMention.h"

@interface SZMention ()

/**
 @brief Contains a reference to the object sent to the addMention: method
 */
@property (nonatomic, strong) NSObject *object;

@end

@implementation SZMention

- (instancetype)initWithRange:(NSRange)range
                       object:(NSObject *)object
{
    self = [super init];

    if (self) {
        _range = range;
        _object = object;
    }

    return self;
}

@end