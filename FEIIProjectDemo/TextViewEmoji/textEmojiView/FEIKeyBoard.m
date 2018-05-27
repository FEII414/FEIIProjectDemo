//
//  FEIKeyBoard.m
//  FEIIProjectDemo
//
//  Created by fei li on 2018/5/27.
//  Copyright © 2018年 feii. All rights reserved.
//

#import "FEIKeyBoard.h"
#import "EmojiTextAttachment.h"
#import "NSAttributedString+EmojiExtension.h"

#define kScreenWidth [[UIScreen mainScreen]bounds].size.width
#define kScreenHeight [[UIScreen mainScreen]bounds].size.height

#define kToolBarHeight 44
#define kCollectionHeight 120
#define kSelfHeight (kToolBarHeight + kCollectionHeight)
#define kAnimationDurant 0.5

@interface FEIKeyBoard ()<UITextViewDelegate>

@property (nonatomic, weak) UIViewController *superController;

@property (nonatomic, strong) UIView *toolTopBar;
@property (nonatomic, strong) UIView *imageCollection;

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *btnEmoji;
@property (nonatomic, strong) UIButton *btnSend;

@property (nonatomic, copy) NSString *textStr;
@property (nonatomic, assign) NSInteger cursorLocation;

@end

@implementation FEIKeyBoard

- (instancetype)initWithController:(UIViewController *)superController{
    
    if (self = [super init]) {
        
        _superController = superController;
        [_superController.view addSubview:self];
        self.backgroundColor = [UIColor grayColor];
        self.frame = CGRectMake(0, kScreenHeight - kToolBarHeight, kScreenWidth, kSelfHeight);
        [self addNotification];
        
        [self setupViews];
        
        return self;
        
    }
    return nil;
    
}

- (void)addNotification{
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWillShow:(NSNotification *)note{
    
    _btnEmoji.selected = NO;
    //取出键盘最终的frame
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //取出键盘弹出需要花的时间
    double duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //修改约束
    CGRect rectTemp = self.frame;
    rectTemp.origin.y = CGRectGetMinY(rect) - kToolBarHeight;
    
    self.frame = rectTemp;
    
    [UIView animateWithDuration:duration animations:^{
        
        [self layoutIfNeeded];
        
    }];
    
}

- (void)keyboardWillHidden:(NSNotification *)note{
    
    //取出弹出键盘的时间
    double duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //修改约束
    CGRect rectTemp = self.frame;
    if (_btnEmoji.selected) {
        rectTemp.origin.y = kScreenHeight - kSelfHeight;
    }else{
        rectTemp.origin.y = kScreenHeight-kToolBarHeight;
        _btnEmoji.selected = false;
    }
    
    self.frame = rectTemp;
    
    [UIView animateWithDuration:duration animations:^{
        
        [self layoutIfNeeded];
        
    }];
    
}

- (void)showEmojiCollection:(UIButton *)sener{
    
    sener.selected = !sener.selected;
    
    if (sener.selected == true) {
        
        if ([_textView isFirstResponder]) {
            
            [self endEditing:true];
            
        }else{
            
            //修改约束
            CGRect rectTemp = self.frame;
            rectTemp.origin.y = kScreenHeight - kSelfHeight;
            self.frame = rectTemp;
            
            [UIView animateWithDuration:kAnimationDurant animations:^{
                
                [self layoutIfNeeded];
                
            }];
            
        }
        
    }else{
        
        [_textView becomeFirstResponder];
        
    }
    
}

- (void)onlyShowToolBar{
    
    if ([_textView isFirstResponder]) {
        
        _btnEmoji.selected = NO;
        [self endEditing:true];
        
    }else{
        
        //修改约束
        CGRect rectTemp = self.frame;
        rectTemp.origin.y = kScreenHeight-kToolBarHeight;
        _btnEmoji.selected = false;
        
        self.frame = rectTemp;
        
        [UIView animateWithDuration:kAnimationDurant animations:^{
            
            [self layoutIfNeeded];
            
        }];
        
    }
    
}

- (void)addEmojiTextView:(UIButton *)sender{
    
    NSMutableAttributedString *attributerdStr = [[NSMutableAttributedString alloc]initWithAttributedString:_textView.attributedText];
    
    EmojiTextAttachment *attachMent = [[EmojiTextAttachment alloc]initWithData:nil ofType:nil];
    attachMent.image = [UIImage imageNamed:@"fat"];
    attachMent.emojiTag = @"[/fat]";
    
    NSAttributedString *attStr = [NSAttributedString attributedStringWithAttachment:attachMent];
//    [attributerdStr  insertAttributedString:attStr atIndex:_textView.selectedRange.location];//index为用户需要插入图片的位置
    
    [_textView.textStorage insertAttributedString:attStr atIndex:_textView.selectedRange.location];
//    _textView.attributedText = attributerdStr;
    
    
    _textStr = [_textView.attributedText getPlainString];
    
}

- (void)setupViews{
    
    _toolTopBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kToolBarHeight)];
    _toolTopBar.backgroundColor = [UIColor blueColor];
    [self addSubview:_toolTopBar];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(16, 7, 200, kToolBarHeight-7-7)];
    _textView.delegate = self;
    [_toolTopBar addSubview:_textView];
//    _textView.attributedText = [_textView.attributedText getEmojiAttributedString];
    
    _btnEmoji = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnEmoji.frame = CGRectMake(CGRectGetMaxX(_textView.frame)+10, 7, 30, 30);
    _btnEmoji.backgroundColor = [UIColor grayColor];
    [_toolTopBar addSubview:_btnEmoji];
    [_btnEmoji addTarget:self action:@selector(showEmojiCollection:) forControlEvents:UIControlEventTouchUpInside];
    
    _btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnSend.frame = CGRectMake(CGRectGetMaxX(_btnEmoji.frame)+10, 7, 50, 30);
    _btnSend.backgroundColor = [UIColor grayColor];
    [_btnSend setTitle:@"发送" forState:UIControlStateNormal];
    [_toolTopBar addSubview:_btnSend];
    [_btnSend addTarget:self action:@selector(addEmojiTextView:) forControlEvents:UIControlEventTouchUpInside];
    
    _imageCollection = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_toolTopBar.frame), kScreenWidth, kCollectionHeight)];
    _imageCollection.backgroundColor = [UIColor cyanColor];
    [self addSubview:_imageCollection];
    
}

#pragma mark UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    
    return true;
}

- (void)textViewDidChange:(UITextView *)textView{
    
    if (90 > textView.contentSize.height && textView.contentSize.height > textView.frame.size.height) {
        
        CGRect rectToolBar = _toolTopBar.frame;
        rectToolBar.size.height = textView.contentSize.height + 14 + 8;
        _toolTopBar.frame = rectToolBar;
        
        CGRect rectTextView = _textView.frame;
        rectTextView.size.height = textView.contentSize.height + 8;
        _textView.frame = rectTextView;
        
        CGRect rectSelf = self.frame;
        rectSelf.origin.y = rectSelf.origin.y + kToolBarHeight - (textView.contentSize.height + 14 + 8);
        rectSelf.size.height = rectSelf.size.height + kToolBarHeight - (textView.contentSize.height + 14 + 8);
        self.frame = rectSelf;
    
        self.imageCollection.frame = CGRectMake(0, CGRectGetMaxY(_toolTopBar.frame), kScreenWidth, kCollectionHeight);
        
        [UIView animateWithDuration:kAnimationDurant animations:^{
            
            [self layoutIfNeeded];
            
        }];
        
        
    }
    
}

@end
