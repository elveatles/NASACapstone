//
//  ApodPageController.swift
//  NASACapstone
//
//  Created by Erik Carlson on 1/25/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import UIKit

/// Page controller that shows APOD photos.
class ApodPageController: UIPageViewController {
    /// The item to start with.
    var startingItem: ApodItem?
    /// The source of the data. Each one represents one photo.
    var apodItems: [ApodItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        // Setup the starting view controller.
        if let startingItem = startingItem {
            let controller = instantiatePage()
            controller.apodItem = startingItem
            setViewControllers([controller], direction: .forward, animated: true, completion: nil)
        }
    }
    
    /// Convenience function for instantiating a page.
    private func instantiatePage() -> ApodItemController {
        let result = storyboard!.instantiateViewController(withIdentifier: String(describing: ApodItemController.self)) as! ApodItemController
        return result
    }
}

extension ApodPageController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let controller = viewController as! ApodItemController
        let index = apodItems.firstIndex(of: controller.apodItem)!
        let indexBefore = apodItems.index(before: index)
        guard indexBefore >= 0 else { return nil}
        let result = instantiatePage()
        result.apodItem = apodItems[indexBefore]
        return result
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let controller = viewController as! ApodItemController
        let index = apodItems.firstIndex(of: controller.apodItem)!
        let indexAfter = apodItems.index(after: index)
        guard indexAfter < apodItems.count else { return nil }
        let result = instantiatePage()
        result.apodItem = apodItems[indexAfter]
        return result
    }
}
