import SwiftUI
import DeviceX

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 25) {
                    
                    // Top Bar
                    HStack {
                        Button(action: {}) {
                            Image(systemName: "line.3.horizontal")
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
                    
                    // Greeting
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Hi James")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.fhDarkText)
                        
                        Text("What do you want to order today?")
                            .font(.system(size: 16))
                            .foregroundColor(.fhGrayText)
                    }
                    .padding(.horizontal)
                    
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.fhGrayText)
                        
                        TextField("Search", text: $viewModel.searchText)
                            .foregroundColor(.fhDarkText)
                    }
                    .padding()
                    .background(Color.fhSearchBackground)
                    .cornerRadius(15)
                    .padding(.horizontal)
                    
                    // Categories
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(viewModel.categories) { category in
                                CategoryCapsule(category: category) {
                                    let index = viewModel.categories.firstIndex(where: { $0.id == category.id })!
                                    for i in 0..<viewModel.categories.count {
                                        viewModel.categories[i].isSelected = false
                                    }
                                    viewModel.categories[index].isSelected = true
                                    viewModel.sendCategoryClickEvent(category: category)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Specials
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Specials")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.fhDarkText)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(viewModel.specials) { food in
                                    NavigationLink(destination: DetailView(viewModel: viewModel, food: food)) {
                                        SpecialCardView(food: food)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 20) // Give space for shadow
                        }
                    }
                    
                    // Recommended
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Recommended")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.fhDarkText)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(viewModel.recommended) { food in
                                    NavigationLink(destination: DetailView(viewModel: viewModel, food: food)) {
                                        RecommendedCardView(food: food)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 40)
                        }
                    }
                }
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
                                "screen_name": "HomeView"
                            ]) { result in
                                switch result {
                                case .success(let success):
                                    print("✅ Event sent successfully screen_view")                
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
                        print("Error tracking HomeView: \(error)")
                    }
                }
            }
        }
    }
}
