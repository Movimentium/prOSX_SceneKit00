//
//  ViewController.swift
//  prOSX_SceneKit00
//
//  Created by Miguel Gallego Martín on 16/06/2019.
//  Copyright © 2019 Miguel Gallego Martín. All rights reserved.
//

import Cocoa
import SceneKit

enum GeometryType: Int {
    case box
    case cone
    case cylinder
    case pyramid
    case sphere
    case torus
    case tube
    case text
}

class ViewController: NSViewController {

    @IBOutlet weak var scnView: SCNView!
    @IBOutlet weak var panGest: NSPanGestureRecognizer!
    @IBOutlet weak var lblX: NSTextField!
    @IBOutlet weak var lblY: NSTextField!
    @IBOutlet weak var lblCamX: NSTextField!
    @IBOutlet weak var lblCamZ: NSTextField!
    
    var currentGeometry = GeometryType.box
    
    let scene = SCNScene()
    
    let cameraNode = SCNNode()
    let cameraOrbit = SCNNode()
    let camera = SCNCamera()
    
    let node = SCNNode()
    let floorNode = SCNNode()
    
    let offset: CGFloat = 100
    
    var w: CGFloat = 1
    var h: CGFloat = 1
    var l: CGFloat = 1
    var chamferRad: CGFloat = 0.05
    var r0: CGFloat = 1
    var r1: CGFloat = 1
    
    // position
    let x: CGFloat = 0.0
    let y: CGFloat = 0.0
    let z: CGFloat = 0
    
    let xCam: CGFloat = 0.0
    let yCam: CGFloat = 0.0
    var zCam: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scnView.scene = scene
        scnView.backgroundColor = NSColor.lightGray
        scnView.autoenablesDefaultLighting = true
        //        scnView.debugOptions = [.showWireframe]
        addNode()
        addFloor()
        addCamera()
    }
//
    func addNode() {
        node.geometry = SCNBox(width: w, height: h, length: l, chamferRadius: chamferRad)
        node.geometry?.firstMaterial?.diffuse.contents = NSColor.blue
        node.geometry?.firstMaterial?.specular.contents = NSColor.white
        node.position = SCNVector3(x, y, z)

        scene.rootNode.addChildNode(node)
    }
    
    func addFloor() {
        floorNode.position = SCNVector3(0,-0.5,0)
        floorNode.geometry = SCNFloor()
        floorNode.geometry?.firstMaterial?.diffuse.contents = NSColor.lightGray
        floorNode.geometry?.firstMaterial?.specular.contents = NSColor.white
        floorNode.geometry?.firstMaterial?.isDoubleSided = true
        scene.rootNode.addChildNode(floorNode)
    }
    
    func addCamera() {
        //        camera.usesOrthographicProjection = true
        //        camera.orthographicScale = 9
        //        camera.zNear = 0
        //        camera.zFar = 100

        cameraNode.position = SCNVector3(xCam, yCam, zCam)
        cameraNode.camera = camera

        cameraOrbit.addChildNode(cameraNode)
        scene.rootNode.addChildNode(cameraOrbit)
        scnView.pointOfView = cameraNode
    }

    var xAngle:CGFloat = 0
    var yAngle:CGFloat = 0

    @IBAction func onPan(_ sender: NSPanGestureRecognizer) {

        let pnt = sender.translation(in: scnView)
        DispatchQueue.main.async {
//            self.lblX.stringValue = "x: \(pnt.x)"
//            self.lblY.stringValue = "y: \(pnt.y)"
//            self.lblPanGestState.stringValue = "state: \(sender.state.rawValue )"
        }
        if sender.state == .began { // 1
            yAngle = cameraOrbit.eulerAngles.y
            xAngle = cameraOrbit.eulerAngles.x
        } else if sender.state == .changed {  // 2
            cameraOrbit.eulerAngles.x = xAngle + toRads(pnt.y * (90 / offset))
            cameraOrbit.eulerAngles.y = yAngle + toRads(pnt.x * (90 / offset))

            DispatchQueue.main.async {
//                self.lblCamX.stringValue = "cam x: \(self.cameraNode.position.x )"
//                self.lblCamZ.stringValue = "cam z: \(self.cameraNode.position.z )"
            }
        } else if sender.state == .ended {

        }
    }
//
//
//    func doTransition() {
//        SCNTransaction.begin()
//        SCNTransaction.animationDuration = 7.5
//
//        cameraOrbit.eulerAngles.x -= CGFloat(M_PI_4)
//        cameraOrbit.eulerAngles.y -= CGFloat(M_PI_4*3)
//
//        //        cameraNode.position = SCNVector3(0,10,10)
//        //        cameraNode.eulerAngles = SCNVector3(toRads(-60), toRads(0), toRads(0))
//
//
//        SCNTransaction.commit()
//    }
//
//    @IBAction func onBtnTransition(_ sender: NSButton) {
//        doTransition()
//    }
//
    func toRads(_ deg: CGFloat) -> CGFloat {
        return deg * CGFloat.pi / 180.0
    }
    

    @IBAction func onSliderZoomChanged(_ sender: NSSlider) {
        zCam = CGFloat(sender.floatValue)
        cameraNode.position.z = zCam
    }
    
    private func updateGeometryParams() {
        node.geometry?.firstMaterial?.diffuse.contents = NSColor.blue
        node.geometry?.firstMaterial?.specular.contents = NSColor.white
    }
    
    @IBAction func onSegmentShape(_ sender: NSSegmentedControl) {
        print("\(#function) \(sender.indexOfSelectedItem)")
        guard let geoType = GeometryType(rawValue: sender.indexOfSelectedItem) else {
            return
        }
        switch geoType {
        case .box:
            node.geometry = SCNBox(width: w, height: h, length: l, chamferRadius: chamferRad)
        case .cone:
            node.geometry = SCNCone(topRadius: r0, bottomRadius: r1, height: h)
        case .cylinder:
            node.geometry = SCNCylinder(radius: r1, height: h)
        case .pyramid:
            node.geometry = SCNPyramid(width: w, height: h, length: l)
        case .sphere:
            node.geometry = SCNSphere(radius: r1)
        case .torus:
            node.geometry = SCNTorus(ringRadius: r1, pipeRadius: r0)
        case .tube:
            node.geometry = SCNTube(innerRadius: r1, outerRadius: r0, height: h)
        case .text:
            node.geometry = SCNText(string: "Hello", extrusionDepth: h)
        }
        updateGeometryParams()
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

