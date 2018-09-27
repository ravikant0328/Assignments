//
//  ARSessionVC.swift
//  ARProject
//
//  Created by Ravi on 26/09/18.
//  Copyright © 2018 Ravi. All rights reserved.
//

import ARKit
import UIKit

final class ARSession: UIViewController, ARSessionDelegate, ARSCNViewDelegate {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var crosshair: UIView!
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var sessionStateLabel: UILabel!
    
    var debugPlanes: [SCNNode] = []
    var portalNode: SCNNode?
    var isPortalPlaced = false
    var currentAngleY: Float = 0.0
    var currentAngleX: Float = 0.0
    var modelname: String?
    
    //Calculating center point of screen
    var viewCenter: CGPoint {
        let viewBounds = view.bounds
        return CGPoint(x: viewBounds.width / 2.0, y: viewBounds.height / 2.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runSession()
        sceneView?.showsStatistics = true
        sceneView?.delegate = self
        sceneView?.autoenablesDefaultLighting = true
        guard let label = sessionStateLabel else { return }
        showMessage("Session Active", label: label, seconds: 3)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didtap(_:)))
        sceneView?.addGestureRecognizer(tapGesture)
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didpinch(_:)))
        sceneView?.addGestureRecognizer(pinchGesture)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didpan(_:)))
        sceneView?.addGestureRecognizer(panGesture)
    }
    
    //Moving the object on tapping
    @objc func didtap(_ gesture: UITapGestureRecognizer) {
        if portalNode != nil {
        let tapLocation = gesture.location(in: sceneView)
        let result = sceneView?.hitTest(tapLocation, types: .featurePoint)
        if let result = result?.first {
            let translation = result.worldTransform.translation
            portalNode?.position = SCNVector3Make(translation.x, translation.y, translation.z)
            guard let node = portalNode else { return }
            sceneView?.scene.rootNode.addChildNode(node)
        }
    }
    }
    
    //Resizing the object on pinching
    @objc func didpinch(_ gesture: UIPinchGestureRecognizer) {
        if portalNode != nil {
        var originalScale = portalNode?.scale
        switch gesture.state {
        case .began:
            originalScale = portalNode?.scale
            guard let x = portalNode?.scale.x else { return }
            gesture.scale = CGFloat(x)
        case .changed:
            guard var newScale = originalScale else { return }
            if gesture.scale <= 0.05 {
                newScale = SCNVector3(x: 0.05, y: 0.05, z: 0.05)
            } else if gesture.scale > 1 {
                newScale = SCNVector3(1, 1, 1)
            } else {
                newScale = SCNVector3(gesture.scale, gesture.scale, gesture.scale)
            }
            portalNode?.scale = newScale
        case .ended:
            guard var newScale = originalScale else { return }
            if gesture.scale <= 0.05 {
                newScale = SCNVector3(x: 0.05, y: 0.05, z: 0.05)
            } else if gesture.scale > 1 {
                newScale = SCNVector3(1, 1, 1)
            } else {
                newScale = SCNVector3(gesture.scale, gesture.scale, gesture.scale)
            }
            portalNode?.scale = newScale
            guard let x = portalNode?.scale.x else { return }
            gesture.scale = CGFloat(x)
        default:
            gesture.scale = 1
            originalScale = nil
        }
    }
    }
    
    //Rotating the object
    @objc func didpan(_ gesture: UIPanGestureRecognizer) {
        if portalNode != nil {
        let translation = gesture.translation(in: gesture.view)
        var newAngleY = (Float)(translation.x) * (Float)(Double.pi) / 180.0
        var newAngleX = (Float)(translation.y) * (Float)(Double.pi) / 180.0
        newAngleY += currentAngleY
        newAngleX += currentAngleX
        portalNode?.eulerAngles.y = newAngleY
        portalNode?.eulerAngles.x = newAngleX
        if gesture.state == .ended {
            currentAngleY = newAngleY
            currentAngleX = newAngleX
        }
    }
    }
    
    //Start of a session
    func runSession() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.isLightEstimationEnabled = true
        sceneView?.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        #if DEBUG
        sceneView?.debugOptions = [SCNDebugOptions.showFeaturePoints]
        #endif
    }
    
    //Mark : Clearing the screen of planes and nodes
    func removeAllNodes() {
        removeDebugPlanes()
        self.portalNode?.removeFromParentNode()
        self.isPortalPlaced = false
    }
    
    func removeDebugPlanes() {
        for debugPlaneNode in self.debugPlanes {
            debugPlaneNode.removeFromParentNode()
        }
        
        self.debugPlanes = []
    }
    
    // Mark : Adding anchor as the touch happens
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let hit = sceneView?.hitTest(viewCenter, types: [.existingPlaneUsingExtent]).first {
            sceneView?.session.add(anchor: ARAnchor(transform: hit.worldTransform))
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                #if DEBUG
                let debugPlaneNode = createPlaneNode(center: planeAnchor.center, extent: planeAnchor.extent)
                node.addChildNode(debugPlaneNode)
                self.debugPlanes.append(debugPlaneNode)
                #endif
                self.messageLabel?.alpha = 1.0
                self.messageLabel?.text = "Tap on the detected plane to place the object"
            } else if !self.isPortalPlaced {
                self.portalNode = self.makePortal()
                if let portal = self.portalNode {
                    node.addChildNode(portal)
                    self.isPortalPlaced = true
                    self.removeDebugPlanes()
                    self.sceneView?.debugOptions = []
                    DispatchQueue.main.async {
                        self.messageLabel?.text = ""
                        self.messageLabel?.alpha = 0
                    }
                }
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor, !node.childNodes.isEmpty {
                updatePlaneNode(node.childNodes[0], center: planeAnchor.center, extent: planeAnchor.extent)
            }
        }
    }
    
    private func session(_ session: ARSession, didFailWithError error: Error) {
        guard let label = self.sessionStateLabel else { return }
        showMessage(error.localizedDescription, label: label, seconds: 3)
    }
    
    private func sessionWasInterrupted(_ session: ARSession) {
        guard let label = self.sessionStateLabel else { return }
        showMessage("Session Interrupted", label: label, seconds: 3)
    }
    
    private func sessionInterruptionEnded(_ session: ARSession) {
        guard let label = self.sessionStateLabel else { return }
        showMessage("Session Resumed", label: label, seconds: 3)
        DispatchQueue.main.async {
            self.removeAllNodes()
        }
        runSession()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            if self.sceneView?.hitTest(self.viewCenter, types: [.existingPlaneUsingExtent]).first != nil {
                self.crosshair.backgroundColor = UIColor.green
            } else {
                self.crosshair.backgroundColor = UIColor.lightGray
            }
        }
    }
    
    private func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState {
        case .normal :
            messageLabel.text = "Move the device to detect horizontal or vertical surfaces."
            
        case .notAvailable:
            messageLabel.text = "Tracking not available."
            
        case .limited(.excessiveMotion):
            messageLabel.text = "Tracking limited - Move the device more slowly."
            
        case .limited(.insufficientFeatures):
            messageLabel.text = "Tracking limited - Point the device at an area with visible surface detail."
            
        case .limited(.initializing):
            messageLabel.text = "Initializing AR session."
            
        default:
            messageLabel.text = ""
        }
    }
    
    //Mark : Adding object to the plane
    func makePortal() -> SCNNode {
        let documentsDirectoryURL: URL? = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        var modelName = modelname
        modelName?.append(".scn")
        
        guard let model = modelName else { return SCNNode() }
        let modeldocumentsDirectoryURL = documentsDirectoryURL?.appendingPathComponent(model)
        guard let x = modeldocumentsDirectoryURL else { return SCNNode() }
        print(x)
        
        var sceneSource: SCNSceneSource?
        if let anURL = modeldocumentsDirectoryURL {
            sceneSource = SCNSceneSource(url: anURL, options: nil)
        }
        
        var modeltextureName = modelname
        modeltextureName?.append(".png")
        guard let texture = modeltextureName else { return SCNNode() }
        let texturedocumentsDirectoryURL = documentsDirectoryURL?.appendingPathComponent(texture)
        guard let y = texturedocumentsDirectoryURL else { return SCNNode() }
        print(y)
        
        //Adding texture and scene to the object
        
        let material = SCNMaterial()
        if let imageData = try? Data(contentsOf: y) {
            if let image = UIImage(data: imageData) {
                print(image)
                material.diffuse.contents = image
                let scene = sceneSource?.scene(options: nil)
                let portal = SCNNode()
                guard let childnode = scene?.rootNode.childNodes else { return SCNNode() }
                for nodes in childnode {
                    nodes.geometry?.materials = [material]
                    portal.addChildNode(nodes)
                }
                portal.geometry?.materials = [material]
                portal.scale = SCNVector3(0.05, 0.05, 0.05)
                return portal
            }
        }
        return SCNNode()
    }
}
