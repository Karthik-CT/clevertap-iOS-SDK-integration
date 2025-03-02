import SwiftUI

struct CoachmarkScreenUI: View {
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                HStack {
                    Spacer()
                    Text("CoachMarks Screen")
                        .font(.headline)
                        .foregroundColor(.black)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                }
                .padding(.top, -35)
                .frame(height: 5)
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    // Profile Section
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Hello User")
                                .font(.headline)
                                .bold()
                            IdentifiableUIView(accessibilityId: "txtHello").frame(width: 0, height: 0)
                            Text("Search and Order")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        AsyncImage(url: URL(string: "https://cdn-icons-png.flaticon.com/512/3135/3135715.png")) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        IdentifiableUIView(accessibilityId: "profile_image").frame(width: 0, height: 0)
                    }
                    .padding(.horizontal)
                    
                    // Promo Banner
                    AsyncImage(url: URL(string: "https://img.freepik.com/free-vector/flat-design-fast-food-sale-banner_23-2149135966.jpg?semt=ais_hybrid")) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .scaledToFit()
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        Text("Search your favorite food")
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
//                    .accessibilityIdentifier("search")
                    IdentifiableUIView(accessibilityId: "search").frame(width: 0, height: 0)
                    
                    // Categories Section
                    SectionHeader(title: "Categories")
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 2), spacing: 10) {
                        CategoryItem(imageUrl: "https://cdn-icons-png.flaticon.com/512/1046/1046784.png", title: "Burgers")
                        CategoryItem(imageUrl: "https://cdn-icons-png.flaticon.com/512/1046/1046781.png", title: "Drinks")
                        CategoryItem(imageUrl: "https://cdn-icons-png.flaticon.com/512/1046/1046786.png", title: "Fries")
                        CategoryItem(imageUrl: "https://cdn-icons-png.flaticon.com/512/1046/1046785.png", title: "Coffee")
                    }
                    .padding(.horizontal)
                    
                    // Recommended Section
                    SectionHeader(title: "Recommended")
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 2), spacing: 10) {
                        CategoryItem(imageUrl: "https://cdn-icons-png.flaticon.com/512/1046/1046771.png", title: "Pizza")
                        CategoryItem(imageUrl: "https://cdn-icons-png.flaticon.com/512/1046/1046784.png", title: "Burger")
                        CategoryItem(imageUrl: "https://cdn-icons-png.flaticon.com/512/1046/1046786.png", title: "Fries")
                        CategoryItem(imageUrl: "https://cdn-icons-png.flaticon.com/512/1046/1046789.png", title: "Drink")
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 10)
            }
            
            // Bottom Navigation Bar
            BottomTabBar()
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

// Section Header with Title & "See more"
struct SectionHeader: View {
    var title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .bold()
            Spacer()
            Text("See more")
                .font(.subheadline)
                .foregroundColor(.blue)
        }
        .padding(.horizontal)
    }
}

// Category Item View with AsyncImage
struct CategoryItem: View {
    var imageUrl: String
    var title: String
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: imageUrl)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}

// Bottom Navigation Bar
struct BottomTabBar: View {
    var body: some View {
        HStack {
            TabBarItem(icon: "house.fill", title: "Home")
            TabBarItem(icon: "cart.fill", title: "Cart"); IdentifiableUIView(accessibilityId: "cart").frame(width: 0, height: 0)
            TabBarItem(icon: "plus.circle.fill", title: "Help"); IdentifiableUIView(accessibilityId: "support_help").frame(width: 0, height: 0)
            TabBarItem(icon: "gearshape.fill", title: "Settings"); IdentifiableUIView(accessibilityId: "settings").frame(width: 0, height: 0)
        }
        .frame(height: 60)
        .background(Color.white.shadow(radius: 5))
    }
}

// Bottom Tab Item View
struct TabBarItem: View {
    var icon: String
    var title: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .resizable()
                .frame(width: 24, height: 24)
            Text(title)
                .font(.caption)
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
    }
}

// Preview
struct CoachMarksScreen_Previews: PreviewProvider {
    static var previews: some View {
        CoachmarkScreenUI()
    }
}

struct IdentifiableUIView: UIViewRepresentable {
    let accessibilityId: String

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.accessibilityIdentifier = accessibilityId
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
