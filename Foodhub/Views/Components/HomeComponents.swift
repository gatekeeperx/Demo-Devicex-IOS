import SwiftUI

struct CategoryCapsule: View {
    let category: Category
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(category.isSelected ? Color.white : Color.clear)
                        .frame(width: 50, height: 50)
                        .shadow(color: category.isSelected ? Color.black.opacity(0.1) : Color.clear, radius: 4, x: 0, y: 2)
                    
                    Image(systemName: category.iconName)
                        .font(.system(size: 20))
                        .foregroundColor(category.isSelected ? .fhOrange : .fhGreen)
                }
                
                Text(category.name)
                    .font(.system(size: 14, weight: category.isSelected ? .bold : .medium))
                    .foregroundColor(category.isSelected ? .fhDarkText : .fhGrayText)
            }
            .padding(.horizontal, 8)
        }
    }
}

struct SpecialCardView: View {
    let food: FoodItem
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 10) {
                Spacer().frame(height: 70) // Space for the overlapping image
                
                Text(food.name)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.fhDarkText)
                
                Text("$\(food.price, specifier: "%.2f")")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.fhGrayText)
                
                HStack {
                    Text("See Details")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.fhDarkText)
                    
                    Image(systemName: "chevron.right.circle.fill")
                        .foregroundColor(.fhGreen)
                }
                .padding(.top, 10)
            }
            .padding()
            .frame(width: 160, height: 200, alignment: .leading)
            .background(Color.fhCardBackground)
            .cornerRadius(20)
            
            // Overlapping Image
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 120, height: 120)
                
                Image(food.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
            }
            .offset(y: -50)
        }
        .padding(.top, 50) // Compensate for the offset
    }
}

struct RecommendedCardView: View {
    let food: FoodItem
    
    var body: some View {
        Image(food.imageName) // This will load from asset catalog
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 100, height: 100)
            .cornerRadius(15)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.gray.opacity(0.3))
            )
            .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
    }
}
