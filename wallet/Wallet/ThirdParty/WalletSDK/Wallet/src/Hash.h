
#import <Foundation/Foundation.h>

@interface Hash : NSObject <NSCopying>

// 0x0000000000000000000000000000000000000000000000000000000000000000 (i.e. 32 bytes of 0; 64 nibbles)
+ (Hash*)zeroHash;


+ (instancetype)hashWithData: (NSData*)data;
+ (instancetype)hashWithHexString: (NSString*)hexString;

@property (nonatomic, readonly) NSData *data;
@property (nonatomic, readonly) NSString *hexString;

- (BOOL)isEqualToHash: (Hash*)hash;

- (BOOL)isZeroHash;

@end
