//
//  SZExampleInsertMention.h
//  SZMentionsExample
//
//  Created by Steven Zweier on 3/15/16.
//  Copyright © 2016 Steven Zweier. All rights reserved.
//

#import <SZMentions/SZMentionsListener.h>
#import <Foundation/Foundation.h>

@interface SZExampleInsertMention : NSObject<SZInsertMentionProtocol>
/**
 @brief Range to place mention at
 */
@property (nonatomic, assign) NSRange szMentionRange;

@end
