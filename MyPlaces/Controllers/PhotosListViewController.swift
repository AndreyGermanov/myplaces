//
//  PhotosListViewController.swift
//  MyPlaces
//
//  Created by Andrey Germanov on 25.01.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

import UIKit

class PhotosListViewController: UIPageViewController {

    var place: Place?
    var photoIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
        
    }
}

extension PhotosListViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if photoIndex == 0 {
            return nil
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "photoViewController") as? PhotoViewController {
                self.photoIndex = self.photoIndex-1
                if let place = self.place {
                    let photo = place.photos[self.photoIndex]
                    vc.photo = photo
                    vc.photoIndex = self.photoIndex
                    return vc
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if photoIndex<self.place!.photos.count-1 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "photoViewController") as? PhotoViewController {
                self.photoIndex = self.photoIndex+1
                if let place = self.place {
                    let photo = place.photos[self.photoIndex]
                    vc.photo = photo
                    vc.photoIndex = self.photoIndex
                    return vc
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    
}
