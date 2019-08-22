//
//  ViewController.swift
//  TesteiOS_Marvel
//
//  Created by Francisco Costa Neto on 21/08/19.
//  Copyright © 2019 Francisco Costa Neto. All rights reserved.
//

import UIKit

protocol ViewController {
    func addObstructiveLoading()
    func removeObstructiveLoading()
}

extension UIViewController: Storyboarded {
    func instantiate(fromStoryboard storyboardName: String) -> Self {
        return self
    }
}

extension UIViewController: ViewController {
    func presentError(_ error: String, code: String, actions: [UIAlertAction] = []) {
        let alertController = UIAlertController(
            title: "Oh oh!",
            message: error + " | code " + code,
            preferredStyle: UIAlertController.Style.alert)
        
        if actions.isEmpty {
            alertController.addAction(UIAlertAction(
                title: "Ok",
                style: .cancel,
                handler: nil))
        } else {
            for action in actions {
                alertController.addAction(action)
            }
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentASuccessAlert(withMessage: String, actions: [UIAlertAction] = []) {
        let alertController = UIAlertController(
            title: "Yeah!",
            message: withMessage,
            preferredStyle: UIAlertController.Style.alert)
        if actions.isEmpty {
            alertController.addAction(UIAlertAction(
                title: "Ok",
                style: .cancel,
                handler: nil))
        } else {
            for action in actions {
                alertController.addAction(action)
            }
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func addObstructiveLoading() {
        let loadingView = UIView(frame: UIScreen.main.bounds)
        loadingView.backgroundColor = .black
        loadingView.alpha = 0.0
        loadingView.tag = 50214
        
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.center = loadingView.center
        activityIndicator.tintColor = .white
        loadingView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        self.view.addSubview(loadingView)
        
        UIView.animate(withDuration: 0.3) {
            loadingView.alpha = 0.4
        }
    }
    
    func removeObstructiveLoading() {
        guard let loadingView = self.view.subviews.first(where: { $0.tag == 50214 }) else { return }
        UIView.animate(withDuration: 0.25, animations: {
            loadingView.alpha = 0.0
        }, completion: { _ in
            loadingView.removeFromSuperview()
        })
    }
}
