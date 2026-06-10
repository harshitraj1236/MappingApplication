//
//  DonorVehicle.swift
//  MappingApplication
//
//  Created by Harshit Raj on 09/06/26.
//

import Foundation

enum VehicleStatus: String, Codable {
    case available, assigned, onRoute, arriving, delivered, cancelled, offline
}

struct DonorVehicle: Codable, Identifiable {
    let id: String
    let vehicleName: String
    let vehicleId: String
    
    let latitude: Double
    let longitude: Double
    
    let timestamp: String
    
    let status: VehicleStatus
}
