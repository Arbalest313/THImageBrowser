//
//  MMUtils.swift
//  Mikoto_Swift
//
//  Created by M_Mikoto on 14/10/31.
//  Copyright (c) 2014年 m_mikoto. All rights reserved.
//
//****************************************************************************************
//  MMSwiftUtils.  Define a new operator, add some methods to system Class.
//****************************************************************************************
//

import Foundation
import UIKit


// MARK: - ** 操作符重载 **

// 自定义操作符 距离

// 不同类型数值 + - * /
func +(lhs: Int, rhs: Float) -> Float {return Float(lhs) + rhs}
func +(lhs: Int, rhs: Double) -> Double {return Double(lhs) + rhs}
func +(lhs: Int, rhs: CGFloat) -> CGFloat {return CGFloat(lhs) + rhs}
func +(lhs: Float, rhs: Int) -> Float {return lhs + Float(rhs)}
func +(lhs: Float, rhs: Double) -> Double {return Double(lhs) + rhs}
func +(lhs: Float, rhs: CGFloat) -> CGFloat {return CGFloat(lhs) + rhs}
func +(lhs: Double, rhs: Int) -> Double {return lhs + Double(rhs)}
func +(lhs: Double, rhs: Float) -> Double {return lhs + Double(rhs)}
func +(lhs: Double, rhs: CGFloat) -> CGFloat {return CGFloat(lhs) + rhs}
func +(lhs: CGFloat, rhs: Int) -> CGFloat {return lhs + CGFloat(rhs)}
func +(lhs: CGFloat, rhs: Float) -> CGFloat {return lhs + CGFloat(rhs)}
func +(lhs: CGFloat, rhs: Double) -> CGFloat {return lhs + CGFloat(rhs)}

func -(lhs: Int, rhs: Float) -> Float {return Float(lhs) - rhs}
func -(lhs: Int, rhs: Double) -> Double {return Double(lhs) - rhs}
func -(lhs: Int, rhs: CGFloat) -> CGFloat {return CGFloat(lhs) - rhs}
func -(lhs: Float, rhs: Int) -> Float {return lhs - Float(rhs)}
func -(lhs: Float, rhs: Double) -> Double {return Double(lhs) - rhs}
func -(lhs: Float, rhs: CGFloat) -> CGFloat {return CGFloat(lhs) - rhs}
func -(lhs: Double, rhs: Int) -> Double {return lhs - Double(rhs)}
func -(lhs: Double, rhs: Float) -> Double {return lhs - Double(rhs)}
func -(lhs: Double, rhs: CGFloat) -> CGFloat {return CGFloat(lhs) - rhs}
func -(lhs: CGFloat, rhs: Int) -> CGFloat {return lhs - CGFloat(rhs)}
func -(lhs: CGFloat, rhs: Float) -> CGFloat {return lhs - CGFloat(rhs)}
func -(lhs: CGFloat, rhs: Double) -> CGFloat {return lhs - CGFloat(rhs)}

func *(lhs: Int, rhs: Float) -> Float {return Float(lhs) * rhs}
func *(lhs: Int, rhs: Double) -> Double {return Double(lhs) * rhs}
func *(lhs: Int, rhs: CGFloat) -> CGFloat {return CGFloat(lhs) * rhs}
func *(lhs: Float, rhs: Int) -> Float {return lhs * Float(rhs)}
func *(lhs: Float, rhs: Double) -> Double {return Double(lhs) * rhs}
func *(lhs: Float, rhs: CGFloat) -> CGFloat {return CGFloat(lhs) * rhs}
func *(lhs: Double, rhs: Int) -> Double {return lhs * Double(rhs)}
func *(lhs: Double, rhs: Float) -> Double {return lhs * Double(rhs)}
func *(lhs: Double, rhs: CGFloat) -> CGFloat {return CGFloat(lhs) * rhs}
func *(lhs: CGFloat, rhs: Int) -> CGFloat {return lhs * CGFloat(rhs)}
func *(lhs: CGFloat, rhs: Float) -> CGFloat {return lhs * CGFloat(rhs)}
func *(lhs: CGFloat, rhs: Double) -> CGFloat {return lhs * CGFloat(rhs)}

func /(lhs: Int, rhs: Float) -> Float {return Float(lhs) / rhs}
func /(lhs: Int, rhs: Double) -> Double {return Double(lhs) / rhs}
func /(lhs: Int, rhs: CGFloat) -> CGFloat {return CGFloat(lhs) / rhs}
func /(lhs: Float, rhs: Int) -> Float {return lhs / Float(rhs)}
func /(lhs: Float, rhs: Double) -> Double {return Double(lhs) / rhs}
func /(lhs: Float, rhs: CGFloat) -> CGFloat {return CGFloat(lhs) / rhs}
func /(lhs: Double, rhs: Int) -> Double {return lhs / Double(rhs)}
func /(lhs: Double, rhs: Float) -> Double {return lhs / Double(rhs)}
func /(lhs: Double, rhs: CGFloat) -> CGFloat {return CGFloat(lhs) / rhs}
func /(lhs: CGFloat, rhs: Int) -> CGFloat {return lhs / CGFloat(rhs)}
func /(lhs: CGFloat, rhs: Float) -> CGFloat {return lhs / CGFloat(rhs)}
func /(lhs: CGFloat, rhs: Double) -> CGFloat {return lhs / CGFloat(rhs)}

// CGPoint, CGSize, CGRect
func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)}
func +(lhs: CGRect, rhs: CGRect) -> CGRect {return lhs.union(rhs)}

func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)}
func -(lhs: CGRect, rhs: CGRect) -> CGRect {return lhs.intersection(rhs)}

func *(lhs: CGPoint, rhs: CGFloat) -> CGPoint {return CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)}
func *(lhs: CGSize, rhs: CGFloat) -> CGSize {return CGSize(width: lhs.width * rhs, height: lhs.height * rhs)}
func *(lhs: CGRect, rhs: CGFloat) -> CGRect {return CGRect(origin: lhs.origin * rhs, size: lhs.size * rhs)}

