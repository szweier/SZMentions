//
//  SZMentionHelper.h
//  SZMentions
//
//  Created by Steve Zweier on 2/1/16.
//  Copyright © 2016 Steven Zweier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZMentionHelper : NSObject

+ (NSArray *)_mentionsAfterTextEntryForRange:(NSRange)range inMentions:(NSArray *)mentionsList;
+ (void)_adjustMentionsInRange:(NSRange)range text:(NSString *)text mentions:(NSArray *)mentions;
+ (BOOL)_mentionExistsAtIndex:(NSInteger)index mentions:(NSArray *)mentions;
+ (BOOL)_needsToChangeToDefaultColorForRange:(NSRange)range textView:(UITextView *)textView mentions:(NSArray *)mentions;
+ (BOOL)_shouldHideMentionsForText:(NSString *)text;

@end
