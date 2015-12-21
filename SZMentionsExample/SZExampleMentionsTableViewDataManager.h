//
//  SZExampleMentionsTableViewDataManager.h
//  SZMentionsExample
//
//  Created by Steve Zweier on 12/20/15.
//  Copyright © 2015 Steven Zweier. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SZMentionsListener;

@interface SZExampleMentionsTableViewDataManager : UITableView <UITableViewDataSource, UITableViewDelegate>

- (instancetype)initWithTableView:(UITableView *)tableView
                 mentionsListener:(SZMentionsListener *)mentionsListener;
- (void)filterWithString:(NSString *)filterString;

@end
