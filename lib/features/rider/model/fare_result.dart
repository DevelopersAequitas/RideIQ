class FareResult {
  final String platform; // Uber, Lyft
  final String rideType; // UberX, Comfort, Lux, etc.
  final double price;
  final int etaMinutes;
  final String category; // Economy, Premium

  FareResult({
    required this.platform,
    required this.rideType,
    required this.price,
    required this.etaMinutes,
    required this.category,
  });
}

// Mock Data
final mockFares = [
  FareResult(platform: "Ayro", rideType: "Standard", price: 8.50, etaMinutes: 4, category: "Economy"),
  FareResult(platform: "Ayro", rideType: "Premium", price: 14.00, etaMinutes: 7, category: "Premium"),
  FareResult(platform: "Uber", rideType: "UberX", price: 9.10, etaMinutes: 5, category: "Economy"),
  FareResult(platform: "Lyft", rideType: "Standard", price: 9.35, etaMinutes: 3, category: "Economy"),
  FareResult(platform: "Uber", rideType: "Comfort", price: 12.50, etaMinutes: 6, category: "Premium"),
  FareResult(platform: "Lyft", rideType: "Lux", price: 15.80, etaMinutes: 8, category: "Premium"),
];
