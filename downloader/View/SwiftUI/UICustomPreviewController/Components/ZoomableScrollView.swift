//
//  ZoomableScrollView.swift
//  downloader
//
//  Created by LAP14812 on 25/08/2022.
//

import Foundation
import SwiftUI

@available(iOS 13, *)
struct ZoomableScrollView<Content: View>: UIViewRepresentable{
    var content: Content
    @Binding var slideAble: Bool
    @Binding var isInZoomMode: Bool
    
    
    func makeUIView(context: Context) -> UIScrollView {
        // set up the UIScrollView
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.delegate = context.coordinator  // for viewForZooming(in:)
        scrollView.maximumZoomScale = 4
        scrollView.minimumZoomScale = 1
        scrollView.bounces = false
        
        // create a UIHostingController to hold our SwiftUI content
        let hostedView = context.coordinator.hostingController.view!
        hostedView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(hostedView)
        
        hostedView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        hostedView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        hostedView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        hostedView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        hostedView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        hostedView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        
        return scrollView
    }
    
    func makeCoordinator() -> Coordinator {
        let controller = UIHostingController(rootView: self.content)
        controller.view.backgroundColor = .clear
        return Coordinator(self,hostingController: controller)
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        // update the hosting controller's SwiftUI content
        context.coordinator.hostingController.rootView = self.content
        context.coordinator.hostingController.view.center = uiView.center
        assert(context.coordinator.hostingController.view.superview == uiView)
    }
    
    // MARK: - Coordinator
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        let parent: ZoomableScrollView
        
        var hostingController: UIHostingController<Content>
        
        init(_ zoomableScrollView: ZoomableScrollView, hostingController: UIHostingController<Content>) {
            self.parent = zoomableScrollView
            self.hostingController = hostingController
        }
        
        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return hostingController.view
        }
        
        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            let offSetX = max((scrollView.bounds.size.width - scrollView.contentSize.width)*0.5, 0.0)
            let offSetY = max((scrollView.bounds.size.height - scrollView.contentSize.height)*0.5, 0.0)
            hostingController.view.center = CGPoint(x: scrollView.contentSize.width*0.5+offSetX, y: scrollView.contentSize.height*0.5+offSetY)
            
            if(scrollView.zoomScale != 1){
                parent.isInZoomMode = true
                parent.slideAble = false
            }else{
                parent.slideAble = true
                parent.isInZoomMode = false
            }
            
//
//            if(scrollView.zoomScale >= 1){
//                if let image = imageView.image{
//                    let ratioW = imageView.frame.width / image.size.width
//                    let ratioH = imageView.frame.height / image.size.height
//
//                    let ratio = ratioW < ratioH ? ratioW : ratioH
//                    let newWidth = image.size.width * ratio
//                    let newHeight = image.size.height * ratio
//
//                    let conditionLeft = newWidth*scrollView.zoomScale > imageView.frame.width
//                    let left = 0.5  * (conditionLeft ? newWidth - imageView.frame.width : (scrollView.frame.width - scrollView.contentSize.width))
//
//                    let conditionTop = newHeight*scrollView.zoomScale > imageView.frame.height
//
//                    let top = 0.5 * (conditionTop ? newHeight - imageView.frame.height : (scrollView.frame.height - scrollView.contentSize.height))
//
//                    scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
//                }
//            }
        }
    }
}
