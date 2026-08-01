# Live Emergency Resource Tracker (iOS Prototype)

A high-performance, native iOS frontend prototype architected to track live emergency medical assets (such as Rh-Negative blood carriers) dynamically during crisis scenarios. Built strictly to demonstrate hardware-level geolocation integration, asynchronous data streaming, and scalable state management without any UI lag.

## Tech Stack & Native Frameworks
- **Language:** Swift 5.10
- **UI Framework:** SwiftUI (iOS 17+)
- **Hardware Tracking:** CoreLocation API
- **Map Rendering:** MapKit
- **Reactive Streams:** Combine Framework

## Architecture Design (Strict MVVM)
The project is built using a highly Model-View-ViewModel (MVVM) pattern combined with an independent Service Layer to ensure zero main-thread blocking during continuous tracking updates:

1. **Models (`DonorVehicle.swift`):** Pure, lightweight Swift structs conforming to `Codable` and `Identifiable` for instant JSON mapping.
2. **Services (`LocationManager.swift` & `NetworkService.swift`):** Dedicated hardware listeners and mock API endpoints. Houses the background thread processing logic.
3. **ViewModels (`LiveTracking.swift`):** The system brain. Manages subscription pipelines, prevents memory retain cycles (`[weak self]`), and handles spatial coordinate math.
4. **Views (`TrackingPage.swift`):** Completely "dumb" presentation layer driven entirely by state propagation.

## Key Technical Core Implementations

### 1. Battery-Optimized Geolocation Listener
Implemented Apple's `CLLocationManager` with a explicit `distanceFilter = 10` meters boundary and `.desiredAccuracy = kCLLocationAccuracyBest`. This enforces a strict hardware-level throttle, ensuring the device GPS chip only fires location update streams when the receiver moves, drastically reducing battery drain.

### 2. Memory-Safe Combine Data Pipeline
Instead of expensive polling, the app leverages reactive programming. The `NetworkService` emits simulated real-time donor telemetry, which is intercepted by the ViewModel using a Combine `.sink` pipeline. The subscription is bound safely using `Set<AnyCancellable>` with explicit weak references to prevent memory leaks and retention cycles.

### 3. Real-Time Spatial Computation
Utilizes native `CLLocation.distance(from:)` methods to calculate micro-level distance metrics between the hardware receiver and the incoming vehicle packet. Employs a defensive validation guard (`latitude != 0.0`) to avoid "Null Island" UI computation bugs during initial GPS acquisition.

## How to Run & Test (Standalone Simulation)

Since this is a fully standalone client built for technical evaluation, it utilizes an internal network simulation engine and requires native hardware mocking inside Xcode:

1. Clone the repository and open `MappingApplication.xcodeproj` inside **Xcode**.
2. Run the build on an iOS Simulator using **`Cmd + R`**.
3. Once the Simulator launches, navigate to the top macOS menu bar and select:
   `Features > Location > Freeway Drive` (or `City Bicycle Ride`).
4. **Expected Result:** The application will instantly hijack the simulator's GPS layer. You will observe the red Donor Marker physically moving along the native Map layer, while the floating UI card updates live distance metrics dynamically every 3 seconds without stutters.
5. 
6. ## <img width="404" height="816" alt="Screenshot 2026-06-10 at 9 35 54 AM" src="https://github.com/user-attachments/assets/a7c44584-106a-44b3-9fbd-469591510320" />
