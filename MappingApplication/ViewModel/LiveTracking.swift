import Foundation
import Combine
import CoreLocation

final class LiveTracking: ObservableObject {
    @Published var locationManager = LocationManager()
    private var networkService = NetworkService()
    
    @Published var distanceText = "Calculating distance..."
    @Published var isArrival = false
    @Published var donorVehicle: DonorVehicle?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        bindData()
    }
    
    private func bindData() {
        networkService.$latestVehicle.sink { [weak self] vehicle in
            guard let self = self else { return }
            
            guard let safeVehicle = vehicle else { return }
            
            self.donorVehicle = safeVehicle
            self.calculateDistance(to: safeVehicle)
        }
        .store(in: &cancellables)
    }
    
    private func calculateDistance(to vehicle: DonorVehicle) {
        guard locationManager.latitude != 0.0, locationManager.longitude != 0.0 else {
            distanceText = "Finding your location..."
            return
        }
        
        let userLocation = CLLocation(latitude: locationManager.latitude, longitude: locationManager.longitude)
        let vehicleLocation = CLLocation(latitude: vehicle.latitude, longitude: vehicle.longitude)
        
        let distanceInMeter = userLocation.distance(from: vehicleLocation)
        
        distanceText = String(format: "%.2f km", distanceInMeter / 1000)
        
        if distanceInMeter < 500 {
            isArrival = true
        } else {
            isArrival = false
        }
    }
}
