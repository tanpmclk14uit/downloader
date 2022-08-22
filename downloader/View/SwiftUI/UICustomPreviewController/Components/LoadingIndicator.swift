//
//  LoadingIndicator.swift
//  downloader
//
//  Created by LAP14812 on 21/08/2022.
//

import SwiftUI

@available(iOS 13.0.0, *)
struct LoadingIndicator: View {
    
    @State var animate = false
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Circle()
                    .trim(from: 0, to: 0.8)
                    .stroke(.white, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                
                    .frame(width: 45, height: 45)
                    .rotationEffect(.init(degrees: self.animate ? 0:360))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                
                Text("Loading...")
                    .foregroundColor(.white)
                    .padding()
            }.onAppear{
                self.animate.toggle()
            }.opacity(0.5)
                .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }
}

@available(iOS 13.0.0, *)
struct LoadingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
            LoadingIndicator()
        }
    }
}
