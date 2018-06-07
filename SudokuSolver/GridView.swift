//
//  GridView.swift
//  SudokuSolver
//
//  Created by Roxane Gud on 12/1/17.
//  Copyright © 2017 Roxane Markhyvka. All rights reserved.
//

import UIKit

class GridView: UIView {
    let cellSize: CGSize
    let dimensions: (x: Int, y:Int)
    let blocks: (x:Int, y: Int)
    
    init(frame: CGRect, dimensions: (x: Int, y:Int), blocks: (x:Int, y: Int), cellSize: CGSize) {
        self.dimensions = dimensions
        self.blocks = blocks
        self.cellSize = cellSize
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.dimensions = (0, 0)
        self.blocks = (0, 0)
        self.cellSize = CGSize.zero
        
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        UIColor(white: 0.95, alpha: 1).setFill()
        UIRectFill(rect)
        
        let cellSize = CGSize(width: rect.width / CGFloat(dimensions.x),
                              height: rect.width / CGFloat(dimensions.x))
        let blockSize = CGSize(width: cellSize.width * CGFloat(blocks.x),
                               height: cellSize.height * CGFloat(blocks.y))
            
        drawGrid(in: rect, lineWidth: 2.0, cellSize: cellSize, dimensions: dimensions)
        drawGrid(in: rect, lineWidth: 4.0, cellSize: blockSize, dimensions: blocks)
    }

    
    func drawGrid(in rect:CGRect, lineWidth: CGFloat, cellSize:CGSize, dimensions: (x:Int, y:Int)) {
        guard let context = UIGraphicsGetCurrentContext() else { fatalError("GridView: Could not get context!")}
        
        var startPoint = CGPoint.zero
        var endPoint = CGPoint(x: 0, y: rect.maxY)
        
        // vertical lines
        let linesCountX = dimensions.x
        for index in 0...linesCountX {
            startPoint.x = rect.origin.x+2 + CGFloat(index) * cellSize.width
            endPoint.x = rect.origin.x+2 + CGFloat(index) * cellSize.width
            drawLine(color: .black, lineWidth: lineWidth, start: startPoint, end: endPoint, context: context)
        }

        startPoint = CGPoint.zero
        endPoint = CGPoint(x: rect.maxX, y: 0)
        
        // horizontal lines
        let linesCountY = dimensions.y
        for index in 0...linesCountY {
            startPoint.y = rect.origin.y + CGFloat(index) * cellSize.height
            endPoint.y = rect.origin.y + CGFloat(index) * cellSize.height
            drawLine(color: .black, lineWidth: lineWidth, start: startPoint, end: endPoint, context: context)
        }
    }
    
    
    func drawLine(color: UIColor, lineWidth: CGFloat, start: CGPoint, end: CGPoint, context:CGContext) {
        context.setLineWidth(lineWidth);
        context.setStrokeColor(color.cgColor);
        context.move(to: CGPoint(x: start.x - lineWidth/2, y: start.y))
        context.addLine(to: CGPoint(x: end.x - lineWidth/2, y: end.y))
    
        context.strokePath();
    }


}
