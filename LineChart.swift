//
//  LineChart.swift
//  SSA
//
//  Created by Rajesh Subramonian on 11/04/19.
//  Copyright © 2019. All rights reserved.
//

import UIKit


class LineChart: UIView {
    let triangePath = UIBezierPath()
    let labelTerm = UILabel()
    let shapeLayerss = CAShapeLayer()
    
    
    var aPath = UIBezierPath()
    
    var buttonTapStatus = false
    var buttonTappedName = UIButton()
    
    var xComponents = CGFloat()
    var yComponents = CGFloat()
    
    var monthArray = [String]()
    var valueArray = [Int]()
    var xPositionsArray = [CGFloat]()
    var yPositionsArray = [CGFloat]()
    var splitUpYValues = [Int]()
    var finalYPositions = [CGFloat]()
    var finalYPositionsDict = [String : CGFloat]()
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    override func awakeFromNib() {
        
    }
    override init (frame : CGRect) {
        super.init(frame : frame)
        self.isOpaque = false
        
    }
    
    
    
    override func draw(_ rect: CGRect) {
        //If you want to stroke it with a red color
        UIColor(red:42/255, green:179/255, blue:235/255, alpha:1).set()
        aPath.stroke()
        UIColor(red:42/255, green:179/255, blue:235/255, alpha:1).setFill()
        
        //If you want to fill it as well
        aPath.fill()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func triggerChart(monthArrayIs: [String], valueArrayIs : [Int])  {
        monthArray = monthArrayIs
        valueArray = valueArrayIs
        
        generateYValues()
        
        
        
        let lcXValue = self.frame.origin.x
        let lcYValue = self.frame.origin.y
        let totalWidth = self.frame.size.width
        let totalHeight = self.frame.size.height
        let drawableWidth = totalWidth - 10
        var xAxisValues = drawableWidth /  xComponents - 40
        let firstYValue = totalHeight - 30
        
        //        print(totalWidth, drawableWidth, xAxisValues)
        
        for i in monthArray {
            xPositionsArray.append(xAxisValues)
            
            let labelOne = UILabel(frame: CGRect(x: xAxisValues, y:firstYValue, width: 30, height: 20))
            labelOne.font = UIFont.boldSystemFont(ofSize: 9)
            labelOne.text = i
            self.addSubview(labelOne)
            xAxisValues = xAxisValues + 60
            //            print(xAxisValues)
        }
        
        
        let drawableHeight = totalHeight
        var componentHeight = drawableHeight / yComponents
        var yAxisValues = drawableHeight - componentHeight - 10
        let firstXvalue = totalWidth - 10
        
        for j in splitUpYValues {
            yPositionsArray.append(yAxisValues)
            let labelOne = UILabel(frame: CGRect(x: firstXvalue, y: yAxisValues, width: 30, height: 20))
            labelOne.font = UIFont.boldSystemFont(ofSize: 9)
            //            labelOne.text = j.description
            yAxisValues = yAxisValues - 22 //to reduce height
            self.addSubview(labelOne)
            
        }
        //        print(drawableHeight)
        //        print(xPositionsArray)
        print(yPositionsArray)
        //        print(xPositionsArray[0])
        //        print(yPositionsArray[0])
        
        heartOfChart()
        
    }
    //Obtaining the y value for chart
    func generateYValues(){
        xComponents = CGFloat(monthArray.count)
        yComponents = CGFloat(valueArray.count)
        
        let yMax = valueArray.max()
        let yMin = valueArray.min()
        //        print(yMax!)
        //        print(yMin!)
        //        print(yComponents)
        
        var totalCount = CGFloat(yMax!) / yComponents
        var totalMin  = CGFloat(yMin!)
        
        
        //        splitUpYValues.append(0)
        
        for k in valueArray {
            totalMin = totalMin + totalCount
            splitUpYValues.append(Int(totalMin))
            //            print(splitUpYValues)
            //            print(k)
        }
        print(totalMin)
        
        print(splitUpYValues)
    }
    
    //MAIN PUMPING FUNCTIONALITIES REQUIRED TO PLOT THE CHART, CALCULATING WITH THE GIVEN VALUES
    func heartOfChart()   {
        print(splitUpYValues)
        
        var negatedValue = CGFloat()
        for o in valueArray {
            //            print(o)
            //            print(splitUpYValues.count)
            //            print(splitUpYValues.count-1)
            if splitUpYValues.count == 1{
                negatedValue = yPositionsArray[0]
                finalYPositions.append(negatedValue)
                
            }
            else{
                for indices in 0..<splitUpYValues.count-1{
                    //                    print(o)
                    if case splitUpYValues[indices]...splitUpYValues[indices+1] = o {
                        //                        print("\(o) is in range \(splitUpYValues[indices]) and \(splitUpYValues[indices + 1])")
                        let indicesDifference =  o - splitUpYValues[indices]
                        let indicesPlusOneDifference = splitUpYValues[indices + 1] - o
                        
                        if indicesDifference < indicesPlusOneDifference{
                            negatedValue = yPositionsArray[indices] - 5
                            finalYPositions.append(negatedValue)
                            
                        }
                        else{
                            negatedValue = yPositionsArray[indices + 1] + 5
                            finalYPositions.append(negatedValue)
                            
                        }
                        
                        
                        
                        
                    } else {
                        if o < splitUpYValues[0]{
                            if o == 0{
                                //                            print("\(o) is equal to \(splitUpYValues[0])")
                                negatedValue = yPositionsArray[0] + 10
                                finalYPositions.append(negatedValue)
                                break
                            }
                            else{
                                //                            print("\(o) is less than \(splitUpYValues[0])")
                                negatedValue = yPositionsArray[0]
                                finalYPositions.append(negatedValue)
                                
                                break
                                
                            }
                        }
                        else{
                            //                            print("\(o) is not in range 4-20")
                            
                        }
                    }
                    
                }
            }
            
            
        }
        
        
        //        print(splitUpYValues)
        //        print(xPositionsArray)
        //        print(finalYPositions)
        for m in xPositionsArray.indices {
            
            drawCircle(xPosition: xPositionsArray[m] , yPosition: finalYPositions[m], indexValue: m)
        }
        
        drawLineAndGiveColor(xPosition: 0, yPosition: finalYPositions[0])
    }
    
    
    //DRAWING THE PATH TO PROVIDE THE REQUIRED COLOR
    func drawLineAndGiveColor(xPosition: CGFloat, yPosition: CGFloat){
        
        aPath.move(to: CGPoint(x:0, y:yPosition + 35))
        for indexPosition in xPositionsArray.indices{
            aPath.addLine(to: CGPoint(x:xPositionsArray[indexPosition] + 12.5, y:finalYPositions[indexPosition] + 12.5))
            
        }
        aPath.addLine(to: CGPoint(x:self.frame.origin.x + self.frame.size.width, y: finalYPositions[finalYPositions.count-1] + 12.5))
        aPath.addLine(to: CGPoint(x:self.frame.size.width , y: self.frame.size.height))
        aPath.addLine(to: CGPoint(x:0 , y: self.frame.size.height))
        aPath.move(to: CGPoint(x:0, y:yPosition))
        
        //        aPath.addLine(to: CGPoint(x:self.frame.origin.x  + self.frame.size.width, y: 0))
        //        aPath.addLine(to: CGPoint(x:0 , y: 0))
        
        
        //Keep using the method addLineToPoint until you get to the one where about to close the path
        
        aPath.close()
        
        
        setNeedsDisplay()
        
        
    }
    
    //DEFINING THE TAPABLE ROUND BUTTONS
    func drawCircle(xPosition: CGFloat, yPosition: CGFloat, indexValue: Int){
        
        let btnFloor = UIButton()
        btnFloor.backgroundColor = UIColor.white
        btnFloor.frame = CGRect(x: xPosition, y: yPosition, width: 25, height: 25)
        btnFloor.layer.cornerRadius = btnFloor.frame.size.width/2
        btnFloor.layer.masksToBounds = false
        
        //        btnFloor.contentMode = UIViewContentMode.scaleToFill
        //        btnY += btnHeight + 5
        btnFloor.tag = indexValue
        let textTitle : String = "$" + "\(valueArray[indexValue])"
        
        btnFloor.setTitle(textTitle, for: .normal)
        btnFloor.addTarget(self, action: #selector(self.btnTappedFloor(_:)), for: UIControl.Event.touchUpInside)
        self.addSubview(btnFloor)
        btnFloor.setTitleColor(.clear, for: .normal)
        
        if indexValue + 1 == xPositionsArray.count{
            drawLabelAboveTouchPoint(xPoint: btnFloor.frame.origin.x, yPoint: btnFloor.frame.origin.y, labelText: btnFloor.title(for: .normal) ?? "")
            btnFloor.backgroundColor = UIColor(red:0/255, green:255/255, blue:0/255, alpha:1)
            buttonTapStatus = true
            buttonTappedName = btnFloor
            
        }
        
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: xPosition + 12.5,y: yPosition + 12.5), radius: CGFloat(5), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        //change the fill color
        shapeLayer.fillColor =  UIColor(red:16/255, green:49/255, blue:65/255, alpha:1).cgColor
        //you can change the stroke color
        shapeLayer.strokeColor =  UIColor(red:16/255, green:49/255, blue:65/255, alpha:1).cgColor
        //you can change the line width
        shapeLayer.lineWidth = 3.0
        
        self.layer.addSublayer(shapeLayer)
        
    }
    
    //THE LABEL TO BE DISPLAYED ON ROUND BUTTON CLICK
    func drawLabelAboveTouchPoint(xPoint: CGFloat, yPoint: CGFloat, labelText: String)   {
        triangePath.removeAllPoints()
        
        shapeLayerss.removeFromSuperlayer()
        labelTerm.removeFromSuperview()
        triangePath.move(to: CGPoint(x:xPoint + 10, y:yPoint))
        triangePath.addLine(to: CGPoint(x:xPoint + 5, y:yPoint - 10))
        triangePath.addLine(to: CGPoint(x:xPoint + 15, y:yPoint - 10))
        triangePath.addLine(to: CGPoint(x:xPoint + 10, y:yPoint))
        
        shapeLayerss.path = triangePath.cgPath
        self.layer.addSublayer(shapeLayerss)
        
        
        labelTerm.backgroundColor = UIColor(red:16/255, green:49/255, blue:65/255, alpha:1)
        labelTerm.frame = CGRect(x: xPoint - 20, y: yPoint - 40, width: 70, height: 30)
        labelTerm.layer.cornerRadius = 5
        labelTerm.layer.masksToBounds = true
        labelTerm.textColor = UIColor(red:255/255, green:255/255, blue:255/255, alpha:1)
        labelTerm.text = labelText
        labelTerm.textAlignment = .center
        self.addSubview(labelTerm)
        
    }
    
    func drawStatusView() {
        let topView = UIView(frame: CGRect(x: self.frame.origin.x, y:self.frame.origin.y - 100, width: self.frame.size.width, height: 80))
        topView.backgroundColor = UIColor.red
        self.superview?.addSubview(topView)
    }
    //ROUND BUTTON EVENT
    @objc func btnTappedFloor( _ button : UIButton)
    {
        
        if buttonTapStatus == true{
            
            triangePath.removeAllPoints()
            shapeLayerss.removeFromSuperlayer()
            labelTerm.removeFromSuperview()
            
            buttonTappedName.backgroundColor = UIColor.white
            buttonTapStatus = false
            
            if buttonTappedName == button{
                
            }else{
                drawLabelAboveTouchPoint(xPoint: button.frame.origin.x, yPoint: button.frame.origin.y, labelText: button.title(for: .normal) ?? "")
                button.backgroundColor = UIColor(red:0/255, green:255/255, blue:0/255, alpha:1)
                buttonTapStatus = true
                
            }
        }
        else{
            
            drawLabelAboveTouchPoint(xPoint: button.frame.origin.x, yPoint: button.frame.origin.y, labelText: button.title(for: .normal) ?? "")
            button.backgroundColor = UIColor(red:0/255, green:255/255, blue:0/255, alpha:1)
            buttonTapStatus = true
        }
        buttonTappedName = button
        
    }
    
    
    
    
}
