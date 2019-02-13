

#import <Foundation/Foundation.h>

@interface Signature: NSObject <NSCoding, NSCopying>

+ (instancetype)signatureWithData: (NSData*)data;

@property (nonatomic, readonly) NSData* r;
@property (nonatomic, readonly) NSData* s;
@property (nonatomic, readonly) char v;

@end
