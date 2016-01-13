//
//  SZExampleMentionsTableViewDataManager.m
//  SZMentionsExample
//
//  Created by Steve Zweier on 12/20/15.
//  Copyright © 2015 Steven Zweier. All rights reserved.
//

#import "SZExampleMentionsTableViewDataManager.h"
#import "SZExampleMention.h"

@interface SZExampleMentionsTableViewDataManager ()

@property (nonatomic, strong) SZMentionsListener *mentionsListener;
@property (nonatomic, strong) NSArray *mentionsList;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *filterString;

@end

@implementation SZExampleMentionsTableViewDataManager

- (instancetype)initWithTableView:(UITableView *)tableView
                 mentionsListener:(SZMentionsListener *)mentionsListener
{
    self = [super init];

    if (self) {
        _tableView = tableView;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        _mentionsListener = mentionsListener;
    }

    return self;
}

- (NSArray *)mentionsList
{
    if (!_mentionsList) {
        NSArray *names = @[
            @"Steven Zweier",
            @"Professor Belly Button",
            @"Turtle Paper"
        ];

        NSMutableArray *tempMentions = @[].mutableCopy;

        for (NSString *name in names) {
            SZExampleMention *mention = [[SZExampleMention alloc] init];
            [mention setSzMentionName:name];
            [tempMentions addObject:mention];
        }

        _mentionsList = tempMentions.copy;
    }

    if (self.filterString.length) {
        return [_mentionsList filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(SZExampleMention *mention,
                                                                                                NSDictionary<NSString *, id> *_Nullable bindings) {
                                  return [[mention.szMentionName lowercaseString] rangeOfString:[self.filterString lowercaseString]].location != NSNotFound;
                              }]];
    }

    return _mentionsList;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mentionsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    [cell.textLabel setText:[self.mentionsList[indexPath.row] szMentionName]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.mentionsListener addMention:self.mentionsList[indexPath.row]];
}

- (void)filterWithString:(NSString *)filterString
{
    self.filterString = filterString;
    [self.tableView reloadData];
}

@end
