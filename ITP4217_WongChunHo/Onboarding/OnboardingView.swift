import SwiftUI
import FluidGradient

struct OnboardingView: View {
    
    let onboardData = OnboardingCardsData()
    
    @State private var scrollEffectValue: Double = 13
    @State private var activePageIndex: Int = 0
    
    let itemWidth: CGFloat = 260
    let itemPadding: CGFloat = 20
    
    var body: some View {
        ZStack{
            FluidGradient(blobs: [.blue, .nightBlue, .blue],highlights: [.blue, .nightBlue, .blue],speed: 1.0, blur: 0.7)
                          
            VStack(alignment: .center, spacing: 25) {
                HStack {
                    PageControl(numberOfPages: self.onboardData.cards.count,
                                currentPage: $activePageIndex)
//                    .foregroundColor(Color.red)
                    .aspectRatio(3 / 2, contentMode: .fit)
                    .frame(width: 165, height: 42)
                    Spacer()
                }
                GeometryReader { geometry in
                    AdaptivePagingScrollView(currentPageIndex: self.$activePageIndex,
                                             itemsAmount: self.onboardData.cards.count - 1,
                                             itemWidth: self.itemWidth,
                                             itemPadding: self.itemPadding,
                                             pageWidth: geometry.size.width) {
                        ForEach(onboardData.cards) { card in
                            GeometryReader { screen in
                                OnbardingCardView(card: card)
                                    .rotation3DEffect(Angle(degrees: (Double(screen.frame(in: .global).minX) - 20) / -15),
                                                      axis: (x: 0, y: 90.0, z: 0))
                                
                                    .scaleEffect(activePageIndex == onboardData.cards.firstIndex(of: card) ?? 0 ? 1.05 : 1)
                            }
                            .frame(width: self.itemWidth, height: 600)
                        }
                    }
                }
                
                Spacer()
                
                OnboardingContinueButton(isReadyToContinue: .constant(onboardData.cards.count - 1 == activePageIndex) )
                    .padding(.bottom, 50)
            }
            .padding(.top, 50)
        }
        .ignoresSafeArea()
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
