//
//  SZMentionsListener.m
//  SZMentions
//
//  Created by Steve Zweier on 12/17/15.
//  Copyright © 2015 Steven Zweier. All rights reserved.
//

#import "SZMentionsListener.h"
#import "SZMention.h"
#import "SZAttribute.h"
#import "SZMentionHelper.h"
#import "SZDefaultAttributes.h"
#import "SZAttributedStringHelper.h"

NSString * const attributeConsistencyError = @"Default and mention attributes must contain the same attribute names: If default attributes specify NSForegroundColorAttributeName mention attributes must specify that same name as well. (Values do not need to match)";

@interface SZMentionsListener ()

/**
 @brief Mutable array list of mentions managed by listener, accessible via the
 public mentions property.
 */
@property (nonatomic, strong) NSMutableArray *mutableMentions;

/**
 @brief Range of mention currently being edited.
 */
@property (nonatomic, assign) NSRange currentMentionRange;

/**
 @brief Whether or not we are currently editing a mention.
 */
@property (nonatomic, assign) BOOL editingMention;

/**
 @brief Allow us to edit text internally without triggering delegate
 */
@property (nonatomic, assign) BOOL settingText;

/**
 @brief String to filter by
 */
@property (nonatomic, strong) NSString *filterString;

/**
 @brief Timer to space out mentions requests
 */
@property (nonatomic, strong) NSTimer *cooldownTimer;

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
 @brief Amount of time to delay between showMentions calls default:0.5
 */
@property (nonatomic, assign) CGFloat cooldownInterval;

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
 @brief Whether or not we should add a space after the mention, default: NO
 */
@property (nonatomic, assign) BOOL spaceAfterMention;

@end

@implementation SZMentionsListener

#pragma mark - Initialization

- (instancetype)initWithTextView:(UITextView *)textView mentionsManager:(id<SZMentionsManagerProtocol>)mentionsManager
{
    return [self initWithTextView:textView
                  mentionsManager:mentionsManager
                 textViewDelegate:nil];
}

- (instancetype)initWithTextView:(UITextView *)textView mentionsManager:(id<SZMentionsManagerProtocol>)mentionsManager textViewDelegate:(id<UITextViewDelegate>)textViewDelegate
{
    return [self initWithTextView:textView
                  mentionsManager:mentionsManager
                 textViewDelegate:textViewDelegate
            defaultTextAttributes:[SZDefaultAttributes defaultTextAttributes]
            mentionTextAttributes:[SZDefaultAttributes defaultMentionAttributes]];
}

- (instancetype)initWithTextView:(UITextView *)textView mentionsManager:(id<SZMentionsManagerProtocol>)mentionsManager textViewDelegate:(id<UITextViewDelegate>)textViewDelegate defaultTextAttributes:(NSArray *)defaultTextAttributes mentionTextAttributes:(NSArray *)mentionTextAttributes
{
    return [self initWithTextView:textView
                  mentionsManager:mentionsManager
                 textViewDelegate:textViewDelegate
            defaultTextAttributes:defaultTextAttributes
            mentionTextAttributes:mentionTextAttributes
                   mentionTrigger:@"@"];
}

- (instancetype)initWithTextView:(UITextView *)textView mentionsManager:(id<SZMentionsManagerProtocol>)mentionsManager textViewDelegate:(id<UITextViewDelegate>)textViewDelegate defaultTextAttributes:(NSArray *)defaultTextAttributes mentionTextAttributes:(NSArray *)mentionTextAttributes mentionTrigger:(NSString *)mentionTrigger
{
    return [self initWithTextView:textView
                  mentionsManager:mentionsManager
                 textViewDelegate:textViewDelegate
            defaultTextAttributes:defaultTextAttributes
            mentionTextAttributes:mentionTextAttributes
                   mentionTrigger:mentionTrigger
                 cooldownInterval:0.5];
}

- (instancetype)initWithTextView:(UITextView *)textView mentionsManager:(id<SZMentionsManagerProtocol>)mentionsManager textViewDelegate:(id<UITextViewDelegate>)textViewDelegate defaultTextAttributes:(NSArray *)defaultTextAttributes mentionTextAttributes:(NSArray *)mentionTextAttributes mentionTrigger:(NSString *)mentionTrigger cooldownInterval:(CGFloat)cooldownInterval
{
    self = [super init];

    if (self) {
        _delegate = textViewDelegate;
        _mentionsManager = mentionsManager;
        _textView = textView;
        [_textView setDelegate:self];
        _trigger = mentionTrigger;
        _mutableMentions = @[].mutableCopy;

        NSArray *attributesToLoop = defaultTextAttributes.count >= mentionTextAttributes.count ?
        defaultTextAttributes :
        mentionTextAttributes;

        NSArray *attributesToCompare = defaultTextAttributes.count < mentionTextAttributes.count ?
        defaultTextAttributes :
        mentionTextAttributes;

        for (NSString *attributeName in [attributesToLoop valueForKey:@"attributeName"]) {
            NSAssert([[attributesToCompare valueForKey:@"attributeName"] containsObject:attributeName], attributeConsistencyError);
        }

        _defaultTextAttributes = defaultTextAttributes;
        _mentionTextAttributes = mentionTextAttributes;
        _cooldownInterval = cooldownInterval;
        [self setDefaultAttributesForTextView:_textView];
    }

    return self;
}

- (void)setDefaultAttributesForTextView:(UITextView *)textView
{
    [textView setText:@" "];
    NSMutableAttributedString *mutableAttributedString = textView.attributedText.mutableCopy;
    for (SZAttribute *attribute in _defaultTextAttributes) {
        [mutableAttributedString addAttribute:attribute.attributeName
                                        value:attribute.attributeValue
                                        range:NSMakeRange(0, 1)];
    }
    [textView setAttributedText:mutableAttributedString];
    [textView setText:@""];
}

- (void)resetEmptyTextView:(UITextView *)textView
                      text:(NSString *)text
                     range:(NSRange)range
{
    self.mutableMentions = @[].mutableCopy;
    [self setDefaultAttributesForTextView:textView];
}

#pragma mark - Textview delegate

- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    NSAssert([textView.delegate isEqual:self],
             @"Textview delegate must be set equal to %@", self);

    if ([self.delegate respondsToSelector:@selector(textView:
                                                    shouldChangeTextInRange:
                                                    replacementText:)]) {
        [self.delegate textView:textView
        shouldChangeTextInRange:range
                replacementText:text];
    }

    if (self.settingText) {
        return NO;
    }

    return [self _shouldAdjustTextView:textView range:range text:text];
}

- (BOOL)_shouldAdjustTextView:(UITextView *)textView
                        range:(NSRange)range
                         text:(NSString *)text
{
    if (textView.text.length == 0) {
        [self resetEmptyTextView:textView text:text range:range];
    }

    if ([SZMentionHelper _shouldHideMentionsForText:text]) {
        [self.mentionsManager hideMentionsList];
    }

    self.editingMention = NO;
    SZMention *editedMention = [self _mentionBeingEditedForRange:range];

    if (editedMention) {
        self.editingMention = YES;
        [self.mutableMentions removeObject:editedMention];
    }

    [SZMentionHelper _adjustMentionsInRange:range text:text mentions:self.mentions];

    if ([self.delegate respondsToSelector:@selector(textView:
                                                    shouldChangeTextInRange:
                                                    replacementText:)]) {
        [self.delegate textView:textView
        shouldChangeTextInRange:range
                replacementText:text];
    }

    if (self.editingMention) {
        return [self _handleEditingMention:editedMention
                                  textView:textView
                                     range:range
                                      text:text];
    }

    if ([SZMentionHelper _needsToChangeToDefaultColorForRange:range
                                                     textView:textView
                                                     mentions:self.mentions]) {
        return [self _forceDefaultColorForTextView:textView range:range text:text];
    }

    return YES;
}

- (BOOL)textView:(UITextView *)textView
shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment
         inRange:(NSRange)characterRange
{
    if ([self.delegate
         respondsToSelector:@selector(textView:
                                      shouldInteractWithTextAttachment:
                                      inRange:)]) {
             return [self.delegate textView:textView
           shouldInteractWithTextAttachment:textAttachment
                                    inRange:characterRange];
         }

    return YES;
}

- (BOOL)textView:(UITextView *)textView
shouldInteractWithURL:(NSURL *)URL
         inRange:(NSRange)characterRange
{
    if ([self.delegate respondsToSelector:@selector(textView:
                                                    shouldInteractWithURL:
                                                    inRange:)]) {
        return [self.delegate textView:textView
                 shouldInteractWithURL:URL
                               inRange:characterRange];
    }

    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(textViewDidBeginEditing:)]) {
        [self.delegate textViewDidBeginEditing:textView];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:textView];
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if (!self.editingMention) {
        [self _adjustTextView:textView text:@"" range:textView.selectedRange];

        if ([self.delegate
             respondsToSelector:@selector(textViewDidChangeSelection:)]) {
            [self.delegate textViewDidChangeSelection:textView];
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(textViewDidEndEditing:)]) {
        [self.delegate textViewDidEndEditing:textView];
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([self.delegate
         respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
        return [self.delegate textViewShouldBeginEditing:textView];
    }

    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(textViewShouldEndEditing:)]) {
        return [self.delegate textViewShouldEndEditing:textView];
    }

    return YES;
}

#pragma mark - Public methods

- (NSArray *)mentions
{
    return self.mutableMentions.copy;
}

- (void)addMention:(NSObject<SZCreateMentionProtocol> *)mention
{
    self.filterString = nil;
    NSString *displayName = mention.szMentionName;

    if (self.spaceAfterMention) {
        displayName = [displayName stringByAppendingString:@" "];
    }
    NSMutableAttributedString *mutableAttributedString =
    [self.textView.attributedText mutableCopy];
    [[mutableAttributedString mutableString]
     replaceCharactersInRange:self.currentMentionRange
     withString:displayName];

    [SZMentionHelper _adjustMentionsInRange:self.currentMentionRange
                                       text:displayName
                                   mentions:self.mentions];

    self.currentMentionRange = NSMakeRange(self.currentMentionRange.location,
                                           mention.szMentionName.length);

    [SZAttributedStringHelper _applyAttributes:self.mentionTextAttributes
                                         range:NSMakeRange(self.currentMentionRange.location,
                                                           self.currentMentionRange.length)
                       mutableAttributedString:mutableAttributedString];

    [SZAttributedStringHelper _applyAttributes:self.defaultTextAttributes
                                         range:NSMakeRange(self.currentMentionRange.location +
                                                           self.currentMentionRange.length -
                                                           1,
                                                           0)
                       mutableAttributedString:mutableAttributedString];

    self.settingText = YES;
    [self.textView setAttributedText:mutableAttributedString];

    NSRange selectedRange = NSMakeRange(self.currentMentionRange.location + self.currentMentionRange.length, 0);

    if (self.spaceAfterMention) {
        selectedRange.location++;
    }

    [self.textView setSelectedRange:selectedRange];
    self.settingText = NO;

    SZMention *szmention = [[SZMention alloc] init];
    [szmention setRange:self.currentMentionRange];
    [szmention setObject:mention];

    [self.mentionsManager hideMentionsList];
    [self.mutableMentions addObject:szmention];
}

#pragma mark - Private helpers

- (void)_adjustTextView:(UITextView *)textView
                   text:(NSString *)text
                  range:(NSRange)range
{
    NSString *substring = [textView.text substringToIndex:range.location];
    BOOL mentionEnabled = NO;
    NSUInteger location =
    [substring rangeOfString:self.trigger
                     options:NSBackwardsSearch].location;
    if (location != NSNotFound) {
        mentionEnabled = location == 0;

        if (location > 0) {
            NSRange substringRange = NSMakeRange(location - 1, 1);
            mentionEnabled =
            [[substring substringWithRange:substringRange] isEqualToString:@" "];
        }
    }

    NSArray *strings = [substring componentsSeparatedByString:@" "];

    if ([[strings lastObject] rangeOfString:self.trigger].location !=
        NSNotFound) {
        if (mentionEnabled) {
            self.currentMentionRange =
            [textView.text rangeOfString:[strings lastObject]
                                 options:NSBackwardsSearch];
            NSString *mentionString =
            [[strings lastObject] stringByAppendingString:text];
            self.filterString =
            [mentionString stringByReplacingOccurrencesOfString:self.trigger
                                                     withString:@""];

            if (self.filterString.length && !self.cooldownTimer.isValid) {
                [self.mentionsManager showMentionsListWithString:self.filterString];
            }
            [self activateCooldownTimer];

            return;
        }
    }
    [self.mentionsManager hideMentionsList];
}

- (SZMention *)_mentionBeingEditedForRange:(NSRange)range
{
    SZMention *editedMention;

    for (SZMention *mention in self.mentions) {
        NSRange currentMentionRange = mention.range;

        if (NSIntersectionRange(range, currentMentionRange).length > 0 ||
            (range.length == 0 && range.location > currentMentionRange.location &&
             range.location <
             currentMentionRange.length + currentMentionRange.location)) {
                editedMention = mention;
                break;
            }
    }

    return editedMention;
}

- (BOOL)_handleEditingMention:(SZMention *)mention
                     textView:(UITextView *)textView
                        range:(NSRange)range
                         text:(NSString *)text
{
    NSMutableAttributedString *mutableAttributedString =
    [textView.attributedText mutableCopy];

    [SZAttributedStringHelper _applyAttributes:self.defaultTextAttributes
                                         range:mention.range
                       mutableAttributedString:mutableAttributedString];

    [[mutableAttributedString mutableString] replaceCharactersInRange:range
                                                           withString:text];
    self.settingText = YES;
    [textView setAttributedText:mutableAttributedString];
    self.settingText = NO;
    [textView setSelectedRange:NSMakeRange(range.location + text.length, 0)];

    if ([self.delegate respondsToSelector:@selector(textView:
                                                    shouldChangeTextInRange:
                                                    replacementText:)]) {
        [self.delegate textView:textView
        shouldChangeTextInRange:range
                replacementText:text];
    }

    return NO;
}

- (BOOL)_forceDefaultColorForTextView:(UITextView *)textView
                                range:(NSRange)range
                                 text:(NSString *)text
{
    NSMutableAttributedString *mutableAttributedString =
    [textView.attributedText mutableCopy];
    [[mutableAttributedString mutableString] replaceCharactersInRange:range
                                                           withString:text];

    [SZAttributedStringHelper _applyAttributes:self.defaultTextAttributes
                                         range:NSMakeRange(range.location, text.length)
                       mutableAttributedString:mutableAttributedString];

    self.settingText = YES;
    [textView setAttributedText:mutableAttributedString];
    self.settingText = NO;

    NSRange newRange = NSMakeRange(range.location, 0);

    if (newRange.length <= 0) {
        newRange.location = range.location + text.length;
    }

    [textView setSelectedRange:newRange];

    return NO;
}

- (void)cooldownTimerFired:(NSTimer *)timer
{
    if (self.filterString.length) {
        [self.mentionsManager showMentionsListWithString:self.filterString];
    }
}

- (void)activateCooldownTimer
{
    [self.cooldownTimer invalidate];
    // Add and activate the timer
    NSTimer *timer = [NSTimer timerWithTimeInterval:self.cooldownInterval

                                             target:self
                                           selector:@selector(cooldownTimerFired:)
                                           userInfo:nil
                                            repeats:NO];
    self.cooldownTimer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

@end