//
//  SZAttributedStringHelper.h
//  SZMentions
//
//  Created by Steve Zweier on 2/1/16.
//  Copyright © 2016 Steven Zweier. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SZAttribute;

@interface SZAttributedStringHelper : NSObject

/**
 @brief Applies attributes to a given string and range
 @param attributes: the attributes to apply
 @param range: the range to apply the attributes to
 @param mutableAttributedString: the string to apply the attributes to
 */
+ (void)applyAttributes:(NSArray<SZAttribute *> *)attributes
                   range:(NSRange)range
 mutableAttributedString:(NSMutableAttributedString *)mutableAttributedString;

@end
