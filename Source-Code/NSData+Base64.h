//
//  NSData+Base64.h
//  CreditCard
//
//  Created by Kamil Wasąg on 10/3/12.
//  Copyright (c) 2012 Kamil Wasąg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSData(Base64)

//@property (readonly, nonatomic) NSString *base64Characters;

/**
 @brief function that return NSData that contain bytes decoded from base64 encoded NSString
 @param string base64 encoded NSString that wiil be decoded to NSData;
 @return NSData with bytes decoded from given parameter base64 encoded NSString
 */
+ (NSData *)dataWithBase64EncodedNSString:(NSString *)string;

/**
 @brief function that encode bytes that contain in NSData to base64 encoded string;
 @return return base64 encoded string from contain bytes
 */
- (NSString *)base64EncodeDataToNSString;

@end
