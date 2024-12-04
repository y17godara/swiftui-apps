import SwiftUI

struct LoadingScreen: View {
    var body: some View {
        @State var isLocked: Bool = false
        
        ZStack {
            VStack(alignment: .center, spacing: 40) {
                TopImagesGrid()
                    .padding(.top, 50)
                
                VStack(spacing: 10) {
                    Text("Easy way \n to live your dreams")
                        .font(.system(size: 40, weight: .black, design: .serif))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("Also book flight ticket, places, food and many more.")
                        .font(.system(size: 18, weight: .regular, design: .serif))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    
                }
                
                Spacer()
                
                GetStartedActions(isLocked: $isLocked)
            }
            .background(.white)
            .frame(maxHeight: .infinity)
        }
        .edgesIgnoringSafeArea(.all) // Make ZStack ignore the safe area
        .ignoresSafeArea() // Make the ZStack background cover the whole screen
    }
    
}

// Preview for the Loading Screen
struct LoadingScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoadingScreen()
    }
}

// DynamicImage View for loading images with URL and Size Parameters
struct DynamicImage: View {
    let url: String
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
            case .empty:
                SkeletonView(width: width, height: height) // Show skeleton loader while loading
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            case .failure:
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: height)
            @unknown default:
                EmptyView()
            }
        }
    }
}

// Skeleton view that shows while image is loading
struct SkeletonView: View {
    let width: CGFloat
    let height: CGFloat
    
    @State private var animation = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.gray.opacity(0.2))
            .frame(width: width, height: height)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 1)
                    .foregroundColor(Color.gray.opacity(0.3))
            )
            .shimmering() // Add shimmer effect to indicate loading
            .onAppear {
                withAnimation(.linear(duration: 1).repeatForever(autoreverses: true)) {
                    animation.toggle()
                }
            }
    }
}

// A view modifier to create shimmering effect for skeleton loader
struct ShimmerEffect: ViewModifier {
    var animation: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay {
                LinearGradient(gradient: Gradient(colors: [.clear, .white, .clear]), startPoint: .leading, endPoint: .trailing)
                    .rotationEffect(.degrees(70))
                    .offset(x: animation ? 200 : -200)
                    .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: animation)
            }
    }
}

extension View {
    func shimmering() -> some View {
        modifier(ShimmerEffect(animation: true))
    }
}

struct TopImagesGrid: View {
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(spacing: 8) {
                DynamicImage(url: "https://images.unsplash.com/photo-1582468546235-9bf31e5bc4a1", width: 110, height: 160)
                DynamicImage(url: "https://images.unsplash.com/photo-1504203328729-b937e8e102f2", width: 110, height: 180)
            }
            .padding(.top, 20)
            
            VStack(spacing: 16) {
                DynamicImage(url: "https://images.unsplash.com/photo-1548636200-691c76f69390", width: 110, height: 180)
                DynamicImage(url: "https://images.unsplash.com/photo-1515555585025-54136276b6e3", width: 110, height: 180)
            }
            .padding(.top, 10)
            
            VStack(spacing: 16) {
                DynamicImage(url: "https://images.unsplash.com/photo-1704560970210-ce67d310f369", width: 110, height: 150)
                DynamicImage(url: "https://images.unsplash.com/photo-1698613284017-c2f14a325fa3", width: 110, height: 190)
            }
            .padding(.top, 20)
        }
        .padding(.horizontal)
    }
}

struct GetStartedActions: View {
    //    let maxWidth: CGFloat
    private let maxWidth: CGFloat = UIScreen.main.bounds.width
    
    private let minWidth = CGFloat(50)
    @State private var width = CGFloat(50)
    @Binding var isLocked: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            Button(action: {
                print("Get Started Button Tapped")
            }) {
                Text("Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 200, height: 50)
                    .background(Color.teal)
                    .cornerRadius(10)
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.width > 0 {
                            width = min(max(value.translation.width + minWidth, minWidth), maxWidth)
                        }
                    }
            )
            .animation(.spring(response: 0.5, dampingFraction: 1, blendDuration: 0), value: width)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    ZStack(alignment: .leading)  {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.teal.opacity(0.4))
                        
                        Text("Slide to unlock")
                            .font(.footnote)
                            .bold()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                    }
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.teal)
                        .frame(width: width)
                        .overlay(
                            ZStack {
                                image(name: "lock", isShown: isLocked)
                                image(name: "lock.open", isShown: !isLocked)
                            },
                            alignment: .trailing
                        )
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    guard isLocked else { return }
                                    print("Drag Gesture Changed")
                                }
                                .onEnded { value in
                                    guard isLocked else { return }
                                    if width < maxWidth {
                                        width = minWidth
                                        UINotificationFeedbackGenerator().notificationOccurred(.warning)
                                    } else {
                                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                                        withAnimation(.spring().delay(0.5)) {
                                            isLocked = false
                                        }
                                    }
                                }
                        )
                }
            }
            .frame(height: 50)
            .padding()
            
            
            Text("Already have an account? Login")
                .font(.system(size: 16, weight: .regular, design: .serif))
                .foregroundColor(.gray)
                .padding(6)
        }
        .padding(.bottom, 50)
    }
    
    private func image(name: String, isShown: Bool) -> some View {
        Image(systemName: name)
            .font(.system(size: 20, weight: .regular, design: .rounded))
            .foregroundColor(.teal)
            .frame(width: 42, height: 42)
            .background(RoundedRectangle(cornerRadius: 14).fill(.white))
            .padding(4)
            .opacity(isShown ? 1 : 0)
            .scaleEffect(isShown ? 1 : 0.01)
    }
}
