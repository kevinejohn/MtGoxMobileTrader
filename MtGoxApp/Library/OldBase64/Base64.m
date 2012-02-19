//
//  Base64.m
//  NCA-App
//
//  Created by Kevin Johnson on 11/15/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "Base64.h"

static char *alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";  

@implementation Base64  
+(NSString *)encode:(NSData *)plainText {  
    int encodedLength = (((([plainText length] % 3) + [plainText length]) / 3) * 4) + 1;  
    unsigned char *outputBuffer = malloc(encodedLength);  
    unsigned char *inputBuffer = (unsigned char *)[plainText bytes];  
    
    NSInteger i;  
    NSInteger j = 0;  
    int remain;  
    
    for(i = 0; i < [plainText length]; i += 3) {  
        remain = [plainText length] - i;  
        
        outputBuffer[j++] = alphabet[(inputBuffer[i] & 0xFC) >> 2];  
        outputBuffer[j++] = alphabet[((inputBuffer[i] & 0x03) << 4) |   
                                     ((remain > 1) ? ((inputBuffer[i + 1] & 0xF0) >> 4): 0)];  
        
        if(remain > 1)  
            outputBuffer[j++] = alphabet[((inputBuffer[i + 1] & 0x0F) << 2)  
                                         | ((remain > 2) ? ((inputBuffer[i + 2] & 0xC0) >> 6) : 0)];  
        else   
            outputBuffer[j++] = '=';  
        
        if(remain > 2)  
            outputBuffer[j++] = alphabet[inputBuffer[i + 2] & 0x3F];  
        else  
            outputBuffer[j++] = '=';              
    }  
    
    outputBuffer[j] = 0;  
    
    NSString *result = [NSString stringWithCString:(char*)outputBuffer encoding:NSUTF8StringEncoding];
    free(outputBuffer);  
    
    return result;  
}  

+ (NSString *)decodeBase64:(NSString *)input 
{
    NSString *alphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    NSString *decoded = @"";
    NSString *encoded = [input stringByPaddingToLength:(ceil([input length] / 4) * 4)
                                            withString:@"A"
                                       startingAtIndex:0];
    
    int i;
    char a, b, c, d;
    UInt32 z;
    
    for(i = 0; i < [encoded length]; i += 4) {
        a = [alphabet rangeOfString:[encoded substringWithRange:NSMakeRange(i + 0, 1)]].location;
        b = [alphabet rangeOfString:[encoded substringWithRange:NSMakeRange(i + 1, 1)]].location;
        c = [alphabet rangeOfString:[encoded substringWithRange:NSMakeRange(i + 2, 1)]].location;
        d = [alphabet rangeOfString:[encoded substringWithRange:NSMakeRange(i + 3, 1)]].location;
        
        z = ((UInt32)a << 26) + ((UInt32)b << 20) + ((UInt32)c << 14) + ((UInt32)d << 8);
        decoded = [decoded stringByAppendingString:[NSString stringWithCString:(char *)&z encoding:NSUTF8StringEncoding]];
    }
    
    
    return decoded;
}
@end  