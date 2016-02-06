//
//  SZDefaultAttributes.h
//  SZMentions
//
//  Created by Steve Zweier on 2/1/16.
//  Copyright © 2016 Steven Zweier. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SZAttribute;

@interface SZDefaultAttributes : NSObject

/**
 @brief the text attributes to be applied to default text (can be overridden using inits on SZMentionsListener)
 */
+ (NSArray<SZAttribute *> *)defaultTextAttributes;

/**
 @brief the text attributes to be applied to mention text (can be overridden using inits on SZMentionsListener)
 */
+ (NSArray<SZAttribute *> *)defaultMentionAttributes;

@end
