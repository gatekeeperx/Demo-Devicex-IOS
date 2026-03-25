import SwiftUI
import DeviceX

struct ShoppingCartView: View {
    @ObservedObject var viewModel: HomeViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            // Top Bar
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.fhDarkText)
                }
                
                Spacer()
                
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "handbag")
                        .font(.system(size: 24))
                        .foregroundColor(.fhDarkText)
                    
                    if viewModel.cartItemCount > 0 {
                        Text("\(viewModel.cartItemCount)")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 16, height: 16)
                            .background(Circle().fill(Color.red))
                            .offset(x: 5, y: -5)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            // Title
            HStack {
                Text("My Order")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.fhDarkText)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            // Cart Items List
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(viewModel.cartItems) { item in
                        CartItemRow(item: item, viewModel: viewModel)
                        Divider()
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
            }
            
            // Bottom Checkout
            VStack {
                Button(action: {
                    guard Devicex.hasInstance, let dx = try? Devicex.instance else {
                        print("❌ DeviceX not configured")
                        return
                    }
                    // Checkout logic here
                    print("Checkout button tapped")
                }) {
                    Text("Checkout")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.fhGreen)
                        .cornerRadius(30)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .padding(.top, 10)
        }
        .background(Color.fhBackground.edgesIgnoringSafeArea(.all))
        .navigationBarHidden(true)
        .onAppear {
            Task {
                guard Devicex.hasInstance else { return }
                do {
                    let dx = try Devicex.instance
                    await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
                    dx.sendEventAsync(name: "screen_view", properties: [
                        "screen_name": "CartView",
                        "items_count": String(viewModel.cartItemCount)
                    ]) { result in
                        switch result {
                        case .success(let success):
                            print("✅ Event sent successfully CartView")
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
                    print("Error tracking CartView: \(error)")
                }
            }
        }
    }
}

struct CartItemRow: View {
    var item: CartItem
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        HStack(spacing: 15) {
            // Image
            Image(item.food.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .background(Circle().fill(Color.fhCardBackground))
            
            // Details
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(item.food.name)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.fhDarkText)
                    
                    Spacer()
                    
                    Text("$\(item.food.price, specifier: "%.2f")")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.fhDarkText)
                }
                
                Text(item.food.description)
                    .font(.system(size: 12))
                    .foregroundColor(.fhGrayText)
                    .lineLimit(2)
                
                // Stepper
                HStack(spacing: 15) {
                    Button(action: {
                        viewModel.addToCart(food: item.food)
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.fhCardBackground)
                            .overlay(Image(systemName: "plus").foregroundColor(.fhGrayText).font(.system(size: 12)))
                            .font(.system(size: 24))
                    }
                    
                    Text("\(item.quantity)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.fhDarkText)
                    
                    Button(action: {
                        viewModel.removeFromCart(food: item.food)
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.fhCardBackground)
                            .overlay(Image(systemName: "minus").foregroundColor(.fhGrayText).font(.system(size: 12)))
                            .font(.system(size: 24))
                    }
                }
                .padding(.top, 5)
            }
        }
    }
}
