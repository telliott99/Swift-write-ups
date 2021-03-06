import Foundation
import CommonCrypto
import Security


// turn a password into a key with sufficient randomness
// by key "stretching"

let pw = "my secret"
let pwBytes = pw.utf8.map { Int8($0) }
let pwLen = pwBytes.count

// Int8 not UInt8!
let pwPointer = UnsafePointer<Int8>(pwBytes)

var salt = [UInt8](
    repeating: 0,
    count: 6)
let saltLen = salt.count

SecRandomCopyBytes(
    kSecRandomDefault,
    6,
    &salt)

salt

// UInt8 not Int8!
let saltPointer = UnsafePointer<UInt8>(salt)

let alg = CCPBKDFAlgorithm(kCCPBKDF2)
let hmac = CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA1)
let n = Int(CC_SHA1_DIGEST_LENGTH)
n

// figure out how many rounds needed 
// for 1000ms computation time
let rounds = CCCalibratePBKDF(
    alg,
    pwLen,
    saltLen,
    hmac,
    n,
    1000)

// Derive the key

let key1 = Array<UInt8>(
    repeating: 0,
    count:Int(CC_SHA1_DIGEST_LENGTH))

CCKeyDerivationPBKDF(
    alg,            // kCCPBKDF2
    pwPointer,
    pwLen,
    saltPointer,
    saltLen,
    hmac,           // kCCPRFHmacAlgSHA1
    rounds,
    UnsafeMutablePointer<UInt8>(mutating: key1),
    n)

key1

// try again with the *same* pw + random salt

let key2 = Array<UInt8>(
    repeating: 0,
    count:Int(CC_SHA1_DIGEST_LENGTH))

CCKeyDerivationPBKDF(
    alg,            // kCCPBKDF2
    pwPointer,
    pwLen,
    saltPointer,
    saltLen,
    hmac,           // kCCPRFHmacAlgSHA1
    rounds,
    UnsafeMutablePointer<UInt8>(mutating: key2),
    n)

key2
