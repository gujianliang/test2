


#import <Foundation/Foundation.h>

#import "Address.h"
#import "Signature.h"
#import "Transaction.h"


#pragma mark - Errors

#define kAccountErrorJSONInvalid                             -1
#define kAccountErrorJSONUnsupportedVersion                  -2
#define kAccountErrorJSONUnsupportedKeyDerivationFunction    -3
#define kAccountErrorJSONUnsupportedCipher                   -4
#define kAccountErrorJSONInvalidParameter                    -5

#define kAccountErrorMnemonicMismatch                        -6

#define kAccountErrorWrongPassword                           -10


#define kAccountErrorCancelled                               -20

#define kAccountErrorUnknownError                            -50


#pragma mark -
#pragma mark - Cancellable

@interface Cancellable : NSObject

- (void)cancel;

@end


#pragma mark -
#pragma mark - Account

@interface Account : NSObject

+ (instancetype)accountWithPrivateKey: (NSData*)privateKey;

+ (instancetype)accountWithMnemonicPhrase: (NSString*)phrase;
+ (instancetype)accountWithMnemonicData: (NSData*)data;

+ (instancetype)randomMnemonicAccount;


+ (Cancellable*)decryptSecretStorageJSON: (NSString*)json
                                password: (NSString*)password
                                callback: (void (^)(Account *account, NSError *NSError))callback;

- (Cancellable*)encryptSecretStorageJSON: (NSString*)password
                                callback: (void (^)(NSString *json))callback;

@property (nonatomic, readonly) Address *address;

@property (nonatomic, readonly) NSData *privateKey;

@property (nonatomic, readonly) NSString *mnemonicPhrase;
@property (nonatomic, readonly) NSString *seedStr;

@property (nonatomic, readonly) NSData *mnemonicData;
@property (nonatomic, copy)NSString *keystore;

- (Signature*)signDigest: (NSData*)digestData;
- (void)sign: (Transaction*)transaction;

- (Signature*)signMessage: (NSData*)message;
+ (Address*)verifyMessage: (NSData*)message signature: (Signature*)signature;

+ (Signature*)signatureWithMessage: (NSData*)message r: (NSData*)r s: (NSData*)s address: (Address*)address;

+ (BOOL)isValidMnemonicPhrase: (NSString*)phrase;
+ (BOOL)isValidMnemonicWord: (NSString*)word;

+ (NSArray *)getTotalWordList;

@end
