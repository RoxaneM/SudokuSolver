//
//  CellView.swift
//  SudokuSolver
//
//  Created by Roxane Gud on 12/2/17.
//  Copyright © 2017 Roxane Markhyvka. All rights reserved.
//

import UIKit
enum MarkerType {
    case weak
    case strong
}

class CellView: UIView {
    private let valueLabel: UILabel
    private let possibleLabel: UILabel
    
    let row: Int
    let column: Int
    
    private(set) var value: Int {
        didSet {
            self.valueLabel.text = "\(value)"
        }
    }
    
    private(set) var marker: MarkerType {
        didSet {
            if marker == .strong {
                resetPossibleValues()
                possibleLabel.isHidden = true
            }
        }
    }
    
    private(set) var possibleValues = Set<Int>()
    
    override var description: String {
        return "Cell[\(row), \(column)], value: \(value), marker: \(marker)"
    }
    
    init(frame: CGRect, row: Int, column: Int, value: Int = 0) {
        self.value = value
        self.row = row
        self.column = column
        
        let labelFrame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        valueLabel = UILabel(frame: labelFrame)
        valueLabel.textAlignment = .center
        valueLabel.font = UIFont.systemFont(ofSize: 24.0, weight: .bold)
        valueLabel.text = value == 0 ? "" : "\(value)"
        valueLabel.textColor = value == 0 ? .black : .red 
        
        let possibleLabelHeight = frame.height / CGFloat(3.0)
        let possibleLabelPadding = CGFloat(2.0)
        let possibleLabelFrame = CGRect(x: possibleLabelPadding,
                                        y: 0,
                                        width: frame.width - 2*possibleLabelPadding,
                                        height: possibleLabelHeight)
        possibleLabel = UILabel(frame: possibleLabelFrame)
        possibleLabel.font = UIFont.systemFont(ofSize: possibleLabelHeight - 2, weight: .bold)
        possibleLabel.textColor = .blue
        possibleLabel.adjustsFontSizeToFitWidth = true
        
        marker = value == 0 ? .weak : .strong
        
        super.init(frame: frame)
        addSubview(valueLabel)
        addSubview(possibleLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        self.valueLabel = UILabel()
        self.possibleLabel = UILabel()
        self.marker = .weak
        self.value = 0
        self.row = 0
        self.column = 0

        super.init(coder: aDecoder)
    }
    
    func addPossibleValue(_ value: Int) {
        possibleValues.insert(value)
        possibleLabel.text = possibleValues.flatMap({"\($0)"}).joined(separator: " ")
    }
    
    func removePossibleValue(_ value: Int) {
        possibleValues.remove(value)
        possibleLabel.text = possibleValues.flatMap({"\($0)"}).joined(separator: " ")
    }
    
    func resetPossibleValues() {
        possibleValues = Set<Int>()
    }
    
    func markAsStrong(with value: Int) {
        self.value = value
        self.marker = .strong
    }
}
