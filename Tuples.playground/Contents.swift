var t = ("a","b")
t.0    // "a"
// t.0 = 1    error

var u = (x: "a", y: "b")
u.x   // "a"

var c = 123
// print(c.0)   error

var(x,y,z) = (1,2,3)
(x,y) = (y,x)
(x,y,z)       // 2, 1, 3

func divmod(_ a: Int, _ b:Int) -> (Int, Int) {
    return (a / b, a % b)
}

divmod(7,3)    // 2,1

enum HandShape: Int, Hashable {
    case rock = 0
    case paper = 1
    case scissors = 2
    var hashValue: Int  {
        return self.rawValue
    }
}

enum MatchResult: Int {
    case lose = -1
    case draw =  0
    case win  =  1
}

func match(_ lhs: HandShape, _ rhs: HandShape) -> MatchResult {
    if lhs == rhs { return .draw }
    if lhs == .rock && rhs == .paper { return .lose }
    if lhs == .paper && rhs == .scissors { return .lose }
    if lhs == .scissors && rhs == .rock { return .lose }
    return .win
}

match(.rock, .scissors)

// lots of boilerplate to make tuple hashable

struct dup: Hashable {
    var x, y:  HandShape
    var hashValue: Int  {
        return x.rawValue + y.rawValue * 10
    }
}

extension dup: Equatable {
    static func == (lhs: dup, rhs: dup) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

let t1: dup = dup (x: .rock, y: .scissors)
let t2: dup = dup (x: .scissors, y: .paper)
let t3: dup = dup (x: .paper, y: .rock)
var D: [dup:MatchResult] = [:]
for e in [t1,t2,t3] { D[e] = .win }

func match2(_ lhs: HandShape, _ rhs: HandShape) -> MatchResult {
    if lhs == rhs { return .draw }
    let t = dup(x: lhs, y: rhs)
    if D.index(forKey: t) == nil {
        return .lose
    }
    return .win
}

match2(.rock,.scissors)
match2(.scissors,.rock)
match2(.rock,.rock)

