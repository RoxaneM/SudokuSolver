//
//  SudokuView.swift
//  SudokuSolver
//
//  Created by Roxane Gud on 12/1/17.
//  Copyright © 2017 Roxane Markhyvka. All rights reserved.
//

import UIKit


class SudokuView: UIView {
    
    let cellSize: CGSize
    let dimensions: (x: Int, y:Int)
    let blocks: (x:Int, y: Int)
    
    var initialSudoku = [Int]() {
        didSet {
            addCells()
        }
    }
    
    private var cellsArray = [CellView]()

    init(frame: CGRect, dimensions: (x: Int, y:Int), blocks: (x:Int, y: Int)) {
        self.dimensions = dimensions
        self.blocks = blocks
        self.cellSize = CGSize(width: frame.width / CGFloat(dimensions.x),
                               height: frame.width / CGFloat(dimensions.x))
        
        super.init(frame: frame)
        addGridView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.dimensions = (0, 0)
        self.blocks = (0, 0)
        self.cellSize = CGSize.zero
        
        super.init(coder: aDecoder)
    }
    
    private func addGridView() {
        let gridView = GridView(frame: self.bounds,
                                dimensions: dimensions,
                                blocks: blocks,
                                cellSize: cellSize)
        addSubview(gridView)
    }
    
    private func addCells() {
        var cellFrame = CGRect.zero
        cellFrame.size = cellSize
        
        for indexY in 0...dimensions.y-1 {
            for indexX in 0...dimensions.x-1 {
                cellFrame.origin.x = CGFloat(indexX) * cellSize.width
                cellFrame.origin.y = CGFloat(indexY) * cellSize.height
                
                let value = initialSudoku[indexY*dimensions.x + indexX]
                let cellView = CellView(frame: cellFrame, row: indexY, column: indexX, value: value)
                addSubview(cellView)
                cellsArray.append(cellView)
            }
        }
    }
    
    func solve() {
        let weakCount = cellsArray.filter{$0.marker == .weak}.count
        
        for blockIndexX in 0...blocks.x-1 {
            for blockIndexY in 0...blocks.y-1 {
                reviewBlock(blockIndexX, blockIndexY)
            }
        }
        
        let newWeakCount = cellsArray.filter{$0.marker == .weak}.count
        if (weakCount == newWeakCount) {// need new strategy
            //fatalError("Need new strategy or we are trapped in recursion!")
            
            for x in 0...dimensions.x-1 { fullHouseCheck(for: allForColumn(x)) }
            for y in 0...dimensions.y-1 { fullHouseCheck(for: allForRow(y)) }
            for x in 0...blocks.x-1 {
                for y in 0...blocks.y-1 { fullHouseCheck(for: allForBlock(blockX: x, blockY: y)) }
            }
        
            let newWeakCount = cellsArray.filter{$0.marker == .weak}.count
            if (weakCount == newWeakCount) {// need new strategy
                fatalError("Need new strategy or we are trapped in recursion!")
            }
        }
        
        if (!isSolvingDone()) { print ("need again") }
    }
    
    func reviewBlock(_ indexX: Int, _ indexY:Int) {
        let blockElements = allForBlock(blockX: indexX, blockY: indexY)
        reviewBlock(block: blockElements)
    }
    
    func isSolvingDone() -> Bool {
        for cell in cellsArray {
            if cell.marker == .weak {return false}
        }
        
        return true
    }

    //MARK: - find single possibles
    private func reviewBlock(block: [CellView]) {
        let controlCount = (dimensions.x / blocks.x) * (dimensions.y / blocks.y)
        guard block.count == controlCount else {
            fatalError("Block has to have exactly \(controlCount) cells, not \(block.count)")
        }
        
        var reviewAgainOnMarkerChanged = false
        for cell in block {
            if cell.marker == .weak {

                fillPossibles(for: cell)
                if cell.possibleValues.count == 1 {
                    
                    cell.markAsStrong(with: cell.possibleValues.first!)
                    //review again
                    reviewAgainOnMarkerChanged = true
                    break
                }
            }
        }
        
        if reviewAgainOnMarkerChanged { reviewBlock(block: block) }
    }
    
    private func fillPossibles(for cell: CellView) {
        let blockBuddies = getBlockBuddies(for: cell)
        let rowBuddies = getRowBuddies(for: cell)
        let columnBuddies = getColumnBuddies(for: cell)
        
        cell.resetPossibleValues()
        for rank in 1...dimensions.x {
            if isPossible(value: rank, in: blockBuddies) &&
                isPossible(value: rank, in: rowBuddies) &&
                isPossible(value: rank, in: columnBuddies) {
                
                cell.addPossibleValue(rank)
            }
        }
    }
    
    //MARK: - everybody needs full house
    
    private func fullHouseCheck(for cells: [CellView]) {
        for rank in 1...dimensions.x {
            
            var gotRankStrong = false
            var possibleCells = [CellView]()
            
            for cell in cells {
                if cell.marker == .strong {
                    
                    if cell.value == rank {
                        gotRankStrong = true
                        break // let's take another rank
                    }

                } else if cell.marker == .weak {
                    if cell.possibleValues.contains(rank) {
                        possibleCells.append(cell)
                    }
                }
            }
            
            //we have checked every cell for rank
            if (gotRankStrong) { continue } //the rank is solid
            else {
                if possibleCells.count == 1 {
                    let cell = possibleCells[0]
                    cell.markAsStrong(with: rank)
                    
                    removeFromPossibles(rank, in: getBlockBuddies(for: cell))
                    removeFromPossibles(rank, in: getRowBuddies(for: cell))
                    removeFromPossibles(rank, in: getColumnBuddies(for: cell))
                }
            }
        }
    }
    
    private func removeFromPossibles(_ value: Int, in cells: [CellView]) {
        for cell in cells {
            if cell.marker == .weak {
                cell.removePossibleValue(value)
            }
        }
    }
    
    //MARK: - get 'em!
    private func getBlockBuddies(for cell: CellView) -> [CellView] {
        let blockX = cell.column / blocks.x
        let blockY = cell.row / blocks.y
        
        return allForBlock(blockX: blockX, blockY: blockY).filter{ $0 != cell }
    }
    
    
    private func getRowBuddies(for cell: CellView) -> [CellView] {
        return allForRow(cell.row).filter{ $0 != cell }
    }
    
    
    private func getColumnBuddies(for cell: CellView) -> [CellView] {
        return allForColumn(cell.column).filter{ $0 != cell }
    }
    
    private func allForBlock(blockX: Int, blockY: Int) -> [CellView] {
        let startX = blockX * blocks.x
        let endX = startX + blocks.x - 1
        
        let startY = blockY * blocks.y
        let endY = startY + blocks.y - 1
        
        var resultArray = [CellView]()
        for x in startX...endX {
            for y in startY...endY {
                resultArray.append(cellsArray[y*dimensions.x + x])
            }
        }
        
        return resultArray
    }
    
    private func allForRow(_ row: Int) -> [CellView] {
        return cellsArray.filter{ $0.row == row }
    }
    
    private func allForColumn(_ column: Int) -> [CellView] {
        return cellsArray.filter{ $0.column == column }
    }
    
    private func isPossible(value: Int, in buddies: [CellView]) -> Bool {
        for cell in buddies {
            if cell.marker == .strong && cell.value == value {
                return false
            }
        }
        return true
    }
    
    
}
