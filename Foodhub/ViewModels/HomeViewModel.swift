import Foundation
import Combine
import DeviceX

class HomeViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var specials: [FoodItem] = []
    @Published var recommended: [FoodItem] = []
    
    @Published var cartItems: [CartItem] = []
    @Published var searchText: String = ""
    
    init() {
        loadInitialData()
    }
    
    var cartItemCount: Int {
        cartItems.reduce(0) { $0 + $1.quantity }
    }
    
    var cartTotal: Double {
        cartItems.reduce(0) { $0 + ($1.food.price * Double($1.quantity)) }
    }
    
    func addToCart(food: FoodItem) {
        if let index = cartItems.firstIndex(where: { $0.food.id == food.id }) {
            cartItems[index].quantity += 1
        } else {
            cartItems.append(CartItem(food: food, quantity: 1))
        }
        sendAddToCartEvent(food: food)
    }
    
    func removeFromCart(food: FoodItem) {
        if let index = cartItems.firstIndex(where: { $0.food.id == food.id }) {
            if cartItems[index].quantity > 1 {
                cartItems[index].quantity -= 1
            } else {
                cartItems.remove(at: index)
            }
        }
    }
    
    func sendAddToCartEvent(food: FoodItem) {
        Task {
            guard Devicex.hasInstance else { return }
            do {
                let dx = try Devicex.instance
                await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
                    dx.sendEventAsync(name: "add_to_cart", properties: [
                        "item_id": food.id.uuidString,
                        "item_name": food.name,
                        "item_price": food.price
                    ]) { result in
                        switch result {
                        case .success(let success):
                            print("✅ Event sent successfully")
                            print("Device ID: \(success.deviceXId)")
                            print("HTTP Code: \(success.code)")
                        case .failure(let failure):
                            print("❌ Event failed: \(failure.errorMessage)")
                            print("Error Code: \(failure.errorCode)")
                        }
                        continuation.resume()
                    }
                }
            } catch {
                print("Error sending add to cart event: \(error)")
            }
        }
    }
    
    func sendCategoryClickEvent(category: Category) {
        Task {
            guard Devicex.hasInstance else { return }
            do {
                let dx = try Devicex.instance
                await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
                    dx.sendEventAsync(name: "category_click", properties: [
                        "category_name": category.name
                    ]) { result in
                        switch result {
                        case .success(let success):
                            print("✅ Event sent successfully category_click")
                            print("Device ID: \(success.deviceXId)")
                            print("HTTP Code: \(success.code)")
                        case .failure(let failure):
                            print("❌ Event failed: \(failure.errorMessage)")
                            print("Error Code: \(failure.errorCode)")
                        }
                        continuation.resume()
                    }
                }
            } catch {
                print("Error sending category click event: \(error)")
            }
        }
    }
    
    private func `loadInitialData`() {
        categories = [
            Category(name: "All", iconName: "tray.fill", isSelected: true),
            Category(name: "Italian", iconName: "fork.knife", isSelected: false),
            Category(name: "Thai", iconName: "leaf.fill", isSelected: false),
            Category(name: "Asian", iconName: "takeoutbag.and.cup.and.straw", isSelected: false)
        ]
        
        // Initial food catalog
        specials = [
            FoodItem(name: "Noodles", description: "Rice Noodles with shrimps, egg, pork, choy, cabbage. Noodles fave or trying something completely new, we want your tastebuds to be your happy buds.", price: 7.20, imageName: "img_noodles", weight: "300g", calories: "530 kcal", rating: 5.0, distance: "3.1 km from you", restaurantName: "Chin Club"),
            FoodItem(name: "Pasta", description: "Delicious italian pasta.", price: 6.20, imageName: "img_pasta")
        ]
        
        recommended = [
            FoodItem(name: "Cake", description: "Strawberry cake", price: 4.5, imageName: "img_recommended_1"),
            FoodItem(name: "Steak", description: "Grilled steak", price: 12.0, imageName: "img_recommended_2"),
            FoodItem(name: "Chicken", description: "Roasted chicken", price: 9.0, imageName: "img_recommended_3")
        ]
        
        // Add default items to cart
        addToCart(food: specials[0])
        addToCart(food: specials[1])
    }
}
