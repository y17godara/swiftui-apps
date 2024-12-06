import SwiftUI

struct LoadingScreen: View {
    @State private var isLocked: Bool = true // Define state outside the body
    let onNext: () -> Void
    var body: some View {
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
                
                VStack(spacing: 10) {
                    // Use the extracted SlideToUnlockButton
                    SlideToUnlockButton(isLocked: $isLocked, onNext: onNext)
                        .padding(.horizontal, 8)
                        .frame(maxWidth: 300)
                    
                    Text("Already have an account? Login")
                        .font(.system(size: 16, weight: .regular, design: .serif))
                        .foregroundColor(.gray)
                        .padding(6)
                }
                .padding(.bottom, 50)
            }
            .background(.white)
            .frame(maxHeight: .infinity)
        }
        .edgesIgnoringSafeArea(.all)
        .ignoresSafeArea()
    }
}

// Preview for the Loading Screen
struct LoadingScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoadingScreen{
            print("Get Started tapped!")
        }
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

struct SlideToUnlockButton: View {
    @Binding var isLocked: Bool
    let onNext: () -> Void // Closure to handle the unlock action
    private let maxWidth: CGFloat = 300
    private let minWidth: CGFloat = 50
    
    @State private var sliderWidth: CGFloat = 50 // Initial width of the slider
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.teal.opacity(0.4))
                    .overlay(
                        Text("Slide to unlock")
                            .font(.footnote)
                            .bold()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                    )
                
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.teal)
                    .frame(width: sliderWidth)
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
                                sliderWidth = min(max(minWidth + value.translation.width, minWidth), maxWidth)
                            }
                            .onEnded { _ in
                                guard isLocked else { return }
                                if sliderWidth >= maxWidth {
                                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                                    print("Unlocked")
                                    withAnimation(.spring()) {
                                        isLocked = false
                                    }
                                    onNext() // Call onNext when unlocked
                                } else {
                                    UINotificationFeedbackGenerator().notificationOccurred(.warning)
                                    withAnimation(.easeOut) {
                                        sliderWidth = minWidth
                                        print("Locked")
                                    }
                                }
                            }
                    )
            }
        }
        .frame(height: 50)
        
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
