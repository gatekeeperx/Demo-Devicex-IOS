import Foundation

struct Category: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let iconName: String
    var isSelected: Bool = false
}

struct FoodItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String
    let price: Double
    let imageName: String
    
    // Optional details
    var weight: String? = nil
    var calories: String? = nil
    var rating: Double? = nil
    var distance: String? = nil
    var restaurantName: String? = nil
}

struct CartItem: Identifiable, Hashable {
    let id = UUID()
    let food: FoodItem
    var quantity: Int
}
