//
//  SZAttributedStringHelper.m
//  SZMentions
//
//  Created by Steve Zweier on 2/1/16.
//  Copyright © 2016 Steven Zweier. All rights reserved.
//

#import "SZAttributedStringHelper.h"
#import "SZAttribute.h"

@implementation SZAttributedStringHelper

+ (void)applyAttributes:(NSArray<SZAttribute *> *)attributes
                   range:(NSRange)range
 mutableAttributedString:(NSMutableAttributedString *)mutableAttributedString
{
    for (SZAttribute *attribute in attributes) {
        [mutableAttributedString addAttribute:attribute.attributeName
                                        value:attribute.attributeValue
                                        range:range];
    }
}

@end
