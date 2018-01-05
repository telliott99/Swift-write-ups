import Foundation
import CommonCrypto
import Security

let key = "asecret16bytekey"
let keyLen = key.utf8.count

let msg = "message"
print("msg:  \(msg)")
let msgLen = msg.utf8.count
let msgBytes = [UInt8](msg.utf8)
print("msgBytes: \(msgBytes)")

let operation = CCOperation(kCCEncrypt)
let algorithm = CCAlgorithm(kCCAlgorithmAES)

let options = CCOptions(kCCOptionPKCS7Padding | kCCOptionECBMode)

// AES128 block size is 16 bytes or 128 bits
let blockSize = 128

let bufferSize = 128
var cipherData = [UInt8](repeating: 0, count: bufferSize)
var resultLen = 0
var status: Int32 = 0

status = CCCrypt(
    operation,
    algorithm,
    options,
    key,
    keyLen,
    //iv,
    nil,
    msg,
    msgLen,
    UnsafeMutableRawPointer(mutating:  cipherData),
    bufferSize,
    &resultLen)

print("status:  \(status)")
print("resultLen:  \(resultLen)")
print("cipherData:  \(cipherData)")

var decrypted = [UInt8](repeating: 0, count: bufferSize)

status = CCCrypt(
    CCOperation(kCCDecrypt),
    algorithm,
    options,
    key,
    keyLen,
    // iv,
    nil,
    cipherData,
    bufferSize,
    UnsafeMutableRawPointer(mutating: decrypted),
    bufferSize,
    &resultLen)

print("status:  \(status)")
print("resultLen:  \(resultLen)")
print("decrypted:  \(decrypted)")

var pA = Array<Character>()
for c in decrypted[0..<16] {
    let sc = UnicodeScalar(UInt32(c))!
    pA.append(Character(sc))
}

let p = pA.map {String($0)}.joined(separator: "")
print("plaintext: \(p)")

