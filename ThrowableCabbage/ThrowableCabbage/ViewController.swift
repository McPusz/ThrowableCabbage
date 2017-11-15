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
import RxSwift

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    private let shoutButton = ShoutButtonView()
    private let configuration = ARWorldTrackingConfiguration()
    private let disposeBag = DisposeBag()
    private var planes = [String:Plane]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupScene()
        self.setupShouts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
        let tapPoint = sender.location(in: self.sceneView)
        let result = self.sceneView.hitTest(tapPoint, types: ARHitTestResult.ResultType.existingPlaneUsingExtent)
        if result.isEmpty { return }
        let hitResult = result.first
        self.insertGeometry(hitPoint: hitResult)
    }
    
    private func setupShouts() {
        self.view.addSubview(self.shoutButton)
        self.shoutButton.shout.asObservable()
            .subscribe(onNext: { [weak self] (_) in
                self?.explodeCabbages()
            }).disposed(by: self.disposeBag)
    }
    
    private func explodeCabbages() {
        guard var currentCameraPosition = self.sceneView.pointOfView?.position else { return }
        let shoutOffsetY: Float = 0.1
        currentCameraPosition.y -= shoutOffsetY
       
        let cabbages = self.getSceneCabbages()
        for cbg in cabbages {
            cbg.explodeFrom(position: currentCameraPosition)
        }
    }
    
    private func getSceneCabbages() -> [SCNNode] {
        let childNodes = self.sceneView.scene.rootNode.childNodes
        var sceneCabbages = [SCNNode]()
        for childNode in childNodes {
           let childNodeCabbages = childNode.childNodes.filter{$0.name == Cabbage.name}
            sceneCabbages.append(contentsOf: childNodeCabbages)
        }
        return sceneCabbages
    }
}

//MARK Scene setup
extension ViewController {
    private func setupScene() {
        self.sceneView.delegate = self
        self.sceneView.showsStatistics = true
        //lightning
        self.sceneView.autoenablesDefaultLighting = false
        self.sceneView.automaticallyUpdatesLighting = false
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.sceneView.scene = SCNScene()
        self.setupWorldBorder()
    }
    
    private func setupSession() {
        let congifuration = ARWorldTrackingConfiguration()
        congifuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        self.sceneView.session.run(congifuration)
    }
    
    private func setupDebugOptions() {
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.sceneView.automaticallyUpdatesLighting = true
        self.sceneView.showsStatistics = true
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
    
    private func setupWorldBorder() {
        let bottomBorderNode = WorldBorder()
        self.sceneView.scene.rootNode.addChildNode(bottomBorderNode)
        self.sceneView.scene.physicsWorld.contactDelegate = self
    }
    
    private func insertGeometry(hitPoint: ARHitTestResult?) {
        
        guard let hitPoint = hitPoint else { return }
        //lets cabbage fall on a grid
        let insertOffsetY: Float = 0.3
        let xPos = hitPoint.worldTransform.columns.3.x
        let yPos = hitPoint.worldTransform.columns.3.y + insertOffsetY
        let zPos = hitPoint.worldTransform.columns.3.z
        let position = SCNVector3Make(xPos, yPos, zPos)
        let cabbageNode = Cabbage(at: position, fromSceneView: self.sceneView)
        self.sceneView.scene.rootNode.addChildNode(cabbageNode)
    }
    
}

//MARK: Physics
extension ViewController: SCNPhysicsContactDelegate {
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        guard let nodeAIsWorld = self.nodeAIsWorld(contact: contact) else { return }
        
        if nodeAIsWorld {
            contact.nodeB.removeFromParentNode()
        } else {
            contact.nodeA.removeFromParentNode()
        }
    }
    
    private func nodeAIsWorld(contact: SCNPhysicsContact) -> Bool? {
        guard let bitMaskA = contact.nodeA.physicsBody?.categoryBitMask, let bitMaskB = contact.nodeB.physicsBody?.categoryBitMask else { return nil }
        let contactMask = bitMaskA | bitMaskB
        guard contactMask == (CollisionCategory.world.rawValue | CollisionCategory.cabbage.rawValue) else { return nil }
        return contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.world.rawValue
    }
}

