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

+ (NSArray<SZMention *> *)mentionsAfterTextEntryForRange:(NSRange)range
                                              inMentions:(NSArray<SZMention *> *)mentionsList
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

+ (void)adjustMentionsInRange:(NSRange)range
                         text:(NSString *)text
                     mentions:(NSArray<SZMention *> *)mentions
{
    NSInteger rangeAdjustment = text.length - range.length;

    for (SZMention *mention in [SZMentionHelper mentionsAfterTextEntryForRange:range
                                                                    inMentions:mentions]) {
        [mention setRange:NSMakeRange(mention.range.location + rangeAdjustment,
                                      mention.range.length)];
    }
}

+ (BOOL)mentionExistsAtIndex:(NSInteger)index
                    mentions:(NSArray<SZMention *> *)mentions
{
    return [mentions filteredArrayUsingPredicate:
            [NSPredicate predicateWithBlock:^BOOL(SZMention *mention,
                                                  NSDictionary<NSString *,id> * _Nullable bindings) {
        return index >= mention.range.location && index < mention.range.location + mention.range.length;
    }]].count > 0;
}

+ (BOOL)needsToChangeToDefaultColorForRange:(NSRange)range
                                   textView:(UITextView *)textView
                                   mentions:(NSArray<SZMention *> *)mentions
{
    BOOL isAheadOfMention =
    (range.location > 0 &&
     [SZMentionHelper mentionExistsAtIndex:range.location - 1
                                  mentions:mentions]);
    BOOL isAtStartOfTextViewAndIsTouchingMention =
    (range.location == 0 && textView.text.length > 0 &&
     [SZMentionHelper mentionExistsAtIndex:range.location + 1
                                  mentions:mentions]);

    return (isAheadOfMention || isAtStartOfTextViewAndIsTouchingMention);
}

@end
