//
//  ViewController.swift
//  Canvas
//
//  Created by Joey Singer on 3/23/17.
//
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var trayView: UIView!
    var trayOriginalCenter: CGPoint!
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    @IBOutlet weak var downArrowView: UIImageView!
    
    func gestureRecognizer(gestureRecognizer: UIPanGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIPinchGestureRecognizer) -> Bool {
        return true
    }

    
    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        if sender.state == .began {
            trayOriginalCenter = trayView.center
        } else if sender.state == .changed {
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            let velocity = sender.velocity(in: view)
            if velocity.y > 0 {
                UIView.animate(withDuration: 0.3) {
                    self.trayView.center = self.trayDown
                    if (self.trayOriginalCenter != self.trayDown) {
                        self.downArrowView.transform = self.downArrowView.transform.rotated(by: CGFloat(M_PI))
                    }
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.trayView.center = self.trayUp
                    if (self.trayOriginalCenter != self.trayUp) {
                        self.downArrowView.transform = self.downArrowView.transform.rotated(by: CGFloat(M_PI))
                    }

                }
            }
        }
    }
    
    @IBAction func didPanFace(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        if sender.state == .began {
            var imageView = sender.view as! UIImageView
            newlyCreatedFace = UIImageView(image: imageView.image)
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
            view.addSubview(newlyCreatedFace)
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            newlyCreatedFace.isUserInteractionEnabled = true
        } else if sender.state == .changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(sender:)));
            let panPinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(sender:)));
            panPinchRecognizer.delegate = self
            newlyCreatedFace.isUserInteractionEnabled = true
            newlyCreatedFace.addGestureRecognizer(panGestureRecognizer)
            //newlyCreatedFace.addGestureRecognizer(panPinchRecognizer)
            self.view.addGestureRecognizer(panPinchRecognizer)
            self.view.isUserInteractionEnabled = true
        }
        
    }
    
    func didPan(sender: UIPanGestureRecognizer) {
        //let location = sender.location(in: view)
        //let velocity = sender.velocity(in: view)
        let translation = sender.translation(in: view)
        print("here2")
        if sender.state == .began {
            newlyCreatedFace = sender.view as! UIImageView
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
        } else if sender.state == .changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            
        }
    }
    
    func didPinch(sender: UIPinchGestureRecognizer) {
        let scale = sender.scale
        print("here")
        //newlyCreatedFace = sender.view as! UIImageView
        newlyCreatedFace.transform = newlyCreatedFace.transform.scaledBy(x: scale, y: scale)
        sender.scale = 1
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trayDownOffset = 170
        trayUp = trayView.center
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

