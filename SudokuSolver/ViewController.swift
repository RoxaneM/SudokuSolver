//
//  ViewController.swift
//  SudokuSolver
//
//  Created by Roxane Gud on 12/1/17.
//  Copyright © 2017 Roxane Markhyvka. All rights reserved.
//

import UIKit

var zeroSudoku =
    [0, 0, 0,   0, 0, 0,  0, 0, 0,
     0, 0, 0,   0, 0, 0,  0, 0, 0,
     0, 0, 0,   0, 0, 0,  0, 0, 0,
     
     0, 0, 0,   0, 0, 0,  0, 0, 0,
     0, 0, 0,   0, 0, 0,  0, 0, 0,
     0, 0, 0,   0, 0, 0,  0, 0, 0,
     
     0, 0, 0,   0, 0, 0,  0, 0, 0,
     0, 0, 0,   0, 0, 0,  0, 0, 0,
     0, 0, 0,   0, 0, 0,  0, 0, 0]

var initialSudoku = // medium
    [3, 2, 0,   0, 0, 5,  0, 0, 0,
     0, 1, 0,   0, 0, 6,  9, 7, 2,
     0, 4, 0,   7, 0, 0,  0, 0, 0,
     
     4, 0, 0,   0, 6, 0,  3, 0, 0,
     6, 3, 9,   0, 0, 8,  2, 0, 0,
     0, 7, 0,   0, 9, 0,  6, 0, 0,
     
     7, 0, 0,   1, 5, 9,  4, 0, 0,
     5, 0, 0,   0, 0, 3,  0, 0, 9,
     0, 0, 0,   8, 0, 4,  7, 0, 6]

var initialSudoku1 = //very difficult
    [0, 0, 9,   8, 0, 0,  0, 0, 5,
     0, 7, 0,   2, 6, 0,  0, 0, 3,
     0, 0, 0,   0, 3, 0,  0, 0, 0,
     
     0, 6, 0,   0, 0, 0,  1, 0, 0,
     5, 0, 1,   0, 0, 0,  0, 0, 0,
     3, 8, 0,   4, 0, 0,  0, 9, 0,
     
     0, 0, 0,   6, 0, 7,  0, 5, 0,
     0, 0, 0,   0, 5, 0,  8, 0, 9,
     8, 0, 0,   0, 0, 0,  0, 0, 7]


class ViewController: UIViewController {
    
    let dimensions = (x: 9, y: 9)
    let blocks = (x: 3, y: 3)
    
    var sudokuView: SudokuView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        createSudokuView()
    }

    private func createSudokuView() {
        let paddingX = CGFloat(10.0)
        let paddingY = CGFloat(60.0)
        
        let sudokuFrame = CGRect(x: paddingX, y: paddingY,
                                 width: self.view.bounds.width - 2 * paddingX,
                                 height: (self.view.bounds.width - 2 * paddingX) * CGFloat(dimensions.y/dimensions.x))
        let sudokuView = SudokuView(frame: sudokuFrame,
                                    dimensions: dimensions,
                                    blocks: blocks)
        sudokuView.initialSudoku = initialSudoku1
        
        view.addSubview(sudokuView)
        self.sudokuView = sudokuView
    }

    @IBAction func reviewBlock(_ sender: Any) {
        sudokuView?.solve()
    }
    
}

