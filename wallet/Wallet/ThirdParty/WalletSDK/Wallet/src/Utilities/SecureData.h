

#import <Foundation/Foundation.h>

//#include "blake2.h"

@interface SecureData : NSObject <NSCopying>

+ (NSData*)hexStringToData: (NSString*)hexString;
+ (NSString*)dataToHexString: (NSData*)data;

+ (NSData*)SHA256: (NSData*)data;
+ (NSData*)KECCAK256: (NSData*)data;

+ (SecureData *)BLAKE2B: (NSData *)data;

+ (instancetype)secureData;
+ (instancetype)secureDataWithCapacity: (NSUInteger)capacity;
+ (instancetype)secureDataWithData: (NSData*)data;
+ (instancetype)secureDataWithHexString: (NSString*)hexString;
+ (instancetype)secureDataWithLength: (NSUInteger)length;


@property (nonatomic, readonly) NSUInteger length;
@property (nonatomic, readonly) const void *bytes;
@property (nonatomic, readonly) void *mutableBytes;


- (void)append: (SecureData*)secureData;
- (void)appendByte:(unsigned char)byte;
- (void)appendData: (NSData*)data;

- (SecureData*)subdataWithRange: (NSRange)range;
- (SecureData*)subdataFromIndex: (NSUInteger)fromIndex;
- (SecureData*)subdataToIndex: (NSUInteger)toIndex;

- (SecureData*)SHA1;
- (SecureData*)SHA256;
- (SecureData*)KECCAK256;

- (NSData*)data;
- (NSString*)hexString;
- (NSString *)numberHexString;
@end
