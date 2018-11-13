//
//  ViewController.swift
//  3DNews
//
//  Created by Hector Mendoza on 9/24/18.
//  Copyright © 2018 Hector Mendoza. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    let videoNode = SKVideoNode(fileNamed: "video1.mp4")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARImageTrackingConfiguration()
        
        if let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "News", bundle: Bundle.main) {
            
            configuration.trackingImages = referenceImages
            configuration.maximumNumberOfTrackedImages = 2
        }
        
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }


    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            
            let planeNode = createPlaneNode(with: imageAnchor)
            
            
            //let videoNode = SKVideoNode(fileNamed: "video1.mp4")
            
            //videoNode.play()
            
            //let videoScene = SKScene(size: CGSize(width: 480, height: 360))
            
            //videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
            
            //videoNode.yScale = -1.0
            
            //videoScene.addChild(videoNode)
            
            //let planeNode = createPlaneNode(with: imageAnchor, video: videoScene)
            
            node.addChildNode(planeNode)
        }
        
        return node
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        //videoNode.pause()
    }
    
    
    //MARK: - Creates an invisible plane node on tracked image
    func createPlaneNode(with imageAnchor: ARImageAnchor) -> SCNNode {
        
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
        
        plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi/2
        
        return planeNode
    }
    
}
