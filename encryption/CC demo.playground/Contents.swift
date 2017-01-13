import Foundation
import CommonCrypto

let s = "The quick brown fox jumps over the lazy dog."
let n = Int(CC_MD5_DIGEST_LENGTH)
let len = CC_LONG(s.utf8.count)

let ctx = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
var digest = Array<UInt8>(repeating: 0, count: n)

CC_MD5_Init(ctx)
CC_MD5_Update(ctx, s, len)
CC_MD5_Final(&digest, ctx)
ctx.deallocate(capacity: 1)

let sa = digest.map { NSString(format: "%x", $0) as String }
sa.joined(separator: "")
