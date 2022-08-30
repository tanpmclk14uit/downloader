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
    @Binding var isInZoomMode: Bool
    @Binding var imageSize: CGSize
    
    func makeCoordinator() -> Coordinator {
        let controller = UIHostingController(rootView: self.content)
        controller.view.backgroundColor = .clear
        return Coordinator(self,hostingController: controller)
    }
    
    private let scrollViewToZoom: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.maximumZoomScale = 4
        scrollView.minimumZoomScale = 1
        scrollView.bounces = false
        
        return scrollView
    }()
    
    func makeUIView(context: Context) -> UIScrollView {
        
        scrollViewToZoom.delegate = context.coordinator  // for viewForZooming(in:)
        // create a UIHostingController to hold our SwiftUI content
        let hostedView = context.coordinator.hostingController.view!
        hostedView.translatesAutoresizingMaskIntoConstraints = false
        scrollViewToZoom.addSubview(hostedView)
        
        // config hosted view constraint
        hostedView.leadingAnchor.constraint(equalTo: scrollViewToZoom.leadingAnchor).isActive = true
        hostedView.trailingAnchor.constraint(equalTo: scrollViewToZoom.trailingAnchor).isActive = true
        hostedView.bottomAnchor.constraint(equalTo: scrollViewToZoom.bottomAnchor).isActive = true
        hostedView.topAnchor.constraint(equalTo: scrollViewToZoom.topAnchor).isActive = true
        hostedView.widthAnchor.constraint(equalTo: scrollViewToZoom.widthAnchor).isActive = true
        hostedView.heightAnchor.constraint(equalTo: scrollViewToZoom.heightAnchor).isActive = true
        
        let doubleTap = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.onDoubleTapImageToScale))
        doubleTap.numberOfTapsRequired = 2
        scrollViewToZoom.addGestureRecognizer(doubleTap)
        
        
        return scrollViewToZoom
    }
    
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        // update the hosting controller's SwiftUI content
        
        let hostedController = context.coordinator.hostingController
        hostedController.rootView = self.content
        hostedController.view.center = uiView.center
        
        
        context.coordinator.centreView(scrollView: uiView)
        
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
        
        func centreView(scrollView: UIScrollView){
            let offSetX = max((scrollView.bounds.size.width - scrollView.contentSize.width)*0.5, 0.0)
            let offSetY = max((scrollView.bounds.size.height - scrollView.contentSize.height)*0.5, 0.0)
            hostingController.view.center = CGPoint(x: scrollView.contentSize.width*0.5+offSetX, y: scrollView.contentSize.height*0.5+offSetY)
        }
        
        @objc func onDoubleTapImageToScale(sender: UITapGestureRecognizer){
            let hostedView = hostingController.view!
            let scale = parent.scrollViewToZoom.zoomScale * 2
            if scale <= parent.scrollViewToZoom.maximumZoomScale{// zoom in
                let point = sender.location(in: hostedView)
                let scrollSize = parent.scrollViewToZoom.frame.size
                let size = CGSize(width: scrollSize.width / scale,
                                  height: scrollSize.height / scale)
                let origin = CGPoint(x: point.x - size.width / 2,
                                     y: point.y - size.height / 2)
                parent.scrollViewToZoom.zoom(to:CGRect(origin: origin, size: size), animated: true)
            } else { // zoom out
                parent.scrollViewToZoom.setZoomScale(1.0, animated: true)
            }
        }
        
        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            
            
            if(scrollView.zoomScale != 1    ){
                parent.isInZoomMode = true
                
            }else{
                parent.isInZoomMode = false
            }
            
            
            centreView(scrollView: scrollView)
            
            if(scrollView.zoomScale >= 1){
                if let imageView = hostingController.view{
                    let ratioW = imageView.frame.width / parent.imageSize.width
                    let ratioH = imageView.frame.height / parent.imageSize.height
                    
                    let ratio = ratioW < ratioH ? ratioW : ratioH
                    let newWidth = parent.imageSize.width * ratio
                    let newHeight = parent.imageSize.height * ratio
                    
                    let conditionLeft = newWidth*scrollView.zoomScale > imageView.frame.width
                    let left = 0.5  * (conditionLeft ? newWidth - imageView.frame.width : (scrollView.frame.width - scrollView.contentSize.width))
                    
                    let conditionTop = newHeight*scrollView.zoomScale > imageView.frame.height
                    
                    let top = 0.5 * (conditionTop ? newHeight - imageView.frame.height : (scrollView.frame.height - scrollView.contentSize.height))
                    
                    scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
                }
            }
        }
    }
}
