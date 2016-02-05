//
//  SZMentionsTests.m
//  SZMentionsTests
//
//  Created by Steve Zweier on 12/20/15.
//  Copyright © 2015 Steven Zweier. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SZMentionsListener.h"
#import "SZAttribute.h"

@interface SZExampleMention : NSObject<SZCreateMentionProtocol>

@property (nonatomic, strong) NSString *szMentionName;

@end

@implementation SZExampleMention

@end

@interface SZMentionsTests : XCTestCase <SZMentionsManagerProtocol, UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) SZMentionsListener *mentionsListener;
@property (nonatomic, assign) BOOL hidingMentionsList;
@property (nonatomic, strong) NSString *mentionString;

@end

@implementation SZMentionsTests

- (void)setUp {
    [super setUp];
    self.hidingMentionsList = YES;
    self.mentionString = @"";
    self.textView = [[UITextView alloc] init];
    SZAttribute *attribute = [[SZAttribute alloc] init];
    [attribute setAttributeName:NSForegroundColorAttributeName];
    [attribute setAttributeValue:[UIColor blackColor]];

    SZAttribute *attribute2 = [[SZAttribute alloc] init];
    [attribute2 setAttributeName:NSForegroundColorAttributeName];
    [attribute2 setAttributeValue:[UIColor redColor]];

    self.mentionsListener = [[SZMentionsListener alloc] initWithTextView:self.textView
                                                         mentionsManager:self
                                                        textViewDelegate:self
                                                   defaultTextAttributes:@[attribute]
                                                   mentionTextAttributes:@[attribute2]];
}

- (void)hideMentionsList
{
    self.hidingMentionsList = YES;
}

- (void)showMentionsListWithString:(NSString *)mentionString
{
    self.hidingMentionsList = NO;
    self.mentionString = mentionString;
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testThatAddingAttributesThatDoNotMatchThrowsAnError
{
    SZAttribute *attribute = [[SZAttribute alloc] init];
    [attribute setAttributeName:NSForegroundColorAttributeName];
    [attribute setAttributeValue:[UIColor redColor]];

    SZAttribute *attribute2 = [[SZAttribute alloc] init];
    [attribute2 setAttributeName:NSBackgroundColorAttributeName];
    [attribute2 setAttributeValue:[UIColor blackColor]];

    NSArray *defaultAttributes = @[attribute];
    NSArray *mentionAttributes = @[attribute, attribute2];

    XCTAssertThrowsSpecificNamed([[SZMentionsListener alloc] initWithTextView:self.textView
                                                              mentionsManager:self
                                                             textViewDelegate:nil
                                                        defaultTextAttributes:defaultAttributes
                                                        mentionTextAttributes:mentionAttributes],
                                 NSException,
                                 NSInternalInconsistencyException,
                                 @"Default and mention attributes must contain the same attribute names: If default attributes specify NSForegroundColorAttributeName mention attributes must specify that same name as well. (Values do not need to match)");
}

- (void)testThatAddingAttributesThatDoMatchDoesNotThrowsAnError
{
    SZAttribute *attribute = [[SZAttribute alloc] init];
    [attribute setAttributeName:NSForegroundColorAttributeName];
    [attribute setAttributeValue:[UIColor redColor]];

    SZAttribute *attribute2 = [[SZAttribute alloc] init];
    [attribute2 setAttributeName:NSBackgroundColorAttributeName];
    [attribute2 setAttributeValue:[UIColor blackColor]];

    NSArray *defaultAttributes = @[attribute, attribute2];
    NSArray *mentionAttributes = @[attribute2, attribute];

    XCTAssertNoThrowSpecificNamed([[SZMentionsListener alloc] initWithTextView:self.textView
                                                               mentionsManager:self
                                                              textViewDelegate:nil
                                                         defaultTextAttributes:defaultAttributes
                                                         mentionTextAttributes:mentionAttributes],
                                  NSException,
                                  NSInternalInconsistencyException,
                                  @"Default and mention attributes must contain the same attribute names: If default attributes specify NSForegroundColorAttributeName mention attributes must specify that same name as well. (Values do not need to match)");
}

- (void)testMentionListIsDisplayed
{
    [self.textView insertText:@"@t"];

    XCTAssertEqual(self.hidingMentionsList, NO);
}

- (void)testMentionListIsHidden
{
    [self.textView insertText:@"@t"];

    XCTAssertEqual(self.hidingMentionsList, NO);

    [self.textView insertText:@" "];

    XCTAssertEqual(self.hidingMentionsList, YES);
}

- (void)testMentionIsAdded
{
    [self.textView insertText:@"@t"];

    SZExampleMention *mention = [[SZExampleMention alloc] init];
    [mention setSzMentionName:@"Steven"];

    [self.mentionsListener addMention:mention];

    XCTAssertTrue([self.mentionsListener mentions].count == 1);
}

- (void)testMentionPositionIsCorrectToStartText
{
    [self.textView insertText:@"@t"];
    SZExampleMention *mention = [[SZExampleMention alloc] init];
    [mention setSzMentionName:@"Steven"];

    [self.mentionsListener addMention:mention];

    XCTAssertTrue([[self.mentionsListener mentions][0] range].location == 0);
}

- (void)testMentionPositionIsCorrectInTheMidstOfText
{
    [self.textView insertText:@"Testing @t"];
    SZExampleMention *mention = [[SZExampleMention alloc] init];
    [mention setSzMentionName:@"Steven Zweier"];

    [self.mentionsListener addMention:mention];

    XCTAssertTrue([[self.mentionsListener mentions][0] range].location == 8);
}

- (void)testMentionLengthIsCorrect
{
    [self.textView insertText:@"@t"];
    SZExampleMention *mention = [[SZExampleMention alloc] init];
    [mention setSzMentionName:@"Steven"];

    [self.mentionsListener addMention:mention];

    XCTAssertTrue([[self.mentionsListener mentions][0] range].length == 6);

    [self.textView insertText:@"Testing @t"];
    mention = [[SZExampleMention alloc] init];
    [mention setSzMentionName:@"Steven Zweier"];

    [self.mentionsListener addMention:mention];

    XCTAssertTrue([[self.mentionsListener mentions][1] range].length == 13);
}

- (void)testMentionLocationIsAdjustedProperly
{
    [self.textView insertText:@"Testing @t"];
    SZExampleMention *mention = [[SZExampleMention alloc] init];
    [mention setSzMentionName:@"Steven"];

    [self.mentionsListener addMention:mention];

    XCTAssertTrue([[self.mentionsListener mentions][0] range].location == 8);

    UITextPosition *beginning = self.textView.beginningOfDocument;
    UITextPosition *start = [self.textView positionFromPosition:beginning offset:0];
    UITextPosition *end = [self.textView positionFromPosition:start offset:3];

    UITextRange *textRange = [self.textView textRangeFromPosition:start toPosition:end];

    if ([self.mentionsListener textView:self.textView
                shouldChangeTextInRange:NSMakeRange(0, 3)
                        replacementText:@""]) {
        [self.textView replaceRange:textRange withText:@""];
    }

    XCTAssertTrue([[self.mentionsListener mentions][0] range].location == 5);

    beginning = self.textView.beginningOfDocument;
    start = [self.textView positionFromPosition:beginning offset:0];
    end = [self.textView positionFromPosition:start offset:5];

    textRange = [self.textView textRangeFromPosition:start toPosition:end];

    if ([self.mentionsListener textView:self.textView
                shouldChangeTextInRange:NSMakeRange(0, 5)
                        replacementText:@""]) {
        [self.textView replaceRange:textRange withText:@""];
    }

    XCTAssertTrue([[self.mentionsListener mentions][0] range].location == 0);
}

- (void)testMentionLocationIsAdjustedProperlyWhenAMentionIsInsertsBehindAMentionSpaceAfterMentionIsFalse
{
    [self.textView insertText:@"@t"];
    SZExampleMention *mention = [[SZExampleMention alloc] init];
    [mention setSzMentionName:@"Steven"];

    [self.mentionsListener addMention:mention];

    XCTAssertTrue([self.mentionsListener.mentions[0] range].location == 0);
    XCTAssertTrue([self.mentionsListener.mentions[0] range].length == 6);

    self.textView.selectedRange = NSMakeRange(0, 0);

    if ([self.mentionsListener textView:self.textView shouldChangeTextInRange:NSMakeRange(0, 0) replacementText:@"@t"]) {
        [self.textView insertText:@"@t"];
    }
    mention = [[SZExampleMention alloc] init];
    [mention setSzMentionName:@"Steven Zweier"];
    [self.mentionsListener addMention:mention];

    XCTAssertTrue([self.mentionsListener.mentions[1] range].location == 0);
    XCTAssertTrue([self.mentionsListener.mentions[1] range].length == 13);
    XCTAssertTrue([self.mentionsListener.mentions[0] range].location == 13);
}

- (void)testMentionLocationIsAdjustedProperlyWhenAMentionIsInsertsBehindAMentionSpaceAfterMentionIsTrue
{
    [self.mentionsListener setValue:@YES forKey:@"spaceAfterMention"];
    [self.textView insertText:@"@t"];
    SZExampleMention *mention = [[SZExampleMention alloc] init];
    [mention setSzMentionName:@"Steven"];

    [self.mentionsListener addMention:mention];

    XCTAssertTrue([self.mentionsListener.mentions[0] range].location == 0);
    XCTAssertTrue([self.mentionsListener.mentions[0] range].length == 6);

    self.textView.selectedRange = NSMakeRange(0, 0);

    if ([self.mentionsListener textView:self.textView shouldChangeTextInRange:NSMakeRange(0, 0) replacementText:@"@t"]) {
        [self.textView insertText:@"@t"];
    }
    mention = [[SZExampleMention alloc] init];
    [mention setSzMentionName:@"Steven Zweier"];
    [self.mentionsListener addMention:mention];

    XCTAssertTrue([self.mentionsListener.mentions[1] range].location == 0);
    XCTAssertTrue([self.mentionsListener.mentions[1] range].length == 13);
    XCTAssertTrue([self.mentionsListener.mentions[0] range].location == 14);
}

- (void)testEditingTheMiddleOfTheMentionRemovesTheMention
{
    [self.textView insertText:@"Testing @t"];
    SZExampleMention *mention = [[SZExampleMention alloc] init];
    [mention setSzMentionName:@"Steven"];

    [self.mentionsListener addMention:mention];

    XCTAssertTrue([self.mentionsListener mentions].count == 1);

    [self.textView setSelectedRange:NSMakeRange(11, 1)];

    if ([self.mentionsListener textView:self.textView
                shouldChangeTextInRange:self.textView.selectedRange
                        replacementText:@""]) {
        [self.textView deleteBackward];
    }

    XCTAssertTrue([self.mentionsListener mentions].count == 0);
}

- (void)testEditingTheEndOfTheMentionRemovesTheMention
{
    [self.textView insertText:@"Testing @t"];
    SZExampleMention *mention = [[SZExampleMention alloc] init];
    [mention setSzMentionName:@"Steven"];

    [self.mentionsListener addMention:mention];

    XCTAssertTrue([self.mentionsListener mentions].count == 1);

    [self.textView setSelectedRange:NSMakeRange(13, 1)];

    if ([self.mentionsListener textView:self.textView
                shouldChangeTextInRange:self.textView.selectedRange
                        replacementText:@""]) {
        [self.textView deleteBackward];
    }

    XCTAssertTrue([self.mentionsListener mentions].count == 0);
}

- (void)testEditingAfterTheMentionDoesNotDeleteTheMention
{
    [self.textView insertText:@"Testing @t"];
    SZExampleMention *mention = [[SZExampleMention alloc] init];
    [mention setSzMentionName:@"Steven"];

    [self.mentionsListener addMention:mention];

    [self.textView insertText:@" "];

    XCTAssertTrue([self.mentionsListener mentions].count == 1);

    [self.textView setSelectedRange:NSMakeRange(14, 1)];

    if ([self.mentionsListener textView:self.textView
                shouldChangeTextInRange:self.textView.selectedRange
                        replacementText:@""]) {
        [self.textView deleteBackward];
    }

    XCTAssertTrue([self.mentionsListener mentions].count == 1);
}

- (void)testPastingTextBeforeLeadingMentionResetsAttributes
{
    [self.textView insertText:@"@s"];
    SZExampleMention *mention = [[SZExampleMention alloc] init];
    [mention setSzMentionName:@"Steven"];
    [self.mentionsListener addMention:mention];
    self.textView.selectedRange = NSMakeRange(0, 0);
    if ([self.mentionsListener textView:self.textView shouldChangeTextInRange:self.textView.selectedRange replacementText:@"test"]) {
        [self.textView insertText:@"test"];
    }
    XCTAssert([[self.textView.attributedText attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:nil] isEqual:UIColor.blackColor]);
}

@end
