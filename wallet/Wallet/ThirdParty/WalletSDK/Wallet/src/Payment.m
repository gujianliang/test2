

#import "Payment.h"

#import "RegEx.h"


@implementation Payment

static RegEx *RegexNumbersOnly = nil;

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RegexNumbersOnly = [RegEx regExWithPattern:@"^[0-9]*$"];
    });
}

+ (NSString*)formatEther: (BigNumber*)wei {
    return [Payment formatEther:wei options:0];
}

+ (NSString*)formatEther: (BigNumber*)wei options: (NSUInteger)options {
    if (!wei) { return nil; }
    
    NSString *weiString = [wei decimalString];
    
    BOOL negative = NO;
    if ([weiString hasPrefix:@"-"]) {
        negative = YES;
        weiString = [weiString substringFromIndex:1];
    }
    
    while (weiString.length < 19) {
        weiString = [@"0" stringByAppendingString:weiString];
    }
    
    NSUInteger decimalIndex = weiString.length - 18;
    NSString *whole = [weiString substringToIndex:decimalIndex];
    NSString *decimal = [weiString substringFromIndex:decimalIndex];
    
    if (options & EtherFormatOptionCommify) {
        NSString *commified = @"";
        //NSMutableArray *parts = [NSMutableArray arrayWithCapacity:(whole.length + 2) / 3];
        while (whole.length) {
            //NSLog(@"FOO: %@", whole);
            NSInteger chunkStart = whole.length - 3;
            if (chunkStart < 0) { chunkStart = 0; }
            commified = [NSString stringWithFormat:@"%@,%@", [whole substringFromIndex:chunkStart], commified];
            whole = [whole substringToIndex:chunkStart];
        }
        
        whole = [commified substringToIndex:commified.length - 1];
    }
    
    // 保留2 小数
    if ((options & EtherFormatOptionApproximate) && decimal.length > 2) {
        decimal = [decimal substringToIndex:2];
    }
    
    // Trim trailing 0's
//    while (decimal.length > 1 && [decimal hasSuffix:@"0"]) {
//       // decimal = [decimal substringToIndex:decimal.length - 1];
//    }
    
    if (negative) {
        whole = [@"-" stringByAppendingString:whole];
    }
    
    return [NSString stringWithFormat:@"%@.%@", whole, decimal];
}

+ (BigNumber*)parseEther: (NSString*)etherString {
    if ([etherString isEqualToString:@"."]) { return nil; }
    
    BOOL negative = NO;
    if ([etherString hasPrefix:@"-"]) {
        negative = YES;
        etherString = [etherString substringFromIndex:1];
    }
    
    if (etherString.length == 0) { return nil; }
    
    NSArray *parts = [etherString componentsSeparatedByString:@"."];
    if ([parts count] > 2) { return nil; }
    
    NSString *whole = [parts objectAtIndex:0];
    if (whole.length == 0) { whole = @"0"; }
    if (![RegexNumbersOnly matchesExactly:whole]) { return nil; }
    
    NSString *decimal = ([parts count] > 1) ? [parts objectAtIndex:1]: @"0";
    if (!decimal || decimal.length == 0) { decimal = @"0"; }
    if (![RegexNumbersOnly matchesExactly:decimal]) { return nil; }
    
    if (decimal.length > 18) { return nil; }
    while (decimal.length < 18) { decimal = [decimal stringByAppendingString:@"0"]; }
    
    NSString *wei = [whole stringByAppendingString:decimal];
    if (negative) { wei = [@"-" stringByAppendingString:wei]; }
        
    return [BigNumber bigNumberWithDecimalString:wei];
}

+ (NSString*)formatToken: (BigNumber*)wei decimals:(NSUInteger)decimals options: (NSUInteger)options {
    if (!wei) { return nil; }
    
    NSString *weiString = [wei decimalString];
    
    BOOL negative = NO;
    if ([weiString hasPrefix:@"-"]) {
        negative = YES;
        weiString = [weiString substringFromIndex:1];
    }
    
    while (weiString.length < decimals + 1) {
        weiString = [@"0" stringByAppendingString:weiString];
    }
    
    NSUInteger decimalIndex = weiString.length - decimals;
    NSString *whole = [weiString substringToIndex:decimalIndex];
    NSString *decimal = [weiString substringFromIndex:decimalIndex];
    
    if (options & EtherFormatOptionCommify) {
        NSString *commified = @"";
        //NSMutableArray *parts = [NSMutableArray arrayWithCapacity:(whole.length + 2) / 3];
        while (whole.length) {
            //NSLog(@"FOO: %@", whole);
            NSInteger chunkStart = whole.length - 3;
            if (chunkStart < 0) { chunkStart = 0; }
            commified = [NSString stringWithFormat:@"%@,%@", [whole substringFromIndex:chunkStart], commified];
            whole = [whole substringToIndex:chunkStart];
        }
        
        whole = [commified substringToIndex:commified.length - 1];
    }
    
    if ((options & EtherFormatOptionApproximate) && decimal.length > 2) {
        decimal = [decimal substringToIndex:2];
    }
    
    // fix "0." issues
    if (decimals > 0 && decimal.length == 0) {
        decimal = @"00";
    }
    
    if (negative) {
        whole = [@"-" stringByAppendingString:whole];
    }
    
    return [NSString stringWithFormat:@"%@.%@", [self splitLongStr:whole], decimal];
}

+ (NSString *)splitLongStr:(NSString *)inputStr
{
    NSMutableArray *strList = [NSMutableArray array];
    for (NSInteger i = inputStr.length; i > 0; i = i - 3) {
        NSString *tmp = @"";
        if (i - 3 <= 0) {
            tmp = [inputStr substringWithRange:NSMakeRange(0 , i)];
        }else{
            tmp = [inputStr substringWithRange:NSMakeRange(i - 3, 3)];
        }
        [strList addObject:tmp];
    }
    
    return [[strList reverseObjectEnumerator].allObjects componentsJoinedByString:@","];
}

+ (BigNumber*)parseToken: (NSString*)etherString dicimals:(NSUInteger)decimals {
    if ([etherString isEqualToString:@"."]) { return nil; }
    
    BOOL negative = NO;
    if ([etherString hasPrefix:@"-"]) {
        negative = YES;
        etherString = [etherString substringFromIndex:1];
    }
    
    if (etherString.length == 0) { return nil; }
    
    NSArray *parts = [etherString componentsSeparatedByString:@"."];
    if ([parts count] > 2) { return nil; }
    
    NSString *whole = [parts objectAtIndex:0];
    if (whole.length == 0) { whole = @"0"; }
    if (![RegexNumbersOnly matchesExactly:whole]) { return nil; }
    
    NSString *decimal = ([parts count] > 1) ? [parts objectAtIndex:1]: @"0";
    if (!decimal || decimal.length == 0) { decimal = @"0"; }
    if (![RegexNumbersOnly matchesExactly:decimal]) { return nil; }
    
    if (decimal.length > decimals) { decimal = [decimal substringToIndex:decimals]; }
    while (decimal.length < decimals) { decimal = [decimal stringByAppendingString:@"0"]; }
    
    NSString *wei = [whole stringByAppendingString:decimal];
    if (negative) { wei = [@"-" stringByAppendingString:wei]; }
    
    return [BigNumber bigNumberWithDecimalString:wei];
}


- (NSString*)description {
    return [NSString stringWithFormat:@"<Payment address=%@ amount=%@ firm=%@>",
            _address, [Payment formatEther:_amount], (_firm ? @"Yes": @"No")];
}

@end
