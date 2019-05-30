//
//  TransactionParameter.m
//  WalletSDK
//
//  Created by vechaindev on 2019/4/7.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "TransactionParameter.h"
#import "YYModel.h"
#import "ThorWalletHeader.h"

@implementation TransactionParameter

- (void)checkParameter:(void(^)(NSString *error,bool result))callback
{
    NSString *errorMsg = @"";
    for (ClauseModel * clauseModel in self.clauses) {
        
        NSString *to = clauseModel.to;
        if (![self checkTo:&to errorMsg:&errorMsg]) {
            if (callback) {
                callback(errorMsg,NO);
            }
            return ;
        }
        clauseModel.to = to;
        
        NSString *value = clauseModel.value;
        if (![self checkValue:&value errorMsg:&errorMsg]) {
            if (callback) {
                callback(errorMsg,NO);
            }
            return ;
        }
        clauseModel.value = value;
        
        NSString *data = clauseModel.data;
        if (![self checkData:&data errorMsg:&errorMsg]) {
            if (callback) {
                callback(errorMsg,NO);
            }
            return ;
        }
        clauseModel.data = data;
        
        if (![self isRightClause:clauseModel errorMsg:&errorMsg]) {
            if (callback) {
                callback(errorMsg,NO);
            }
            return ;
        }
    }
    
    NSString *gas = self.gas;
    if (![self checkGas:&gas errorMsg:&errorMsg]) {
        if (callback) {
            callback(errorMsg,NO);
        }
        return ;
    }
    self.gas = gas;
    
    
    if (![self checkChainTag:self.chainTag errorMsg:&errorMsg]) {
        if (callback) {
            callback(errorMsg,NO);
        }
        return ;
    }
    
    if (![self checkBlockRef:self.blockReference errorMsg:&errorMsg]) {
        if (callback) {
            callback(errorMsg,NO);
        }
        return ;
    }
    
    if (![self checkNoce:self.nonce errorMsg:&errorMsg]) {
        if (callback) {
            callback(errorMsg,NO);
        }
        return ;
    }
    
    NSString *gasPriceCoef = self.gasPriceCoef;
    if (![self checkGasPriceCoef:&(gasPriceCoef) errorMsg:&errorMsg]) {
        if (callback) {
            callback(errorMsg,NO);
        }
        return ;
    }
    
    self.gasPriceCoef = gasPriceCoef;
    
    NSString *expiration = self.expiration;
    
    if (![self checkExpiration:&expiration errorMsg:&errorMsg]) {
        if (callback) {
            callback(errorMsg,NO);
        }
        return ;
    }
    self.expiration = expiration;
    
    
    if (![self checkDependsOn:self.dependsOn errorMsg:&errorMsg]) {
        if (callback) {
            callback(errorMsg,NO);
        }
        return ;
    }
    
    callback(@"",YES);
    
}

- (BOOL)checkDependsOn:(NSString *)dependsOn errorMsg:(NSString **)errorMsg
{
    if ([WalletTools isEmpty:dependsOn]) {
        
        return YES;
    }else{
        if ([WalletTools checkHEXStr:dependsOn]) {
            return YES;
        }else
        {
            *errorMsg = @"dependsOn should be hex string";
            return NO;
        }
    }
}

- (BOOL)checkChainTag:(NSString *)chainTag errorMsg:(NSString **)errorMsg
{
    if (chainTag.length != 4) {
        *errorMsg = @"chainTag is not the right length";
        
        return NO;
    }
    if (![WalletTools checkHEXStr:chainTag] ) {
        *errorMsg = @"chainTag should be hex string";
        
        return NO;
    }
    return YES;
}

- (BOOL)checkBlockRef:(NSString *)blockRef errorMsg:(NSString **)errorMsg
{
    if (blockRef.length != 18) {
        *errorMsg = @"blockRef is not the right length";
        
        return NO;
    }
    if (![WalletTools checkHEXStr:blockRef] ) {
        *errorMsg = @"blockRef should be hex string";
        
        return NO;
    }
    return YES;
}

- (BOOL)checkNoce:(NSString *)nonce errorMsg:(NSString **)errorMsg
{
    if (nonce.length != 18) {
        *errorMsg = @"nonce is not the right length";
        
        return NO;
    }
    if (![WalletTools checkHEXStr:nonce] ) {
        *errorMsg = @"nonce should be hex string";
        
        return NO;
    }
    return YES;
}

- (BOOL)checkGasPriceCoef:(NSString **)gasPriceCoef errorMsg:(NSString **)errorMsg
{
    if ([WalletTools isEmpty:*gasPriceCoef]) {
        *gasPriceCoef = @"0";
        return YES;
    }else{
        *gasPriceCoef = [NSString stringWithFormat:@"%@",*gasPriceCoef];
        
        if (![WalletTools checkDecimalStr:*gasPriceCoef]) {
            *errorMsg = @"gasPriceCoef should be decimal string";
            return NO;
        }else{
            NSInteger intGasPriceCoef = (*gasPriceCoef).integerValue;
            if (intGasPriceCoef >= 0 && intGasPriceCoef <= 255) {
                return YES;
            }else{
                *errorMsg = @"gasPriceCoef is an integer type from 0 to 255";
                
                return NO;
            }
        }
    }
    
    return YES;
}

- (BOOL)checkExpiration:(NSString **)expiration errorMsg:(NSString **)errorMsg
{
    
    *expiration = [NSString stringWithFormat:@"%@",*expiration];
    
    if ([WalletTools isEmpty:*expiration]) {
        *expiration = @"720";
        return YES;
    }
    
    if (![WalletTools checkDecimalStr:(*expiration)]) {
        *errorMsg = @"expiration should be decimal string";
        
        return NO;
    }
    return YES;
}

- (BOOL)isRightClause:(ClauseModel *)clauseModel errorMsg:(NSString **)errorMsg
{
    if ([WalletTools isEmpty:clauseModel.to]) {
        
        if ([WalletTools isEmpty:clauseModel.data]) {
            *errorMsg = @"clause is invalid";
            return NO;
        }
        
    }else{ // To has a value, need to judge the data is divisible by 64
        if (![WalletTools isEmpty:clauseModel.data]) {
            
            // Divided by 64
            if (clauseModel.data.length >= 10) {
                NSInteger i = (clauseModel.data.length - 10) % 64;
                if (i != 0) {
                    *errorMsg = @"clause is invalid";
                    return NO;
                }
            }
            else{
                if ([clauseModel.data isEqualToString:@"0x"]) {
                    return YES;
                }else{
                    *errorMsg = @"clause is invalid";
                    return NO;
                }
            }
            
        }else{
            //to != nil data = nil value == nil
            if ([WalletTools isEmpty:clauseModel.value]) {
                *errorMsg = @"clause is invalid";
                return NO;
            }
        }
    }
    
    return YES;
}

- (BOOL)checkTo:(NSString **)to errorMsg:(NSString **)errorMsg
{
    if ([WalletTools isEmpty:*to]) {
        *to = @"";
        return YES;
    }
    
    if ([*to isKindOfClass:[NSString class]]) {
        
        if (![WalletTools errorAddressAlert:*to]) { //check address
            *errorMsg = @"to is invild";
            return NO;
        }
    }else{
        *errorMsg = @"to should be NSString";
        return NO;
    }
    return YES;
}

- (BOOL)checkValue:(NSString **)value errorMsg:(NSString **)errorMsg
{
    if ([WalletTools isEmpty:*value]) {
        *value = @"0";
        return YES;
    }
    // value maybe string or number
    if ([*value isKindOfClass:[NSString class]] || [*value isKindOfClass:[NSNumber class]]) {
        
        //maybe bool
        if ([self checkNumberOriginBool:*value]) {
            *errorMsg = @"value should be NSString or NSNumber";
            return NO;
        }
        
        *value = [NSString stringWithFormat:@"%@",*value];
        
        if ([(*value) isEqualToString:@"0x"]) { // 0x
            *value = @"0";
            return YES;
        }
        
        if ([WalletTools checkDecimalStr:*value]) {//Is a decimal
            return YES;
        }else if ([WalletTools checkHEXStr:*value]){// Hex
            *value = [BigNumber bigNumberWithHexString:*value].decimalString;
            return YES;
        }else{ //Neither decimal nor hexadecimal
            *errorMsg = @"value should be NSString or NSNumber";
            return NO;
        }
        
    }else{
        *errorMsg = @"value should be NSString or NSNumber";
        return NO;
    }
    return YES;
}

- (BOOL)checkData:(NSString **)data errorMsg:(NSString **)errorMsg
{
    if ([WalletTools isEmpty:*data]) {
        *data = @"";
        return YES;
    }
    
    if ([*data isKindOfClass:[NSString class]] ) {
        if ([WalletTools checkHEXStr:*data]) {
            
             return YES;
        }else{
            *errorMsg = @"data should be hex string";
            return NO;
        }
    }else{
        *errorMsg = @"data should be hex string";
        return NO;
    }
    return YES;
}

- (BOOL)checkGas:(NSString **)gas errorMsg:(NSString **)errorMsg
{
    if ([WalletTools isEmpty:*gas]) {
        *errorMsg = @"gas can't be empty";
        
        return NO;
    }
    // gas maybe string or number
    if ([*gas isKindOfClass:[NSString class]]
        || [*gas isKindOfClass:[NSNumber class]]) {
        
        //maybe bool 
        if ([self checkNumberOriginBool:*gas]) {
            *errorMsg = @"gas should be NSString or NSNumber";
            return NO;
        }
        
        *gas = [NSString stringWithFormat:@"%@",*gas];
        
        if ([WalletTools checkDecimalStr:*gas]) {//Is a decimal
            if((*gas).integerValue == 0)
            {
                *errorMsg = @"gas can't be 0";
                return NO;
            }
            return YES;
        }else{ //Not decimal
            *errorMsg = @"gas should be decimal string";
            return NO;
        }
        
    }else{
        *errorMsg = @"gas should be NSString or NSNumber";
        return NO;
    }
    return YES;
}


- (BOOL)checkNumberOriginBool:(id)data {
    
    if ([data isKindOfClass:[NSNumber class]]) {
        const char * pObjCType = [((NSNumber*)data) objCType];
        
        if (strcmp(pObjCType, @encode(_Bool)) == 0
            || strcmp([data objCType], @encode(char)) == 0) {
            return YES;
        }
        return NO;
    }
    return NO;
}

- (void)setGas:(NSString *)gas
{
    _gas = gas;
}

- (void)setGasPriceCoef:(NSString * _Nonnull)gasPriceCoef
{
    _gasPriceCoef = gasPriceCoef;
}

- (void)setExpiration:(NSString * _Nonnull)expiration
{
    _expiration = expiration;
}

- (void)setChainTag:(NSString * _Nonnull)chainTag
{
    _chainTag = chainTag;
}

- (void)setBlockReference:(NSString * _Nonnull)blockReference
{
    _blockReference = blockReference;
}

- (void)setNonce:(NSString * _Nonnull)nonce
{
    _nonce = nonce;
}

- (void)setClauses:(NSArray * _Nonnull)clauses
{
    _clauses = clauses;
}

- (void)setDependsOn:(NSString * _Nonnull)dependsOn
{
    _dependsOn = dependsOn;
}

- (void)setReserveds:(NSArray<NSData *> * _Nonnull)reserveds
{
    _reserveds = reserveds;
}

+ (TransactionParameter *)creatTransactionParameter:(void(^)(TransactionParameterBuiler *builder))callback checkParams:(void(^)(NSString *errorMsg))checkParamsCallback
{
    TransactionParameterBuiler *builder = [[TransactionParameterBuiler alloc]init];

    callback(builder);
    
    TransactionParameter *transactionModel = [builder build];
    __block BOOL hasError = NO;
    [transactionModel checkParameter:^(NSString *error, bool result) {
        
        checkParamsCallback(error);
        if (!result) {
            hasError = YES;
        }
    }];
    
    return hasError ? nil : transactionModel;
}

@end

@implementation ClauseModel

@end


@implementation TransactionParameterBuiler

- (TransactionParameter *)build
 {
     TransactionParameter *transactionModel = [[TransactionParameter alloc] init];
     
     transactionModel.chainTag          = self.chainTag;
     transactionModel.blockReference    = self.blockReference;
     transactionModel.nonce             = self.nonce;
     transactionModel.clauses           = self.clauses;
     transactionModel.gas               = self.gas;
     transactionModel.expiration        = self.expiration;
     transactionModel.gasPriceCoef      = self.gasPriceCoef;
     
     // Not mandatory
     transactionModel.dependsOn = self.dependsOn;
     transactionModel.reserveds = self.reserveds;
     
     return transactionModel;
 }

@end
