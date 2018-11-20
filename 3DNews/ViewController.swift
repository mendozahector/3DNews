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
    
    //Global videoNodes to for future pause() & resume() options
    //let videoNode = SKVideoNode(fileNamed: "video1.mp4")
    
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
            
            if let imageName = imageAnchor.referenceImage.name {
                
                createVideoScene(with: imageName, at: planeNode)
            }
            
            node.addChildNode(planeNode)
        }
        
        return node
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        sceneView.session.remove(anchor: anchor)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
    }
    
    
    //MARK: - Creates an invisible plane node on tracked image
    func createPlaneNode(with imageAnchor: ARImageAnchor) -> SCNNode {
        
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
        
        //Invisible plane this time
        //plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi/2
        
        return planeNode
    }
    
    
    //MARK: - Creates a video scene on plane node
    func createVideoScene(with imageName: String, at planeNode: SCNNode) {
        
        let videoNode = SKVideoNode(fileNamed: "\(imageName).mp4")
        let videoScene = SKScene(size: CGSize(width: 640, height: 360))
        videoNode.play()
        
        videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
        videoNode.yScale = -1.0
        
        videoScene.addChild(videoNode)
        planeNode.geometry?.firstMaterial?.diffuse.contents = videoScene
    }
    
}
