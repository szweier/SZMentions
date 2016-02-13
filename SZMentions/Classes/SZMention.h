//
//  SZMention.h
//  SZMentions
//
//  Created by Steve Zweier on 12/17/15.
//  Copyright © 2015 Steven Zweier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZMention : NSObject

/**
 @brief The location of the mention within the attributed string of the UITextView
 */
@property (nonatomic, assign) NSRange range;

/**
 @brief Contains a reference to the object sent to the addMention: method
 */
@property (nonatomic, readonly) NSObject *object;

/**
 @brief initializer for creating a mention object
 @param mentionRange: the range of the mention
 @param mentionObject: the object of your mention (assuming you get extra data you need to store and retrieve later)
 */
- (instancetype)initWithRange:(NSRange)range
                       object:(NSObject *)object;

@end