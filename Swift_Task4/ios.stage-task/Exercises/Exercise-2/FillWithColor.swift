import Foundation

final class FillWithColor {
    
    func fillWithColor(_ image: [[Int]], _ row: Int, _ column: Int, _ newColor: Int) -> [[Int]] {
        
        var handledPx: Set<[Int]> = .init()
        var coloredPx: Set<[Int]> = .init()
        
        let pxInit = image[row][column]
        coloredPx.insert([row, column])
        
        while coloredPx.count != handledPx.count {
            guard let px = coloredPx.first(where: { !handledPx.contains($0) }) else {
                break
            }
            let row = px[0]
            let col = px[1]
            
            // left
            if col - 1 >= 0 {
                if image[row][col - 1] == pxInit {
                    coloredPx.insert([row, col - 1])
                }
            }
            
            // top
            if row - 1 >= 0 {
                if image[row - 1][col] == pxInit {
                    coloredPx.insert([row - 1, col])
                }
            }
            
            // right
            if image[row].endIndex - 1 >= col + 1 {
                if image[row][col + 1] == pxInit {
                    coloredPx.insert([row, col + 1])
                }
            }
            
            // bottom
            if image.endIndex - 1 >= row + 1 {
                if image[row + 1][col] == pxInit {
                    coloredPx.insert([row + 1, col])
                }
            }

            handledPx.insert([row, col])
        }
        
        var result = image
        for item in handledPx {
            result[item[0]][item[1]] = newColor
        }
        
        return result
    }
}
