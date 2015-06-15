//
//  animateViewController.swift
//  SaviorOfTower
//
//  Created by David on 2015/6/8.
//  Copyright (c) 2015年 David. All rights reserved.
//

import UIKit

class animateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var g = UITapGestureRecognizer(target: self, action: "tap:")
        self.view.addGestureRecognizer(g)
        var w = self.navigationController?.view.frame.width
        var h = self.navigationController?.view.frame.height
        var v = UIView(frame: CGRectMake(0, 0, w!, h!))
        v.backgroundColor = UIColor.blackColor()
        v.alpha = 0.7
//        self.navigationController?.view.addSubview(v)
        self.view.addSubview(v)
    }
    
    func tap(g: UITapGestureRecognizer) {
        println("tap!")
        var up = UIView(frame: CGRectMake(0, 0, 30, 30))
        up.backgroundColor = UIColor.redColor()
        up.layer.cornerRadius = 15
        var point = g.locationInView(self.view)
        up.center = point
        up.alpha = 0.5
        
        self.view.addSubview(up)
        
        var down = UIView(frame: CGRectMake(0, 0, 30, 30))
        down.backgroundColor = UIColor.redColor()
        down.layer.cornerRadius = 15
        point = g.locationInView(self.view)
        down.center = point
        down.alpha = 0.5
        
        self.view.addSubview(down)
        
        var left = UIView(frame: CGRectMake(0, 0, 30, 30))
        left.backgroundColor = UIColor.redColor()
        left.layer.cornerRadius = 15
        point = g.locationInView(self.view)
        left.center = point
        left.alpha = 0.5
        
        self.view.addSubview(left)
        
        var right = UIView(frame: CGRectMake(0, 0, 30, 30))
        right.backgroundColor = UIColor.redColor()
        right.layer.cornerRadius = 15
        point = g.locationInView(self.view)
        right.center = point
        right.alpha = 0.5
        
        self.view.addSubview(right)
        
        
        
        UIView.animateWithDuration(0.3, animations: {
            up.transform = CGAffineTransformMakeTranslation(0, -100)
            up.alpha = 0
            }, completion: { (isFinish: Bool) -> Void in
                if isFinish {
                    up.removeFromSuperview()
                }
        })
        
        UIView.animateWithDuration(0.3, delay: 0.2, options: nil, animations: {
            down.transform = CGAffineTransformMakeTranslation(0, 100)
            }, completion: { (isFinish: Bool) -> Void in
            if isFinish {
                down.removeFromSuperview()
            }
        })
        
        UIView.animateWithDuration(0.3, delay: 0.3, options: nil, animations: {
            left.transform = CGAffineTransformMakeTranslation(-100, 0)
            }, completion: { (isFinish: Bool) -> Void in
                if isFinish {
                    left.removeFromSuperview()
                }
        })
        
        UIView.animateWithDuration(0.3, delay: 0.1, options: nil, animations: {
            right.transform = CGAffineTransformMakeTranslation(100, 0)
            }, completion: { (isFinish: Bool) -> Void in
                if isFinish {
                    right.removeFromSuperview()
                }
        })
        
        var m = UIView(frame: CGRectMake(0, 0, 40, 40))
        m.backgroundColor = UIColor.redColor()
        m.layer.cornerRadius = 20
        point = g.locationInView(self.view)
        m.center = point
        m.alpha = 0.5
        m.hidden = true
        
        self.view.addSubview(m)
        
        UIView.animateWithDuration(1, delay: 0.4, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: nil, animations: {
            m.hidden = false
                m.transform = CGAffineTransformMakeScale(3, 3)
            }, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
