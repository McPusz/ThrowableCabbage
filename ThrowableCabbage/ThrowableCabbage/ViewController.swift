//
//  ViewController.swift
//  ThrowableCabbage
//
//  Created by Mpalka on 25.10.2017.
//  Copyright © 2017 McPusz. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    private var cabbageNode = SCNNode()
    private let configuration = ARWorldTrackingConfiguration()
    private var planes = [String:Plane]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupScene()
        self.setupCabbage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    private func setupScene() {
        self.sceneView.delegate = self
        self.planes = [String:Plane]()
        self.sceneView.showsStatistics = true
        self.sceneView.autoenablesDefaultLighting = true
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        let scene = SCNScene()
        self.sceneView.scene = scene
    }

    private func setupSession() {
        let congifuration = ARWorldTrackingConfiguration()
        congifuration.planeDetection = .horizontal
        self.sceneView.session.run(congifuration)
    }
    
    private func getCabbageNode() -> SCNNode {
        guard let node = self.sceneView.scene.rootNode.childNode(withName: "Cabbage2", recursively: true) else { return SCNNode() }
        return node
    }
    
    private func setupCabbage() {
        self.cabbageNode = getCabbageNode()
        self.cabbageNode.position = SCNVector3Make(0, 0, -10)
        self.sceneView.scene.rootNode.addChildNode(self.cabbageNode)
    }
    
    private func setupDebugOptions() {
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.sceneView.automaticallyUpdatesLighting = true
        self.sceneView.showsStatistics = true
    }

    private func createPlaneNode(anchor: ARPlaneAnchor) -> SCNNode {
        let planeWidth = CGFloat(anchor.extent.x)
        let planeHeight = CGFloat(anchor.extent.z)
        
        let planeGeometry = SCNPlane(width: planeWidth, height: planeHeight)
        let planeNode = SCNNode(geometry: planeGeometry)
        planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        //set planeNode from vertical to horizontal
        planeNode.transform = SCNMatrix4MakeRotation(.pi/2, 1, 0, 0)
        return planeNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let anchor = anchor as? ARPlaneAnchor else { return }
        let planeNode = Plane(with: anchor)
        self.planes[anchor.identifier.uuidString] = planeNode
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        let plane = self.planes[anchor.identifier.uuidString]
        guard plane != nil, let anchor = anchor as? ARPlaneAnchor else { return }
        plane?.update(anchor: anchor)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        self.planes.removeValue(forKey: anchor.identifier.uuidString)
    }
}
