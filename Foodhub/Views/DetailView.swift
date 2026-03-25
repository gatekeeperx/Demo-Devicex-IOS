import SwiftUI
import DeviceX

struct DetailView: View {
    @ObservedObject var viewModel: HomeViewModel
    let food: FoodItem
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
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
                
                NavigationLink(destination: ShoppingCartView(viewModel: viewModel)) {
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
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            // Header with Curved Background and Image
            ZStack(alignment: .top) {
                // Curved background
                GeometryReader { geometry in
                    Path { path in
                        let width = geometry.size.width
                        let height = geometry.size.height
                        
                        path.move(to: CGPoint(x: 0, y: 0))
                        path.addLine(to: CGPoint(x: width, y: 0))
                        path.addLine(to: CGPoint(x: width, y: height * 0.7))
                        path.addQuadCurve(to: CGPoint(x: 0, y: height * 0.7), control: CGPoint(x: width / 2, y: height))
                        path.closeSubpath()
                    }
                    .fill(Color.fhGreen)
                }
                .frame(height: 250)
                
                // Food Image
                Image(food.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 250, height: 250)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 5))
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 10)
                    .offset(y: 50)
            }
            .frame(height: 300)
            .zIndex(1)
            
            // Content Details
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(food.description)
                        .font(.system(size: 15))
                        .foregroundColor(.fhGrayText)
                        .lineSpacing(5)
                        .padding(.top, 40)
                    
                    Divider()
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(food.name)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.fhDarkText)
                            
                            Text("\(food.weight ?? "300g")/\(food.calories ?? "530 kcal")")
                                .font(.system(size: 14))
                                .foregroundColor(.fhGrayText)
                        }
                        
                        Spacer()
                        
                        Text("1 portion")
                            .font(.system(size: 14))
                            .foregroundColor(.fhGrayText)
                    }
                    
                    Divider()
                    
                    // Restaurant Info
                    HStack {
                        Image(systemName: "shield.lefthalf.filled")
                            .foregroundColor(.red)
                            .font(.system(size: 24))
                        
                        VStack(alignment: .leading) {
                            Text(food.restaurantName ?? "Chin Club")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.fhDarkText)
                            
                            Text(food.distance ?? "3.1 km from you")
                                .font(.system(size: 14))
                                .foregroundColor(.fhGrayText)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 2) {
                            ForEach(0..<5) { _ in
                                Image(systemName: "star.fill")
                                    .foregroundColor(.fhOrange)
                                    .font(.system(size: 12))
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 25)
            }
            .background(Color.fhBackground)
            
            // Bottom Bar
            HStack {
                VStack(alignment: .leading) {
                    Text("Price: ")
                        .font(.system(size: 14))
                        .foregroundColor(.fhGrayText)
                    Text("$\(food.price, specifier: "%.2f")")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.fhDarkText)
                }
                
                Spacer()
                
                Button(action: {
                    viewModel.addToCart(food: food)
                }) {
                    HStack {
                        Text("Add to cart")
                            .font(.system(size: 16, weight: .bold))
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 20))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(Color.fhGreen)
                    .cornerRadius(25)
                }
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 20)
            .background(Color.fhBackground)
            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: -5)
        }
        .navigationBarHidden(true)
        .onAppear {
            Task {
                guard Devicex.hasInstance else { return }
                do {
                    let dx = try Devicex.instance
                    await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
                        dx.sendEventAsync(name: "screen_view", properties: [
                            "screen_name": "DetailView",
                            "item_name": food.name
                        ]) { result in
                            switch result {
                            case .success(let success):
                                print("✅ Event sent successfully DetailView")
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
                    print("Error tracking DetailView: \(error)")
                }
            }
        }
    }
}
