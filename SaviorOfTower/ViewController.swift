//
//  ViewController.swift
//  SaviorOfTower
//
//  Created by David on 2015/6/1.
//  Copyright (c) 2015年 David. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var runePanel: UIView!
    var runeContainer: [[UIView]]!

    var runeRockWidth: CGFloat!
    
    // 標記浮時
    var runeConnectionMarker: [[Int]]!
    
    let fireRune = UIImageView(image: UIImage(named: "fire.png"))
    let woodRune = UIImageView(image: UIImage(named: "wood.png"))
    let lightRune = UIImageView(image: UIImage(named: "light.png"))
    let darkRune = UIImageView(image: UIImage(named: "dark.png"))
    let heartRune = UIImageView(image: UIImage(named: "heart.png"))
    let waterRune = UIImageView(image: UIImage(named: "water.png"))
    var runes: [UIImageView]!
    
    var lastPosition: (row: Int, column: Int)!
    
    var tick: [AVAudioPlayer]!
    var dis: [AVAudioPlayer]!
    var disLoop: Int!
    

    @IBAction func recoverRunes(sender: AnyObject) {
        if self.runeContainer != nil {
            for row in self.runeContainer {
                for element in row {
                    element.hidden = false
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        runeRockWidth = self.view.frame.width / 6
        println(runeRockWidth)
        
        self.runePanel = UIView(frame: CGRectMake(0, 0, runeRockWidth * 6, runeRockWidth * 5))
        runePanel.frame.origin.y = self.view.frame.height - self.runePanel.frame.height
        
        runePanel.backgroundColor = UIColor.brownColor()
        
        self.view.addSubview(runePanel)
        
        self.runes = [fireRune, woodRune, lightRune, darkRune, heartRune, waterRune]
        
        self.addColorToRunePanel()
        self.setupRuneContainer()
        
        let path = NSBundle.mainBundle().pathForResource("tick(1)", ofType: "mp3")
        let url = NSURL(fileURLWithPath: path!)
        
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        
        self.tick = []
        for i in 1...30 {
            self.tick.append(AVAudioPlayer(contentsOfURL: url, error: nil))
            self.tick[i-1].prepareToPlay()
        }
        
        let p2 = NSBundle.mainBundle().pathForResource("dis2", ofType: "mp3")
        let url2 = NSURL(fileURLWithPath: p2!)
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        self.dis = []
        for i in 1...10 {
            self.dis.append(AVAudioPlayer(contentsOfURL: url2, error: nil))
            self.dis[i-1].prepareToPlay()
        }
        
        // 初始化marker, -1 是nil
        self.runeConnectionMarker = [
                                        [-1,-1,-1,-1,-1,-1],
                                        [-1,-1,-1,-1,-1,-1],
                                        [-1,-1,-1,-1,-1,-1],
                                        [-1,-1,-1,-1,-1,-1],
                                        [-1,-1,-1,-1,-1,-1]
                                    ]
    }
    
    func addColorToRunePanel() {
        
        for i in 0...5 {
            for j in 0...4 {
                if i % 2 == 0 {
                    var view = UIView(frame: CGRectMake(CGFloat(i) * self.runeRockWidth, CGFloat(j) * self.runeRockWidth, self.runeRockWidth, self.runeRockWidth))
                    view.backgroundColor = UIColor.grayColor()
                    if j % 2 == 0 {
                        view.frame.origin.x += self.runeRockWidth
                    }
                    self.runePanel.addSubview(view)
                }
            }
        }
    }
    
    func setupRuneContainer() {
        self.runeContainer = [[], [], [], [], []]
        for i in 0...4 {
            for j in 0...5 {
                var v = self.generateRuneWithRow(i+1, column: j+1)
                self.runePanel.addSubview(v)
                self.runePanel.bringSubviewToFront(v)
                self.runeContainer[i].append(v)
            }
        }
        println("鎮列是:\(self.runeContainer)")
    }
    
    func generateRuneWithRow(row: Int, column: Int) -> UIView {
        println("now is \(row), \(column)")
        var rune = UIView(frame: CGRectMake(0, 0, self.runeRockWidth * 0.9, self.runeRockWidth * 0.9))
        var runeImg = UIImageView(frame: CGRectMake(0, 0, self.runeRockWidth * 0.9, self.runeRockWidth * 0.9))
        var y = self.runeRockWidth / 2 + CGFloat(row - 1) * self.runeRockWidth
        var x = self.runeRockWidth / 2 + CGFloat(column - 1) * self.runeRockWidth
        rune.center = CGPointMake(x, y)
        
        rune.layer.cornerRadius = 10
        var hi = Int(arc4random()%6)
        runeImg.image = self.runes[hi].image
        rune.addSubview(runeImg)
        
        //pan gesture
        var g = UIPanGestureRecognizer(target: self, action: "panning:")
        g.minimumNumberOfTouches = 1
        g.maximumNumberOfTouches = 1
        rune.addGestureRecognizer(g)
        
        return rune
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        println("開始")
        for touch in touches {
            self.lastPosition = self.getPositionUsingPoint((touch as! UITouch).locationInView(self.runePanel))
        }
        
    }
    
    func panning(gesture: UIPanGestureRecognizer) {
        
//        if gesture.state == UIGestureRecognizerState.Began {
//            println("began")
//            self.lastPosition = self.getPositionUsingPoint(gesture.locationInView(self.runePanel))
//        }
        if gesture.state == UIGestureRecognizerState.Changed {
//            println("changin")
//            println(gesture.view?.center)
//            println(gesture.locationInView(self.runePanel))
            // dragging
            gesture.view?.center = gesture.locationInView(self.runePanel)
            
//            println(gesture)

//            println()
//            println(self.getPositionUsingPoint(gesture.locationInView(self.runePanel)))
            
            if gesture.view?.center.y <= self.runeRockWidth / 2 {
//                println("上")
                gesture.view?.center.y = self.runeRockWidth / 2
            }
            if gesture.view?.center.y >= self.runePanel.frame.height - self.runeRockWidth / 2 {
//                println("下")
                gesture.view?.center.y = self.runePanel.frame.height - self.runeRockWidth / 2
            }
            if gesture.view?.center.x <= self.runeRockWidth / 2 {
//                println("左")
                gesture.view?.center.x = self.runeRockWidth / 2
            }
            if gesture.view?.center.x >= self.runePanel.frame.width - self.runeRockWidth / 2 {
//                println("又")
                gesture.view?.center.x = self.runePanel.frame.width - self.runeRockWidth / 2
            }
            
            // 交換
            var thisPosition = self.getPositionUsingPoint(gesture.locationInView(self.runePanel))
//            println("現在是： \(thisPosition)")
//            println("剛剛是：\(self.lastPosition )")
            if self.lastPosition.row != thisPosition.row || self.lastPosition.column != thisPosition.column {
                
                self.swapRune(thisPosition, this: self.lastPosition)
                
                println("swaping \(thisPosition) -> \(self.lastPosition)")
                // swap this to last
                self.lastPosition = thisPosition

            }
            self.lastPosition = self.getPositionUsingPoint(gesture.locationInView(self.runePanel))
//            println("now on \(self.lastPosition)")
        } else if gesture.state == UIGestureRecognizerState.Ended {
            println("ending")
            
            // 交換
            var thisPosition = self.getPositionUsingPoint(gesture.locationInView(self.runePanel))
            if self.lastPosition.row != thisPosition.row || self.lastPosition.column != thisPosition.column {
                
                self.swapRune(thisPosition, this: self.lastPosition)
                
                println("swaping \(thisPosition) -> \(self.lastPosition)")
                // swap this to last
                self.lastPosition = thisPosition
                
            }
            
            var x = CGFloat(self.lastPosition.column - 1) * self.runeRockWidth + self.runeRockWidth / 2
            var y = CGFloat(self.lastPosition.row - 1) * self.runeRockWidth + self.runeRockWidth / 2
            gesture.view?.center = CGPointMake(x, y)
            
            // 偵測
            self.detectConnection()
//            self.lastPosition = self.getPositionUsingPoint(gesture.locationInView(self.runePanel))
        } else if gesture.state == UIGestureRecognizerState.Cancelled {
            println("cancel")
        } else if gesture.state == UIGestureRecognizerState.Failed {
            println("fail")
        } else if gesture.state == UIGestureRecognizerState.Possible {
            println("possible")
        }
    }
    
    func getPositionUsingPoint(point: CGPoint) -> (row: Int, column: Int) {
        
        var row = Int((point.y) / self.runeRockWidth) + 1
        var column = Int((point.x) / self.runeRockWidth) + 1
        
        if row < 1 {
            row = 1
        }
        
        if column < 1 {
            column = 1
        }
        
        return (row, column)
    }
    
    func getPointUsingPosition(position: (row: Int, column: Int)) -> CGPoint {
        
        var x = CGFloat(position.column - 1) * self.runeRockWidth + self.runeRockWidth / 2
        var y = CGFloat(position.row - 1) * self.runeRockWidth + self.runeRockWidth / 2
        
        return CGPointMake(x, y)
    }
    
    func swapRune(that: (row: Int, column: Int), this: (row: Int, column: Int)) {
        
        // animation
        var thatView = self.runeContainer[that.row - 1][that.column - 1]
        var toPoint = self.getPointUsingPosition(this)
        UIView.animateWithDuration(0.05, animations: {
            thatView.center = toPoint
        })
        // play music
        dispatch_async(dispatch_get_main_queue()) {
            self.tick[(that.row-1)*6+that.column-1].play()
        }
        
        // swap
        var tmp = self.runeContainer[this.row - 1][this.column - 1]
        self.runeContainer[this.row - 1][this.column - 1] = self.runeContainer[that.row - 1][that.column - 1]
        self.runeContainer[that.row - 1][that.column - 1] = tmp
    }
    
    // 偵測連線
    func detectConnection() {
        
        self.resetMarker()
        
        for i in 0...5 {
            // column
            for row in 0...2 {
                if (self.runeContainer[0 + row][i].subviews[0] as! UIImageView).image == (self.runeContainer[1 + row][i].subviews[0] as! UIImageView).image && (self.runeContainer[0 + row][i].subviews[0] as! UIImageView).image == (self.runeContainer[2 + row][i].subviews[0] as! UIImageView).image {
                    // 1,2,3 連線
                    let imgV = self.runeContainer[2 + row][i].subviews[0] as! UIImageView
                    let rune = self.getRuneName(imgV)
                    println("okokok from \(row), and it's \(rune.name)")
                    // mark connection
                    self.runeConnectionMarker[0 + row][i] = rune.number
                    self.runeConnectionMarker[1 + row][i] = rune.number
                    self.runeConnectionMarker[2 + row][i] = rune.number
                }
            }
        }
        
        for i in 0...4 {
            for column in 0...3 {
                if (self.runeContainer[i][0 + column].subviews[0] as! UIImageView).image == (self.runeContainer[i][1 + column].subviews[0] as! UIImageView).image && (self.runeContainer[i][0 + column].subviews[0] as! UIImageView).image == (self.runeContainer[i][2 + column].subviews[0] as! UIImageView).image {
                    let imgV = self.runeContainer[i][2 + column].subviews[0] as! UIImageView
                    let rune = self.getRuneName(imgV)
                    println("from \(column) its ok, and its \(rune.name)")
                    //mark conection
                    self.runeConnectionMarker[i][0 + column] = rune.number
                    self.runeConnectionMarker[i][1 + column] = rune.number
                    self.runeConnectionMarker[i][2 + column] = rune.number
                }
            }
        }
        
        println("好，偵測完畢")
        for i in 0...4 {
            println(self.runeConnectionMarker[i])
        }
        self.queryConnectionRunes()
    }
    
    // 取得浮時名字
    func getRuneName(imgView: UIImageView) -> (name: NSString, number: Int) {
        
        var runeName = ["fireRune", "woodRune", "lightRune", "darkRune", "heartRune", "waterRune"]
        
        for i in 0...5 {
            if self.runes[i].image == imgView.image {
                return (runeName[i], i)
            }
        }
        
        return ("", -1)
    }
    
    // 佇列待消除符石
    func queryConnectionRunes() {
        
        var query = [[[AnyObject]]]()
        
        println(query)
        
        for row in 0...4 {
            for column in 0...5 {
                if self.runeConnectionMarker[row][column] != -1 {
                    println(self.runeConnectionMarker[row][column])
                    // 一開始還沒有佇列
                    var isQueried = false
                    for (index, bunchRune) in enumerate(query) {
                        // 把每一堆rune拿出來比較
//                        query[index].append([self.runeConnectionMarker[row][column], row, column])
                        for rune in bunchRune {
                            // 每一個比較
                            if self.runeConnectionMarker[row][column] == rune[0] as! Int {
                                // 比較屬性
                                if (column - 1 == rune[2] as! Int || column + 1 == rune[2] as! Int) && row == rune[1] as! Int {
                                    // 現在為只左右如果有rune，折true
                                    // 而且要同一row
                                    println("debug GOGO")
                                    println(column - 1 == rune[2] as! Int)
                                    println(column + 1 == rune[2] as! Int)
                                    println(row == rune[1] as! Int)
                                    query[index].append([self.runeConnectionMarker[row][column], row, column])
                                    isQueried = true
                                    println("r=\(rune[1] as! Int), c=\(rune[2] as! Int)")
                                    println("這邊變成處\(isQueried)")
                                    break
                                }
                                // 比較上面，落單的。
                                // 幹這邊意外把下面及特殊情況解掉了
                                // 不過
                                // oooxxx
                                // xxxooo
                                // 這樣會錯
                                if row != 0 && !isQueried {
                                    // 不可以是最上面一排
                                    if row - 1 == rune[1] as! Int {
                                        // 判斷右邊有沒有，沒有不能query
                                        // 這邊只判斷正上方
                                        if self.runeConnectionMarker[row][column] == self.runeConnectionMarker[row - 1][column] {
                                            println("喔！上面有！")
                                            println(self.runeConnectionMarker[row][column])
                                            println(self.runeConnectionMarker[row - 1][column])
                                            query[index].append([self.runeConnectionMarker[row][column], row, column])
                                            isQueried = true
                                            break
                                        } else {
                                            println("不是正上方有，能可下面")
                                            if column >= 2 && (row < 4 && column < 5){
                                                println("西大於二")
                                                for r in self.runeConnectionMarker {
                                                    println(r)
                                                }
//                                                println(self.runeConnectionMarker[row + 1][column])
//                                                println(self.runeConnectionMarker[row + 1][column-1])
//                                                println(self.runeConnectionMarker[row + 1][column-2])
                                                if self.runeConnectionMarker[row][column] == self.runeConnectionMarker[row + 1][column] && self.runeConnectionMarker[row][column] == self.runeConnectionMarker[row + 1][column - 1] && self.runeConnectionMarker[row][column] == self.runeConnectionMarker[row + 1][column - 2] {
                                                    println("喔喔喔喔喔！")
//                                                    query[index].append([self.runeConnectionMarker[row][column], row, column])
//                                                    isQueried = true
//                                                    break
                                                }
                                            }
                                            println("state:\(isQueried)")
                                        }
                                    }
                                }
                                // 極特殊情況
//                                 /->O
//                                O->O
                                // 又上以及右邊有
                                if !isQueried {
                                    println("早安少女組")
                                    if row != 0 && column != 5 {
                                        println("但斷Y字")
//                                        println("r=\(row), c=\(column)")
//                                        println("又：\(self.runeConnectionMarker[row][column + 1])")
//                                        println("自己：\(self.runeConnectionMarker[row][column])")
                                        // 不是第一row，也不是最右邊
                                        if self.runeConnectionMarker[row - 1][column + 1] == self.runeConnectionMarker[row][column] {
                                            // 如果與右上角一樣，則判斷右方是否一樣
                                            if self.runeConnectionMarker[row][column] == self.runeConnectionMarker[row][column + 1] {
                                                println("十字情況")
                                                query[index].append([self.runeConnectionMarker[row][column], row, column])
                                                isQueried = true
                                                break
                                            }
                                        }
                                    }
                                }
                                println("特殊的出來\(isQueried)")
                            }
                        }
                        if isQueried {
                            break
                        }
                    }
                    //如果都沒有佇列，塞新的佇列
                    println("💀 斷開佇列\(isQueried)")
                    if !isQueried {
                        query.append([[self.runeConnectionMarker[row][column], row, column]])
                    }
                }
            }
        }
        
        println("q完")
        for q in query {
            println(q)
        }
        // oooxxx
        // xxxxoo
        // 特殊情況要link起來
        for i in 1...5 {
            // 做五次以防萬一
            var isOver = false
            for (i, abunchRune) in enumerate(query) {
                // 每一行
                if !isOver {
                    for index in 0...(query.count - 1) {
                        // 全部比一次
                        if index != i && !isOver {
                            if checkRepeat(abunchRune, a2: query[index]) {
                                println("幹一樣耶！")
                                var set1 = NSSet(array: abunchRune)
                                var set2 = NSMutableSet(array: query[index])
                                set2.unionSet(set1 as Set<NSObject>)
                                var array = [[AnyObject]]()
                                for s in set2 {
                                    array.append(s as! [Int])
                                }
                                var some = array as [([(AnyObject)])]
                                println("數q\(query.count)")
                                query[i] = array as [([(AnyObject)])]
                                query.removeAtIndex(index)
                                isOver = true
                            }
                        }
                    }
                }
            }
        }
        println("包包")
        for q in query {
            println(q)
        }
        
        self.disLoop = query.count
//        NSTimer.scheduledTimerWithTimeInterval(0.8, target: self, selector: "startDisappear", userInfo: nil, repeats: true)
        for (index, q) in enumerate(query) {
            var delay = dispatch_time(DISPATCH_TIME_NOW, Int64( 0.3 * Double(index) * Double(NSEC_PER_SEC)))
            dispatch_after(delay, dispatch_get_main_queue()) {
                println("index-->\(index)")
                for element in q {
                    println(element)
                    self.dis[index].play()
                    // 消除符石
                    var row = element[1] as! Int
                    var column = element[2] as! Int
                    var rune = self.runeContainer[row][column]
                    rune.hidden = true
                }
                if index == (query.count - 1) {
                    println("index\(index), delay\(delay)")
                    delay = dispatch_time(DISPATCH_TIME_NOW, Int64( 0.6 + 0.3 * Double(index) * Double(NSEC_PER_SEC)))
                    dispatch_after(delay, dispatch_get_main_queue()) {
                        self.swapHiddenRuneToTop()
                        self.generateNewRunesToPanel()
                        self.fallRunesToBottom()
                    }
                }
            }
        }
    }
    
    // swap hidden rune to top 
    func swapHiddenRuneToTop() {
        println("開始囉")
        
        var aNewContainer = [[], [], [], [], []] as [[UIView]]
        
        for column in 0...5 {
            var aColumn = [] as [UIView]
            var aFalseColumn = [] as [UIView]
            for row in 0...4 {
                // 每個直排。抓出還在的
                var rune = self.runeContainer[row][column]
                println(rune.hidden)
                if !rune.hidden {
                    aColumn.append(rune)
                } else {
                    aFalseColumn.append(rune)
                }
            }
            // 反轉囉
            aColumn = aColumn.reverse()
            
            // 排進去囉
            for (index, rune) in enumerate(aColumn) {
                aNewContainer[4 - index].append(rune)
            }
            for (index, rune) in enumerate(aFalseColumn) {
                aNewContainer[index].append(rune)
            }
        }
        
        println("🍎🍎🍎🍎🍎🍎")
        self.runeContainer = aNewContainer
        for i in self.runeContainer {
            for j in i {
                print("\(j.hidden), ")
            }
            println()
        }
    }
    
    // generate first then fall
    func generateNewRunesToPanel() {
        println("gg")
        for column in 0...5 {
            // loop for 1~6
            var runeCountNeedToGenerate = 0
            var aNewColumn = [] as [UIView]
            for row in 0...4 {
                var rune = self.runeContainer[row][column]
                if rune.hidden {
                    println("ㄏ一你看不見我")
                    runeCountNeedToGenerate += 1
                    // 換符石喔喔喔喔喔
                    var runeFace = rune.subviews[0] as! UIImageView
                    var imageV = self.runes[Int(arc4random()%6)]
                    runeFace.image = imageV.image
                    // 加好
                    aNewColumn.append(rune)
                    // 看見你。
                    rune.hidden = false
                }
                // 移動位置
                println("🍎我在移動")
                aNewColumn = aNewColumn.reverse()
                for (index, rune) in enumerate(aNewColumn) {
                    rune.center.y = -(CGFloat(index) * self.runeRockWidth) - self.runeRockWidth / 2
                }
            }
        }
    }
    
    
    func fallRunesToBottom() {
//        UIView.animateWithDuration(0.5, animations: {
//            for row in 0...4 {
//                for column in 0...5 {
//                    var rune = self.runeContainer[row][column]
//                    rune.center.y = CGFloat(row) * self.runeRockWidth + self.runeRockWidth / 2
//                }
//            }
//        })
        UIView.animateWithDuration(0.3, delay: 0.3, options: nil, animations: {
                for row in 0...4 {
                    for column in 0...5 {
                        var rune = self.runeContainer[row][column]
                        rune.center.y = CGFloat(row) * self.runeRockWidth + self.runeRockWidth / 2
                    }
                }
            }, completion: { (isFinish: Bool) -> Void in
                var delay = dispatch_time(DISPATCH_TIME_NOW, Int64( 0.2 * Double(NSEC_PER_SEC)))
                dispatch_after(delay, dispatch_get_main_queue()) {
                    self.detectConnection()
                }
        })
    }
    
    func checkRepeat(a1: [[AnyObject]], a2: [[AnyObject]]) -> Bool {
        
        for element in a1 {
            for shit in a2 {
                if element as! [Int] == shit  as! [Int] {
                    return true
                }
            }
        }
        
        return false
    }
    
    // 重至marker
    func resetMarker() {
        self.runeConnectionMarker = [
                                        [-1,-1,-1,-1,-1,-1],
                                        [-1,-1,-1,-1,-1,-1],
                                        [-1,-1,-1,-1,-1,-1],
                                        [-1,-1,-1,-1,-1,-1],
                                        [-1,-1,-1,-1,-1,-1]
                                    ]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

