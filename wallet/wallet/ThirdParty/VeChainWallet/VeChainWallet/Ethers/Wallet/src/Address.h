

#import <Foundation/Foundation.h>


@interface Address : NSObject <NSCoding, NSCopying>

+ (Address*)zeroAddress;

+ (instancetype)addressWithString: (NSString*)addressString;
+ (instancetype)addressWithData: (NSData*)addressData;

@property (nonatomic, readonly) NSString *checksumAddress;
@property (nonatomic, readonly) NSString *icapAddress;
@property (nonatomic, readonly) NSString *VXchecksumAddress;

@property (nonatomic, readonly) NSData *data;

+ (NSString*)_checksumAddressData: (NSData*)addressData;

- (BOOL)isEqualToAddress: (Address*)address;

- (BOOL)isZeroAddress;

@end
