//
//  ViewController.swift
//  Bootstrapping
//
//  Created by Adonis Gaitatzis on 11/15/16.
//  Copyright © 2016 Adonis Gaitatzis. All rights reserved.
//

import UIKit
import CoreBluetooth

/**
 This view shows basic informatin about a connected Peripheral
 */
class PeripheralViewController: UIViewController, CBCentralManagerDelegate, BlePeripheralDelegate {
    
    // MARK: UI Elements
    @IBOutlet weak var advertisedNameLabel: UILabel!
    @IBOutlet weak var identifierLabel: UILabel!
    @IBOutlet weak var rssiLabel: UILabel!
    
    // MARK: Connected Peripheral Properties
    
    // Central Manager
    var centralManager:CBCentralManager!

    // connected Peripheral
    var blePeripheral:BlePeripheral!
    
    
    /**
     UIView loaded
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Will connect to \(blePeripheral.peripheral.identifier.uuidString)")
        
        
        // Assign delegates
        blePeripheral.delegate = self
        centralManager.delegate = self
        centralManager.connect(blePeripheral.peripheral)
        
    }

    
    
    /**
     RSSI discovered.  Update UI
     */
    func blePeripheral(readRssi rssi: NSNumber, blePeripheral: BlePeripheral) {
        rssiLabel.text = rssi.stringValue
    }
    
    
    // MARK: CBCentralManagerDelegate code
    
    /**
     Peripheral connected.  Update UI
     */
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected Peripheral: \(peripheral.name)")
        
        advertisedNameLabel.text = blePeripheral.advertisedName
        identifierLabel.text = blePeripheral.peripheral.identifier.uuidString
        
        blePeripheral.connected(peripheral: peripheral)
    }
    
    /**
     Connection to Peripheral failed.
     */
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("failed to connect")
        print(error.debugDescription)
    }
    
    /**
     Peripheral disconnected.  Leave UIView
     */
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected Peripheral: \(peripheral.name)")
        dismiss(animated: true, completion: nil)
    }
    
    /**
     Bluetooth radio state changed.
     */
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Central Manager updated: checking state")
        
        switch (central.state) {
        case .poweredOn:
            print("bluetooth on")
        default:
            print("bluetooth unavailable")
        }
    }

    
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("leaving view - disconnecting from peripheral")
        if let peripheral = blePeripheral.peripheral {
            centralManager.cancelPeripheralConnection(peripheral)
        }
    }
    
}

