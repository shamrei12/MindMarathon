import UIKit

var a = [[1, 1, 2, 4, 3], [5, 4, 3, 2, 1], [9, 2, 1, 1, 2]]
var b = [[Int]]()

for i in a {
    var element = i
    b.append(sort(mass: element))
}

func sort(mass: [Int]) -> [Int] {
    return mass.sorted()
}

print(b)
