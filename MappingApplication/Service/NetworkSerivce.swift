//
//  NetworkService.swift
//  MappingApplication
//
//  Created by Harshit Raj on 09/06/26.
//

import Foundation
import Combine

final class NetworkService: ObservableObject {
    @Published var latestVehicle: DonorVehicle?
    // Stores the active subscription so it doesn't get destroyed immediately
    private var cancellables = Set<AnyCancellable>()
    
    private var currentLatitude = 26.7606
    private var currentLongitude = 83.3733
    
    init() {
        startStreaming()
    }
    
    func startStreaming() {
        Timer.publish( every: 3.0, on: .main, in: .common )
            .autoconnect()
            .sink { [weak self] _ in
                self?.generateVehicleUpdate()
            }
            .store(in: &cancellables)
    }
    
    func generateVehicleUpdate() {
        currentLatitude += 0.0005
        currentLongitude += 0.0005
        
        let json = """
                {
                    "id":"DNR-001",
                    "vehicleName":"Blood Transport Van",
                    "vehicleId":"UP-93-1234",
                    "latitude":\(currentLatitude),
                    "longitude":\(currentLongitude),
                    "timestamp":"2026-06-09T14:00:00Z",
                    "status":"onRoute"
                }
                """
        
        do{
            let decoder = JSONDecoder()
            // to convert date in swift convertable format
            decoder.dateDecodingStrategy = .iso8601
            self.latestVehicle = try decoder.decode(DonorVehicle.self, from: Data(json.utf8))
        }
        catch{
            print("Decoding error: ", error)
        }
    }
}
