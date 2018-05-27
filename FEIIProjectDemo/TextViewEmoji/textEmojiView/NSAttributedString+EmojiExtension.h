//
//  NSAttributedString+EmojiExtension.h
//  FEIIProjectDemo
//
//  Created by fei li on 2018/5/27.
//  Copyright © 2018年 feii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (EmojiExtension)

- (NSString *)getPlainString;

- (NSMutableAttributedString *)getEmojiAttributedString;

@end
