//
//  PageViewController.swift
//  downloader
//
//  Created by LAP14812 on 23/08/2022.
//

import SwiftUI
import UIKit

@available(iOS 13, *)
struct PageViewController<Page: View>: UIViewControllerRepresentable {
    var pages: [Page]
    @Binding var currentPage: Int
    @Binding var slideAble: Bool
    @Binding var shouldShowAppBar: Bool
    
    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator(self)
        return coordinator
    }
    
    
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal)
        pageViewController.view.backgroundColor = .clear
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator
        
        return pageViewController
    }
    
    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        if(slideAble){
            pageViewController.dataSource = context.coordinator
        }else{
            pageViewController.dataSource = nil
        }
        pageViewController.setViewControllers(
            [context.coordinator.controllers[currentPage]], direction: .forward, animated: true)
    }
    
    
    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: PageViewController
        var controllers = [UIViewController]()
        var slideForward = true
        
        init(_ pageViewController: PageViewController) {
            parent = pageViewController
            for page in parent.pages {
                let controller = UIHostingController(rootView: page)
                controller.view.backgroundColor = .clear
                controllers.append(controller)
            }
        }
        
        
        func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
            guard let nextIndex = controllers.firstIndex(of: pendingViewControllers[0]) else {
                return
            }
            if(nextIndex > parent.currentPage){
                slideForward = true
            }else{
                slideForward = false
            }
        }
        
        
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if(completed){
                guard let preIndex = controllers.firstIndex(of: previousViewControllers[0]) else {
                    return
                }
                if slideForward{
                    parent.currentPage = preIndex + 1
                }else{
                    parent.currentPage = preIndex - 1
                }
            }
        }
        
        
        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerBefore viewController: UIViewController) -> UIViewController?
        {
            
            guard let index = controllers.firstIndex(of: viewController)
            else {
                return nil
            }
            
            if index == 0 {
                return nil
            }
            
            
            return controllers[index - 1]
        }
        
        
        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerAfter viewController: UIViewController) -> UIViewController?
        {
            guard let index = controllers.firstIndex(of: viewController)
            else {
                return nil
            }
            if index + 1 == controllers.count {
                return nil
            }
            
            return controllers[index + 1]
        }
    }
}
