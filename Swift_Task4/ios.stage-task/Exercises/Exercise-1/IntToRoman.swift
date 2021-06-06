import Foundation

public extension Int {
    
    var roman: String? {
        guard self > 0 else {
            return nil
        }
        let dict: [(dec: Int, roman: String, value: Int)] = [
            (dec: 0, roman: "I", value: 1),
            (dec: 0, roman: "V", value: 5),
            (dec: 1, roman: "X", value: 1),
            (dec: 1, roman: "L", value: 5),
            (dec: 2, roman: "C", value: 1),
            (dec: 2, roman: "D", value: 5),
            (dec: 3, roman: "M", value: 1)
        ]
        var sSelf = self
        var numbers: [Int] = []
        while sSelf != 0 {
            numbers.insert(sSelf % 10, at: 0)
            sSelf = sSelf / 10
        }
        if let first: String = dict.compactMap({
            let p = NSDecimalNumber(decimal: pow(10, $0.dec))
            if self == ($0.value * Int(truncating: p)) {
                return $0.roman
            }
            return nil
        }).first {
            return first
        }
        
        var result = ""
        
        while !numbers.isEmpty {
            let number = numbers[0]
            numbers.removeFirst()
            
            let elements = dict.compactMap { $0.dec == numbers.count ? $0 : nil }
            print(elements)
            if let first = elements.first(where: { $0.value == number }) {
                result.append(first.roman)
                continue
            }
            
            switch number {
            case 2, 3:
                for _ in 0 ..< number {
                    result.append(elements[0].roman)
                }
            case 4:
                let subResult = elements[0].roman + elements[1].roman
                result.append(subResult)
            case 6, 7, 8:
                var subResult = elements[1].roman
                for _ in 0 ..< ( number - 5) {
                    subResult.append(elements[0].roman)
                }
                result.append(subResult)
            case 9:
                let element = dict.compactMap { $0.dec == numbers.count + 1 ? $0 : nil }[0]
                let subResult = elements[0].roman + element.roman
                result.append(subResult)
            default:
                continue
            }
        }
        
        return result
    }
}
