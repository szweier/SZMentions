//
//  SZMentionsListener.h
//  SZMentions
//
//  Created by Steve Zweier on 12/17/15.
//  Copyright © 2015 Steven Zweier. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SZMentionsManagerProtocol <NSObject>
@required

/**
 @brief Called when the UITextView is editing a mention.

 @param MentionString the current text entered after the mention trigger.
 Generally used for filtering a mentions list.
 */
- (void)showMentionsListWithString:(NSString *)mentionString;

/**
 @brief Called when the UITextView is not editing a mention.
 */
- (void)hideMentionsList;

@end

@protocol SZCreateMentionProtocol <NSObject>
@required

/**
 @brief The name of the mention to be added to the UITextView when selected.
 */
@property (nonatomic, strong) NSString *szMentionName;

@end

@interface SZMentionsListener : NSObject <UITextViewDelegate>

/**
 @brief Trigger to start a mention. Default: @
 */
@property (nonatomic, strong) NSString *trigger;
/**
 @brief Text attributes to be applied to all text excluding mentions.
 */
@property (nonatomic, strong) NSArray *defaultTextAttributes;

/**
 @brief Text attributes to be applied to mentions.
 */
@property (nonatomic, strong) NSArray *mentionTextAttributes;

/**
 @brief The UITextView being handled by the SZMentionsListener
 */
@property (nonatomic, weak) UITextView *textView;

/**
 @brief An optional delegate that can be used to handle all UITextView delegate
 methods after they've been handled by the SZMentionsListener
 */
@property (nonatomic, weak) id<UITextViewDelegate> delegate;

/**
 @brief Manager in charge of handling the creation and dismissal of the mentions
 list.
 */
@property (nonatomic, weak) id<SZMentionsManagerProtocol> mentionsManager;

/**
 @brief Array of mentions currently added to the textview
 */
@property (nonatomic, readonly) NSArray *mentions;

/**
 @brief Amount of time to delay between showMentions calls default:0.5
 */
@property (nonatomic, assign) CGFloat cooldownInterval;

/**
 @brief Whether or not we should add a space after the mention, default: NO
 */
@property (nonatomic, assign) BOOL spaceAfterMention;

/**
 @brief Add mention object to current string being edited

 @param mention the mention object adhereing to SZCreateMentionProtocol
 szMentionName is used as the name to set for the mention.  This parameter
 is returned in the mentions array in the object parameter of the SZMention object.
 */
- (void)addMention:(NSObject<SZCreateMentionProtocol> *)mention;

@end