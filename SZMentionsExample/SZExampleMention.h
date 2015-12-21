//
//  SZExampleMention.h
//  SZMentions
//
//  Created by Steve Zweier on 12/18/15.
//  Copyright © 2015 Steven Zweier. All rights reserved.
//

#import <SZMentions/SZMentionsListener.h>
#import <Foundation/Foundation.h>

@interface SZExampleMention : NSObject <SZCreateMentionProtocol>

/**
 @brief Name of the mention for display
 */
@property (nonatomic, strong) NSString *szMentionName;

@end