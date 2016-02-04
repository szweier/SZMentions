//
//  SZDefaultAttributes.h
//  SZMentions
//
//  Created by Steve Zweier on 2/1/16.
//  Copyright © 2016 Steven Zweier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZDefaultAttributes : NSObject

/**
 @brief the text attributes to be applied to default text (can be overridden using inits on SZMentionsListener)
 */
+ (NSArray *)defaultTextAttributes;

/**
 @brief the text attributes to be applied to mention text (can be overridden using inits on SZMentionsListener)
 */
+ (NSArray *)defaultMentionAttributes;

@end
