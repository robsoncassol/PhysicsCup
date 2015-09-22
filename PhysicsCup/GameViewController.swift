//
//  GameViewController.swift
//  PhysicsCup
//
//  Created by John Fisher on 12/5/14.
//  Copyright (c) 2014 John Fisher. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file as String, ofType: "sks") {
            
            
            do {
                let sceneData = try NSData(contentsOfFile: path,options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
                archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
                let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
                archiver.finishDecoding()
                return scene
            }catch{
                return nil
            }

        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController {

    var lastRotation = CGFloat(0.0)
    
    
    @IBAction func rotationGestured(sender: UIRotationGestureRecognizer) {
        if(sender.state == UIGestureRecognizerState.Ended) {
            lastRotation = 0.0;
            return
        }
        
        let rotation = 0.0 - (sender.rotation - lastRotation)
        let trans = CGAffineTransformMakeRotation(rotation)
        
        let skView = self.view as! SKView
        if let skScene = skView.scene {
            let newGravity = CGPointApplyAffineTransform(CGPointMake(skScene.physicsWorld.gravity.dx, skScene.physicsWorld.gravity.dy), trans)
            skScene.physicsWorld.gravity = CGVectorMake(newGravity.x, newGravity.y)
            skScene.childNodeWithName("arrow")?.runAction(SKAction.rotateByAngle(rotation, duration: 0.1))
        }
        
        lastRotation = sender.rotation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFit
            
            skView.presentScene(scene)
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
            return UIInterfaceOrientationMask.All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
