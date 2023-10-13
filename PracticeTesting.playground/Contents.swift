import SwiftUI

let circles: [Int?] = Array(repeating: nil, count: 9)

//for circle in circles{
//    print(circle)
//}


ForEach(circles, id: \.self){ circle in
    
    let _ = print("Hello World")
    
//    return Circle()
}

//var testSet: Set<Set<Int>> = [
//    [0, 1, 2],
//    [3, 4, 5],
//    [6, 7, 8],
//    [0, 3, 6],
//    [1, 4, 7],
//    [2, 5, 8],
//    [0, 4, 8],
//    [2, 4, 6] ]
var testSet: Set<Int> = [1,2,3,4,5]
var smSet: Set<Int?> = [nil,nil,nil]
let fSet = smSet.compactMap({$0})
