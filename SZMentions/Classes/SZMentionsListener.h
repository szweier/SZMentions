//
//  SZMentionsListener.h
//  SZMentions
//
//  Created by Steve Zweier on 12/17/15.
//  Copyright © 2015 Steven Zweier. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SZAttribute;
@class SZMention;

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

@optional
/**
 @brief The range to place the mention at (optional: if not set mention will be added to the current range being edited)
 */
@property (nonatomic, assign) NSRange szMentionRange;

@end

@interface SZMentionsListener : NSObject <UITextViewDelegate>

/**
 @brief Array of mentions currently added to the textview
 */
@property (nonatomic, readonly) NSArray<SZMention *> *mentions;

/**
 @brief Insert mentions into an existing textview.  This is provided assuming you are given text
 along with a list of users mentioned in that text and want to prep the textview in advance.

 @param mention the mention object adhereing to SZInsertMentionProtocol
 szMentionName is used as the name to set for the mention.  This parameter
 is returned in the mentions array in the object parameter of the SZMention object.
 szMentionRange is used the range to place the metion at
 */
- (void)insertExistingMentions:(NSArray<id <SZCreateMentionProtocol>> *)mentions;

/**
 @brief Add mention object to current string being edited

 @param mention the mention object adhereing to SZCreateMentionProtocol
 szMentionName is used as the name to set for the mention.  This parameter
 is returned in the mentions array in the object parameter of the SZMention object.
 */
- (void)addMention:(NSObject<SZCreateMentionProtocol> *)mention;

/**
 @brief Initializer that allows you to set textview and mentions manager
 @param textView: - the text view to manage mentions for
 @param mentionsManager: - the object that will handle showing and hiding of the mentions picker
 */
- (instancetype)initWithTextView:(UITextView *)textView
                 mentionsManager:(id<SZMentionsManagerProtocol>)mentionsManager;

/**
 @brief Initializer that allows you to set textview and mentions manager
 @param textView: - the text view to manage mentions for
 @param mentionsManager: - the object that will handle showing and hiding of the mentions picker
 @param textViewDelegate: - the object that will handle textview delegate methods
 */
- (instancetype)initWithTextView:(UITextView *)textView
                 mentionsManager:(id<SZMentionsManagerProtocol>)mentionsManager
                textViewDelegate:(id<UITextViewDelegate>)textViewDelegate;

/**
 @brief Initializer that allows for customization of text attributes for default text and mentions
 @param textView: - the text view to manage mentions for
 @param mentionsManager: - the object that will handle showing and hiding of the mentions picker
 @param textViewDelegate: - the object that will handle textview delegate methods
 @param defaultTextAttributes - text style to show for default text
 @param mentionTextAttributes - text style to show for mentions
 */
- (instancetype)initWithTextView:(UITextView *)textView
                 mentionsManager:(id<SZMentionsManagerProtocol>)mentionsManager
                textViewDelegate:(id<UITextViewDelegate>)textViewDelegate
           defaultTextAttributes:(NSArray<SZAttribute *> *)defaultTextAttributes
           mentionTextAttributes:(NSArray<SZAttribute *> *)mentionTextAttributes;

/**
 @brief Initializer that allows for customization of text attributes for default text and mentions
 @param textView: - the text view to manage mentions for
 @param mentionsManager: - the object that will handle showing and hiding of the mentions picker
 @param textViewDelegate: - the object that will handle textview delegate methods
 @param defaultTextAttributes - text style to show for default text
 @param mentionTextAttributes - text style to show for mentions
 @param spaceAfterMention - whether or not to add a space after adding a mention
 */
- (instancetype)initWithTextView:(UITextView *)textView
                 mentionsManager:(id<SZMentionsManagerProtocol>)mentionsManager
                textViewDelegate:(id<UITextViewDelegate>)textViewDelegate
           defaultTextAttributes:(NSArray<SZAttribute *> *)defaultTextAttributes
           mentionTextAttributes:(NSArray<SZAttribute *> *)mentionTextAttributes
               spaceAfterMention:(BOOL)spaceAfterMention;

/**
 @brief Initializer that allows for customization of text attributes for default text and mentions
 @param textView: - the text view to manage mentions for
 @param mentionsManager: - the object that will handle showing and hiding of the mentions picker
 @param textViewDelegate: - the object that will handle textview delegate methods
 @param defaultTextAttributes - text style to show for default text
 @param mentionTextAttributes - text style to show for mentions
 @param spaceAfterMention - whether or not to add a space after adding a mention
 @param mentionTrigger - what text triggers showing the mentions list
 */
- (instancetype)initWithTextView:(UITextView *)textView
                 mentionsManager:(id<SZMentionsManagerProtocol>)mentionsManager
                textViewDelegate:(id<UITextViewDelegate>)textViewDelegate
           defaultTextAttributes:(NSArray<SZAttribute *> *)defaultTextAttributes
           mentionTextAttributes:(NSArray<SZAttribute *> *)mentionTextAttributes
               spaceAfterMention:(BOOL)spaceAfterMention
                  mentionTrigger:(NSString *)mentionTrigger;

/**
 @brief Initializer that allows for customization of text attributes for default text and mentions
 @param textView: - the text view to manage mentions for
 @param mentionsManager: - the object that will handle showing and hiding of the mentions picker
 @param textViewDelegate: - the object that will handle textview delegate methods
 @param defaultTextAttributes - text style to show for default text
 @param mentionTextAttributes - text style to show for mentions
 @param spaceAfterMention - whether or not to add a space after adding a mention
 @param mentionTrigger - what text triggers showing the mentions list
 @param cooldownInterval - amount of time between show / hide mentions calls
 */
- (instancetype)initWithTextView:(UITextView *)textView
                 mentionsManager:(id<SZMentionsManagerProtocol>)mentionsManager
                textViewDelegate:(id<UITextViewDelegate>)textViewDelegate
           defaultTextAttributes:(NSArray<SZAttribute *> *)defaultTextAttributes
           mentionTextAttributes:(NSArray<SZAttribute *> *)mentionTextAttributes
               spaceAfterMention:(BOOL)spaceAfterMention
                  mentionTrigger:(NSString *)mentionTrigger
                cooldownInterval:(CGFloat)cooldownInterval;

@end