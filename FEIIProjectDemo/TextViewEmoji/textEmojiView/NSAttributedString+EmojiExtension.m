//
//  NSAttributedString+EmojiExtension.m
//  FEIIProjectDemo
//
//  Created by fei li on 2018/5/27.
//  Copyright © 2018年 feii. All rights reserved.
//

#import "NSAttributedString+EmojiExtension.h"
#import "EmojiTextAttachment.h"


@implementation NSAttributedString (EmojiExtension)

- (NSString *)getPlainString{
    
    //最终偏移文本
    NSMutableString *plainString = [NSMutableString stringWithString:self.string];
    
    //替换下标的偏移量
    __block NSUInteger base = 0;
    
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        
        if (value && [value isKindOfClass:[EmojiTextAttachment class]]) {
            
            
            [plainString replaceCharactersInRange:NSMakeRange(range.location+base, range.length) withString:((EmojiTextAttachment *)value).emojiTag];
            //增加偏移量
            base += ((EmojiTextAttachment *) value).emojiTag.length - range.length; //1
        }
        
    }];
    
    return plainString;
    
}

- (NSMutableAttributedString *)getEmojiAttributedString{
    
    NSString *str = @"Q[/fat]we[/fa76t]rttgy[/fat]";
    
    return [self regularEmoji:str];
    
}

- (NSMutableAttributedString *)regularEmoji:(NSString *)str{
    
    
    
    NSError *error;
    
    NSRegularExpression *regular = [NSRegularExpression
                                 regularExpressionWithPattern:@"\\[/\\w+\\]" options:NSRegularExpressionCaseInsensitive
                                 error:nil];
//    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) return nil;
    
    NSMutableAttributedString *strNew = [[NSMutableAttributedString alloc]initWithString:str];
    
    __block NSUInteger base = 0;
    
    [regular enumerateMatchesInString:str options:NSMatchingReportCompletion range:NSMakeRange(0, str.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSRange matchRange = result.range;
        NSLog(@"range:%@",NSStringFromRange(matchRange));
        NSString *strss = [str substringWithRange:matchRange];
        NSLog(@"%@",strss);
        if (strss == nil || strss.length == 0) {
            
        }else{
            NSRegularExpression *regularT = [NSRegularExpression
                                             regularExpressionWithPattern:@"\\w+" options:NSRegularExpressionCaseInsensitive
                                             error:nil];
            NSRange rangeFirst = [regularT rangeOfFirstMatchInString:strss options:0 range:NSMakeRange(0, strss.length)];
            
            NSString *strsstt = [strss substringWithRange:rangeFirst];
            
            EmojiTextAttachment *emojiText = [[EmojiTextAttachment alloc]init];
            emojiText.emojiTag = strsstt;
            emojiText.image = [UIImage imageNamed:strsstt];
            
            NSAttributedString *attffStr = [NSAttributedString attributedStringWithAttachment:emojiText];
            NSInteger oldLength = strNew.length;
            [strNew deleteCharactersInRange:NSMakeRange(matchRange.location + base, matchRange.length)];
            [strNew insertAttributedString:attffStr atIndex:matchRange.location + base];
            NSInteger newLength = strNew.length;
            
            base += (newLength - oldLength);
        }
        
        
    }];
    
//    NSArray *result = [regx matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    
//    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//        NSString *str = obj;
//        NSRegularExpression *regx = [NSRegularExpression
//                                     regularExpressionWithPattern:@"\\w+" options:NSRegularExpressionCaseInsensitive
//                                     error:nil];
//        NSArray *resultTemp = [regx matchesInString:str options:0 range:NSMakeRange(0, str.length)];
//        NSString *strTemp = resultTemp.firstObject;
//
//    }];
    return strNew;
    
}

@end
