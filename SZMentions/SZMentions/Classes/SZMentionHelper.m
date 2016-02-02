//
//  SZMentionHelper.m
//  SZMentions
//
//  Created by Steve Zweier on 2/1/16.
//  Copyright © 2016 Steven Zweier. All rights reserved.
//

#import "SZMentionHelper.h"
#import "SZMention.h"

@implementation SZMentionHelper

+ (NSArray *)_mentionsAfterTextEntryForRange:(NSRange)range inMentions:(NSArray *)mentionsList
{
    NSMutableArray *mentionsAfterTextEntry = @[].mutableCopy;
    
    for (SZMention *mention in mentionsList) {
        NSRange currentMentionRange = mention.range;
        
        if (range.location + range.length <= currentMentionRange.location) {
            [mentionsAfterTextEntry addObject:mention];
        }
    }
    
    return mentionsAfterTextEntry.copy;
}

+ (void)_adjustMentionsInRange:(NSRange)range text:(NSString *)text mentions:(NSArray *)mentions
{
    for (SZMention *mention in [SZMentionHelper _mentionsAfterTextEntryForRange:range inMentions:mentions]) {
        NSInteger rangeAdjustment =
        (text.length ? text.length - (range.length > 0 ? range.length : 0)
         : -(range.length > 0 ? range.length : 0));
        [mention setRange:NSMakeRange(mention.range.location + rangeAdjustment,
                                      mention.range.length)];
    }
}

+ (BOOL)_mentionExistsAtIndex:(NSInteger)index mentions:(NSArray *)mentions
{
    return [mentions filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(SZMention *mention, NSDictionary<NSString *,id> * _Nullable bindings) {
        return index >= mention.range.location && index < mention.range.location + mention.range.length;
    }]].count > 0;
}

+ (BOOL)_needsToChangeToDefaultColorForRange:(NSRange)range textView:(UITextView *)textView mentions:(NSArray *)mentions
{
    BOOL isAheadOfMention =
    (range.location > 0 &&
     [SZMentionHelper _mentionExistsAtIndex:range.location - 1
                                   mentions:mentions]);
    BOOL isAtStartOfTextViewAndIsTouchingMention =
    (range.location == 0 && textView.text.length > 0 &&
     [SZMentionHelper _mentionExistsAtIndex:range.location + 1
                                   mentions:mentions]);
    
    return (isAheadOfMention || isAtStartOfTextViewAndIsTouchingMention);
}

+ (BOOL)_shouldHideMentionsForText:(NSString *)text
{
    return ([text isEqualToString:@" "] ||
            (text.length &&
             [[text substringFromIndex:text.length - 1] isEqualToString:@" "]));
}


@end
