import Foundation
import CommonCrypto
import Security

let key = "asecret16bytekey"
let keyLen = key.utf8.count

let msg1 = "mysecretmessage."
let msg1Len = msg1.utf8.count
[UInt8](msg1.utf8)

let msg2 = "butwaitIhavemore"
let msg2Len = msg2.utf8.count
[UInt8](msg2.utf8)

// AES128 block size is 16 bytes
let blockSize = 16  // bytes
let stdBufferSize = blockSize * 8 // bits

var iv = [UInt8](repeating: 0, count: blockSize)

SecRandomCopyBytes(
    kSecRandomDefault,
    blockSize,
    &iv)
iv

let operation = CCOperation(kCCEncrypt)
let algorithm = CCAlgorithm(kCCAlgorithmAES)
let options = CCOptions(0)  // CBC

var cipherData = [UInt8](repeating: 0,
    count: stdBufferSize)

var resultLen = 0
var status: Int32 = 0

//var cryptorRef = CCCryptorRef()
var cryptorRef: CCCryptorRef? = nil

status = CCCryptorCreate(
    operation,
    algorithm,
    options,
    key,
    keyLen,
    iv,
    &cryptorRef)

cryptorRef
var updateLen = 0

status = CCCryptorUpdate(
    cryptorRef,
    msg1,
    msg1Len,
    UnsafeMutableRawPointer(mutating: cipherData),
    stdBufferSize,
    &updateLen)

status
updateLen
cipherData[0..<16]
cipherData[16..<32]

status = CCCryptorUpdate(
    cryptorRef,
    msg2,
    msg2Len,
    // pointer arithmetic!!!
    UnsafeMutableRawPointer(mutating: cipherData) + 16,
    stdBufferSize,
    &updateLen)

status
updateLen
cipherData[0..<16]
cipherData[16..<32]

var finalLen = 0

status = CCCryptorFinal(
    cryptorRef,
    UnsafeMutableRawPointer(mutating:  cipherData),
    0,
    &finalLen)

status
finalLen
cipherData[0..<16]
cipherData[16..<32]

CCCryptorRelease(cryptorRef)

var decrypted = [UInt8](repeating: 0,
    count: stdBufferSize)

status = CCCrypt(
    CCOperation(kCCDecrypt),
    algorithm,
    options,
    key,
    keyLen,
    iv,
    cipherData,
    stdBufferSize,
    UnsafeMutableRawPointer(mutating: decrypted),
    stdBufferSize,
    &resultLen)

status
resultLen
decrypted[0..<16]
decrypted[16..<32]

let n = msg1Len + msg2Len
let recovered = decrypted[0..<n]
let sa = recovered.map {
    Character(UnicodeScalar(UInt32($0))!) }
String(sa)


