//
//  SZExampleAccessoryView.m
//  SZMentions
//
//  Created by Steve Zweier on 12/17/15.
//  Copyright © 2015 Steven Zweier. All rights reserved.
//

#import "SZExampleAccessoryView.h"
#import <SZMentions/SZMentionsListener.h>
#import "SZExampleMention.h"
#import <SZMentions/SZAttribute.h>
#import "SZExampleMentionsTableViewDataManager.h"

@interface SZExampleAccessoryView () <UITextViewDelegate, SZMentionsManagerProtocol>

@property (nonatomic, strong) SZMentionsListener *mentionsListener;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UITableView *mentionsTableView;
@property (nonatomic, strong) NSArray *verticalConstraints;

/**
 @brief Example data manager showing mentions and adding them to the textview
 */
@property (nonatomic, strong) SZExampleMentionsTableViewDataManager *dataManager;

@end

@implementation SZExampleAccessoryView

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate
{
    self = [super initWithFrame:frame];

    if (self) {
        [self setupViewWithDelegate:delegate];
    }

    return self;
}

#pragma mark - Setup

- (void)setupViewWithDelegate:(id)delegate
{
    [self setBackgroundColor:[UIColor grayColor]];
    [self.mentionsListener setDelegate:delegate];
    [self.mentionsListener setTextView:self.textView];
}

#pragma mark - Textview attributes

- (NSArray *)defaultAttributes
{
    NSMutableArray *defaultAttributes = @[].mutableCopy;

    SZAttribute *attribute = [[SZAttribute alloc] init];
    [attribute setAttributeName:NSForegroundColorAttributeName];
    [attribute setAttributeValue:[UIColor grayColor]];

    [defaultAttributes addObject:attribute];

    attribute = [[SZAttribute alloc] init];
    [attribute setAttributeName:NSBackgroundColorAttributeName];
    [attribute setAttributeValue:[UIColor whiteColor]];

    [defaultAttributes addObject:attribute];

    attribute = [[SZAttribute alloc] init];
    [attribute setAttributeName:NSFontAttributeName];
    [attribute setAttributeValue:[UIFont fontWithName:@"ArialMT"
                                                 size:12]];

    [defaultAttributes addObject:attribute];

    return defaultAttributes.copy;
}

- (NSArray *)mentionAttributes
{
    NSMutableArray *mentionAttributes = @[].mutableCopy;

    SZAttribute *attribute = [[SZAttribute alloc] init];
    [attribute setAttributeName:NSForegroundColorAttributeName];
    [attribute setAttributeValue:[UIColor blackColor]];

    [mentionAttributes addObject:attribute];

    attribute = [[SZAttribute alloc] init];
    [attribute setAttributeName:NSFontAttributeName];
    [attribute setAttributeValue:[UIFont fontWithName:@"ChalkboardSE-Bold"
                                                 size:12]];

    [mentionAttributes addObject:attribute];

    attribute = [[SZAttribute alloc] init];
    [attribute setAttributeName:NSBackgroundColorAttributeName];
    [attribute setAttributeValue:[UIColor lightGrayColor]];

    [mentionAttributes addObject:attribute];

    return mentionAttributes.copy;
}

#pragma mark - SZMentionsListener

- (SZMentionsListener *)mentionsListener
{
    if (!_mentionsListener) {
        _mentionsListener = [[SZMentionsListener alloc] init];
        [_mentionsListener setMentionsManager:self];
        [_mentionsListener setDefaultTextAttributes:[self defaultAttributes]];
        [_mentionsListener setMentionTextAttributes:[self mentionAttributes]];
    }

    return _mentionsListener;
}

#pragma mark - UITextView

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        [_textView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_textView setDelegate:self.mentionsListener];
        [self addSubview:self.textView];
        [self removeConstraints:self.constraints];
        [self addConstraints:
                  [NSLayoutConstraint constraintsWithVisualFormat:@"|-5-[textview]-5-|"
                                                          options:0
                                                          metrics:nil
                                                            views:@{
                                                                @"textview": self.textView
                                                            }]];
        self.verticalConstraints =
            [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[textview(30)]-5-|"
                                                    options:0
                                                    metrics:nil
                                                      views:@{
                                                          @"textview": self.textView
                                                      }];
        [self addConstraints:self.verticalConstraints];
    }

    return _textView;
}

#pragma mark - Mentions UITableView

- (UITableView *)mentionsTableView
{
    if (!_mentionsTableView) {
        _mentionsTableView = [[UITableView alloc] init];
        [_mentionsTableView setBackgroundColor:[UIColor blueColor]];

        self.dataManager = [[SZExampleMentionsTableViewDataManager alloc] initWithTableView:_mentionsTableView
                                                                           mentionsListener:self.mentionsListener];
        [_mentionsTableView setDelegate:self.dataManager];
        [_mentionsTableView setDataSource:self.dataManager];
    }

    return _mentionsTableView;
}

#pragma mark - SZMentionsManagerProtocol

- (void)showMentionsListWithString:(NSString *)mentionString
{
    if (!self.mentionsTableView.superview) {
        [self addSubview:self.mentionsTableView];
        [self removeConstraints:self.constraints];
        [self.mentionsTableView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraints:
                  [NSLayoutConstraint constraintsWithVisualFormat:@"|-5-[tableview]-5-|"
                                                          options:0
                                                          metrics:nil
                                                            views:@{
                                                                @"tableview": self.mentionsTableView
                                                            }]];
        [self addConstraints:
                  [NSLayoutConstraint constraintsWithVisualFormat:@"|-5-[textview]-5-|"
                                                          options:0
                                                          metrics:nil
                                                            views:@{
                                                                @"textview": self.textView
                                                            }]];
        self.verticalConstraints =
            [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[tableview(100)][textview(30)]-5-|"
                                                    options:0
                                                    metrics:nil
                                                      views:@{
                                                          @"tableview": self.mentionsTableView,
                                                          @"textview": self.textView
                                                      }];
        [self addConstraints:self.verticalConstraints];
    }

    [self.dataManager filterWithString:mentionString];
}

- (void)hideMentionsList
{
    [self.mentionsTableView removeFromSuperview];
    self.verticalConstraints =
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[textview(30)]-5-|"
                                                options:0
                                                metrics:nil
                                                  views:@{
                                                      @"textview": self.textView
                                                  }];
    [self addConstraints:self.verticalConstraints];

    [self.dataManager filterWithString:nil];
}

@end