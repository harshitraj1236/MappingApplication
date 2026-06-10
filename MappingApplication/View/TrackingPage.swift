import SwiftUI
import MapKit

struct LiveTrackingView: View {
    // 1. Initialize the Brain (ViewModel)
    @StateObject private var viewModel = LiveTracking()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            //Map
            Map {
                if viewModel.locationManager.latitude != 0.0 {
                    Marker("Hospital / Patient", coordinate: CLLocationCoordinate2D(
                        latitude: viewModel.locationManager.latitude,
                        longitude: viewModel.locationManager.longitude
                    ))
                    .tint(.blue)
                }
                
                if let donor = viewModel.donorVehicle {
                    Marker(donor.vehicleName, coordinate: CLLocationCoordinate2D(
                        latitude: donor.latitude,
                        longitude: donor.longitude
                    ))
                    .tint(.red)
                }
            }
            .ignoresSafeArea()
            
            // Info
            VStack(spacing: 10) {
                // Status Header
                Text(viewModel.isArrival ? "Ambulance Arriving!" : "Tracking Rh-Negative Donor")
                    .font(.headline)
                    .foregroundColor(viewModel.isArrival ? .red : .primary)
                
                // Distance Text (Directly from ViewModel)
                Text(viewModel.distanceText)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // Vehicle Details
                if let donor = viewModel.donorVehicle {
                    Text("Vehicle ID: \(donor.vehicleId)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(16)
            .shadow(radius: 10)
            .padding(.bottom, 30)
        }
    }
}

#Preview {
    LiveTrackingView()
}
