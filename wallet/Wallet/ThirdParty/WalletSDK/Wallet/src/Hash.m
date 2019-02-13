

#import "Hash.h"

#import "SecureData.h"


static Hash *ZeroHash = nil;


@implementation Hash

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        unsigned char nullBytes[32];
        memset(nullBytes, 0, sizeof(nullBytes));
        ZeroHash = [Hash hashWithData:[NSData dataWithBytes:nullBytes length:sizeof(nullBytes)]];
    });
}

- (instancetype)initWithData: (NSData*)data {
    if (data.length != 32) { return nil; }
    
    self = [super init];
    if (self) {
        _data = [data copy];
        _hexString = [SecureData dataToHexString:_data];
    }
    return self;
}

- (BOOL)isZeroHash {
    return [self isEqualToHash:ZeroHash];
}

+ (instancetype)hashWithData: (NSData*)data {
    return [[Hash alloc] initWithData:data];
}

+ (instancetype)hashWithHexString: (NSString*)hexString {
    return [[Hash alloc] initWithData:[SecureData hexStringToData:hexString]];
}

+ (Hash*)zeroHash {
    return ZeroHash;
}


#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    return self;
}


#pragma mark - NSObject

- (BOOL)isEqualToHash: (Hash*)hash {
    return [self isEqual:hash];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[Hash class]]) { return NO; }
    return [_hexString isEqualToString:((Hash*)object).hexString];
}

- (NSUInteger)hash {
    return [_hexString hash];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"<Hash %@>", _hexString];
}

@end
