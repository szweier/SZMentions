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
@property (nonatomic, strong) NSObject *object;

@end