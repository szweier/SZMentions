//
//  SZExampleViewController.m
//  SZMentions
//
//  Created by Steve Zweier on 12/18/15.
//  Copyright © 2015 Steven Zweier. All rights reserved.
//

#import "SZExampleViewController.h"
#import "SZExampleAccessoryView.h"

@interface SZExampleViewController () <UITextFieldDelegate>

/**
 @brief Custom input accessory view for display
 */
@property (nonatomic, strong) UIView *myInputAccessoryView;

@end

@implementation SZExampleViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

#pragma mark - Custom input accessory view

- (UIView *)myInputAccessoryView
{
    if (!_myInputAccessoryView) {
        CGRect frame = CGRectMake(0,
                                  0,
                                  self.view.frame.size.width,
                                  40);
        _myInputAccessoryView = [[SZExampleAccessoryView alloc] initWithFrame:frame
                                                                     delegate:self];
    }
    
    return _myInputAccessoryView;
}

#pragma mark - Input accessory view method

- (UIView *)inputAccessoryView
{
    return self.myInputAccessoryView;
}

#pragma mark - First responder

- (BOOL)canBecomeFirstResponder
{
    return YES;
}



@end