//
//  SZAttribute.h
//  SZMentions
//
//  Created by Steve Zweier on 12/19/15.
//  Copyright © 2015 Steven Zweier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZAttribute : NSObject

/**
 @brief Name of the attribute to set on a string
 */
@property (nonatomic, readonly) NSString *attributeName;

/**
 @brief Value of the attribute to set on a string
 */
@property (nonatomic, readonly) NSObject *attributeValue;

/**
 @brief initializer for creating an attribute
 @param attributeName: the name of the attribute (example: NSForegroundColorAttributeName)
 @param attributeValue: the value for the given attribute (example: [UIColor redColor])
 */
- (instancetype)initWithAttributeName:(NSString *)attributeName
                       attributeValue:(NSObject *)attributeValue;

@end