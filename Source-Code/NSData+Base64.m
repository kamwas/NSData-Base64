//
//  NSData+Base64.m
//  CreditCard
//
//  Created by Kamil Wasąg on 10/3/12.
//  Copyright (c) 2012 Kamil Wasąg. All rights reserved.
//

const char base64chars[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";


#import "NSData+Base64.h"

@implementation NSData(Base64)


+ (NSData *)dataWithBase64EncodedNSString:(NSString *)string
{
    unsigned char characterToCalculation[4], calcualtedBytes[3], currentCharacter = 0;
    int paddingLength = 0;
 
    NSString *stringToEncode = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    NSMutableData *mutableData = [NSMutableData dataWithCapacity:[stringToEncode length]];
    unsigned long lentext = [stringToEncode length];

    for (unsigned long mainLoop= 0; mainLoop<lentext; mainLoop+=4)
    {
        for (int currentLoop = 0; currentLoop < 4; currentLoop++) {
            currentCharacter = [stringToEncode characterAtIndex:mainLoop+currentLoop];
            
            if( (currentCharacter >= 'A') && (currentCharacter <= 'Z' ))
                characterToCalculation [currentLoop] = currentCharacter - 'A';
            else if(( currentCharacter >= 'a') && (currentCharacter <= 'z'))
                characterToCalculation [currentLoop] = currentCharacter - 'a' + 26;
            else if(( currentCharacter >= '0') && (currentCharacter <= '9'))
                characterToCalculation [currentLoop] = currentCharacter - '0' + 52;
            else if(currentCharacter == '+' )
                characterToCalculation [currentLoop] = 62;
            else if(currentCharacter == '=' )
                paddingLength ++;
            else if(currentCharacter == '/' )
                characterToCalculation [currentLoop] = 63;
        }
        
        calcualtedBytes [0] = ( characterToCalculation[0] << 2 ) | ( ( characterToCalculation[1] & 0x30) >> 4 );
        calcualtedBytes [1] = ( ( characterToCalculation[1] & 0x0F ) << 4 ) | ( ( characterToCalculation[2] & 0x3C ) >> 2 );
        calcualtedBytes [2] = ( ( characterToCalculation[2] & 0x03 ) << 6 ) | ( characterToCalculation[3] & 0x3F );
        
        for(int currentLoop = 0; currentLoop < (paddingLength > 0 ? (paddingLength > 2 ? 1 : 2) : 3); currentLoop++ )
        {
            [mutableData appendBytes:&calcualtedBytes[currentLoop] length:1];
        }
    }
    
    return [NSData dataWithData:mutableData];
}

- (NSString *)base64EncodeDataToNSString
{
    unsigned int currentBytes[3];
    unsigned char currentCharacters[4];
    const unsigned char *dataBytes = [self bytes];
    NSMutableString *result = [[NSMutableString alloc] initWithCapacity:self.length];
    for (unsigned long mainLoopIterator = 0; mainLoopIterator < self.length; mainLoopIterator += 3)
    {
        for (int i = 0; i<3; i++)
            if (mainLoopIterator + i < self.length)
                currentBytes[i] = dataBytes[mainLoopIterator + i];
            else
                currentBytes[i] = 0;
        
        currentCharacters[0] = (currentBytes[0] & 0xFC) >> 2;
		currentCharacters[1] = ((currentBytes[0] & 0x03) << 4) | ((currentBytes[1] & 0xF0) >> 4);
		currentCharacters[2] = ((currentBytes[1] & 0x0F) << 2) | ((currentBytes[2] & 0xC0) >> 6);
		currentCharacters[3] = currentBytes[2] & 0x3F;
        
       
        int dataLeft = self.length - mainLoopIterator;
        int toRead = ((dataLeft > 0) && (dataLeft) < 3 ?  dataLeft + 1 : 4);
        for (int i = 0; i < toRead; i++)
            [result appendFormat:@"%c", base64chars[currentCharacters[i]]];
        
        for (int i = toRead; i < 4; i++)
            [result appendString:@"="];
    }
    return result;
}


@end
