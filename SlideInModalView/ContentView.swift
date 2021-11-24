//
//  ContentView.swift
//  SlideInModalView
//
//  Created by Arkasha Zuev on 24.11.2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            VStack {
                Text("Swipe Up")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .shadow(color: Color.black.opacity(0.05), radius: 8, y: 5)
                    .foregroundColor(.white)
                
                Text("👆")
                    .font(.system(size: 70))
                    .shadow(color: Color.black.opacity(0.05), radius: 8, y: 5)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.purple.opacity(0.8))
            .ignoresSafeArea()
            
            VStack {
                SwipableView()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

struct SwipableView: View {
    @State var height: CGFloat = 100
    @State var emojiIndex = 0
    
    let emojis = ["😋","🤪","😝","🤨","🧐","😎","🥳","💩","😈","👺","👹","🎃","💀","👾"]
    
    let minHeight: CGFloat = 100
    let maxHeight: CGFloat = 600
    
    var emoji: String {
        emojis[emojiIndex]
    }
    
    var percentage: Double {
        Double(height / maxHeight)
    }
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            Color.black
                .ignoresSafeArea(edges: .all)
                .opacity(min(0.7, percentage - 0.1))
                .onTapGesture {
                    withAnimation(Animation.easeInOut(duration: 0.4)) {
                        height = minHeight
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        setEmojiIndex(emojiIndex + 1)
                    }
                }
            
            VStack(spacing: 0) {
                ZStack {
                    Capsule()
                        .foregroundColor(Color.black)
                        .opacity(0.5)
                        .frame(width: 150, height: 10)
                }
                .frame(height: 40)
                .frame(maxWidth: .infinity)
                .background(Color.blue.blendMode(.multiply))
                .gesture(dragGesture)
                
                VStack(spacing: 40) {
                    HStack(spacing: 70 ) {
                        Text(emoji)
                            .font(.system(size: 60))
                    }
                    
                    Text("Hello World")
                        .font(.system(size: 30, weight: .semibold, design: .rounded))
                        .opacity(0.8)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.white)
                )
                .padding(.all, 20)
                .opacity(1.5 * (percentage - 0.2))
            }
            .frame(maxWidth: .infinity)
            .frame(height: height, alignment: .top)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
    
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { val in
                var newHeight = height - val.translation.height
                
                if newHeight > maxHeight {
                    newHeight = maxHeight - val.translation.height / 2
                } else if newHeight < minHeight {
                    newHeight = minHeight
                }
                
                height = newHeight
            }
            .onEnded { val in
                let precentage = height / maxHeight
                var finalHeight = maxHeight
                
                if precentage < 0.45 {
                    finalHeight = minHeight
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        setEmojiIndex(emojiIndex + 1)
                    }
                }
                
                withAnimation(Animation.easeOut(duration: 0.3)) {
                    height = finalHeight
                }
            }
    }
    
    func setEmojiIndex(_ value: Int) {
        emojiIndex = value % emojis.count
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
