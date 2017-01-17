import DataHelper

public class BinaryData :  Collection, 
    CustomStringConvertible {
    
    public var data = Array<UInt8>()
    
    public init(_ data: [UInt8] = []) {
        self.data = data
    }
    public convenience init(_ input: String) {
        let bytes: [UInt8] = hexToBytes(input)
        self.init(bytes)
    }
    public var description: String {
        get { 
            return "0x" + byteArrayToHex(data) 
        }
    }
    public var startIndex: Int { 
        return 0 
    }
    public var endIndex: Int { 
        return data.count 
    }
    public func index(after i: Int) -> Int {
        return data.index(after: i)
    }
    public subscript(position: Int) -> UInt8 {
        get { 
            return data[position] 
        }
    }
    public subscript(bounds: Range<Int>) -> [UInt8] {
        get { 
            return Array(data[bounds]) 
        }
        set { 
            data[bounds] = ArraySlice(newValue) 
        }
    }
}

let b = BinaryData(nRandomBytes(10))
print(b)
let s = "\(b)"
print(s)
let b2 = BinaryData(s)
print(b2)
