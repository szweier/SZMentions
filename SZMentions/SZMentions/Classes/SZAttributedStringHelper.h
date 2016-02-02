//
//  SZAttributedStringHelper.h
//  SZMentions
//
//  Created by Steve Zweier on 2/1/16.
//  Copyright © 2016 Steven Zweier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZAttributedStringHelper : NSObject

+ (void)_applyAttributes:(NSArray *)attributes
                   range:(NSRange)range
 mutableAttributedString:(NSMutableAttributedString *)mutableAttributedString;

@end
