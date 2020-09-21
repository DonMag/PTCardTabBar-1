//
//  TabBarControllerViewController.swift
//  SketchNUR
//
//  Created by Hussein Al-Ryalat on 11/12/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit

open class PTCardTabBarController: UITabBarController {
    
    
    @IBInspectable public var tintColor: UIColor? {
        didSet {
            customTabBar.tintColor = tintColor
            customTabBar.reloadApperance()
        }
    }
    
    @IBInspectable public var tabBarBackgroundColor: UIColor? {
        didSet {
            customTabBar.backgroundColor = tabBarBackgroundColor
            customTabBar.reloadApperance()
        }
    }
    
    lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    fileprivate lazy var smallBottomView: UIView = {
        let anotherSmallView = UIView()
        anotherSmallView.backgroundColor = .clear
        anotherSmallView.translatesAutoresizingMaskIntoConstraints = false

        return anotherSmallView
    }()
    
    override open var selectedIndex: Int {
        didSet {
            customTabBar.select(at: selectedIndex, notifyDelegate: false)
        }
    }

    override open var selectedViewController: UIViewController? {
        didSet {
            customTabBar.select(at: selectedIndex, notifyDelegate: false)
        }
    }
    
    fileprivate var bottomSpacing: CGFloat = 20
    fileprivate var tabBarHeight: CGFloat = 70
    fileprivate var horizontleSpacing: CGFloat = 20
    
	fileprivate var ctbTopAnchor: NSLayoutConstraint!
	fileprivate var ctbBotAnchor: NSLayoutConstraint!
	
	open func showTabBar(_ bShow: Bool, animated: Bool) {
		// return if
		//	we want to show it, but it's already showing, or
		//	we want to hide it, but it's already hidden
		if bShow && ctbBotAnchor.isActive || !bShow && ctbTopAnchor.isActive { return }
		
		if !bShow {
			ctbBotAnchor.isActive = false
			ctbTopAnchor.isActive = true
		} else {
			ctbTopAnchor.isActive = false
			ctbBotAnchor.isActive = true
		}
		if #available(iOS 11.0, *) {
			self.additionalSafeAreaInsets = bShow ? UIEdgeInsets(top: 0, left: 0, bottom: tabBarHeight + bottomSpacing, right: 0) : .zero
		}
		let dur = animated ? 0.3 : 0.0
		UIView.animate(withDuration: dur, animations: {
			self.view.layoutIfNeeded()
		})
		
	}
	
	open override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		// move "built-in" tab bar below view frame
		var r = tabBar.frame
		r.origin.y = self.view.frame.maxY + 1
		tabBar.frame = r
	}
	
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: tabBarHeight + bottomSpacing, right: 0)
        }
        
        
        self.tabBar.isHidden = true

        addAnotherSmallView()
        setupTabBar()
        
        customTabBar.items = tabBar.items!
        customTabBar.select(at: selectedIndex)
    }
    
    fileprivate func addAnotherSmallView(){
        self.view.addSubview(smallBottomView)
        
        smallBottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        
        let cr: NSLayoutConstraint
        
        if #available(iOS 11.0, *) {
            cr = smallBottomView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: tabBarHeight)
        } else {
            cr = smallBottomView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: tabBarHeight)
        }
        
        cr.priority = .defaultHigh
        cr.isActive = true
        
        smallBottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        smallBottomView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    fileprivate func setupTabBar(){
        customTabBar.delegate = self
        self.view.addSubview(customTabBar)
        
		ctbBotAnchor = customTabBar.bottomAnchor.constraint(equalTo: smallBottomView.topAnchor, constant: 0)
		ctbTopAnchor = customTabBar.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
		
		ctbBotAnchor.isActive = true
		
        customTabBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        customTabBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: horizontleSpacing).isActive = true
        customTabBar.heightAnchor.constraint(equalToConstant: tabBarHeight).isActive = true
        
        self.view.bringSubviewToFront(customTabBar)
        self.view.bringSubviewToFront(smallBottomView)
        
        customTabBar.tintColor = tintColor
    }
}

extension PTCardTabBarController: CardTabBarDelegate {
    func cardTabBar(_ sender: PTCardTabBar, didSelectItemAt index: Int) {
        self.selectedIndex = index
    }
}
