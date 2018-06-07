//
//  WalkThroughVC.swift
//  Mutelcore
//
//  Created by Appinventiv on 04/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class WalkThroughVC: BaseViewController {
    
    //properties
    var walkthroughPage1 : WalkThroughPageVC!
    var walkthroughPage2 : WalkThroughPageVC!
    
    var walkthroughPage3 : WalkThroughPageVC!
    var walkthroughPage4 : WalkThroughPageVC!
    
    
    //outlets
    @IBOutlet weak var walkThroughScrollView: UIScrollView!
    @IBOutlet weak var walkthroughPageControl: UIPageControl!

    @IBOutlet weak var skipFromWalkThrough: UIButton!
    @IBOutlet weak var nextPage: UIButton!
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setupSubViews
        self.setupSubViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //setupviewDidLayoutSubviews
        self.setupviewDidLayoutSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: Private Functions
extension WalkThroughVC{
    
    fileprivate func setupSubViews(){
        
        //instantiate walkthrough pages.
        let walkthroughPage1 = WalkThroughPageVC.instantiate(fromAppStoryboard: .Main)
        self.walkthroughPage1 = walkthroughPage1
        
        let walkthroughPage2 = WalkThroughPageVC.instantiate(fromAppStoryboard: .Main)
        self.walkthroughPage2 = walkthroughPage2
        
        let walkthroughPage3 = WalkThroughPageVC.instantiate(fromAppStoryboard: .Main)
        self.walkthroughPage3 = walkthroughPage3
        
        let walkthroughPage4 = WalkThroughPageVC.instantiate(fromAppStoryboard: .Main)
        self.walkthroughPage4 = walkthroughPage4
        
        //adding walkthrough pages as child view
        self.addChildViewController(walkthroughPage1)
        self.addChildViewController(walkthroughPage2)
        self.addChildViewController(walkthroughPage3)
        self.addChildViewController(walkthroughPage4)
        
        //adding subview to walkthrough scroll view
        self.walkThroughScrollView.addSubview(walkthroughPage1.view)
        self.walkThroughScrollView.addSubview(walkthroughPage2.view)
        self.walkThroughScrollView.addSubview(walkthroughPage3.view)
        self.walkThroughScrollView.addSubview(walkthroughPage4.view)
        
        //setting up scroll view delegate
        self.walkThroughScrollView.delegate = self
        
        //adding targets to  skip and next buttton
        nextPage.addTarget(self, action: #selector(goToNextPage(_:)), for: .touchUpInside)
        
        skipFromWalkThrough.addTarget(self, action: #selector(skipWalkThrough(_:)), for: .touchUpInside)
                
    }
    
    fileprivate func setupviewDidLayoutSubviews(){
        
        //frame of walkthrough scroll view
        let walkThroughScrollViewHeight = self.walkThroughScrollView.frame.height
        let walkThroughScrollViewWidth = self.view.frame.width
        
        walkThroughScrollView.frame.size = CGSize(width: self.view.frame.width,
                                                  height: walkThroughScrollViewHeight)
        
        walkThroughScrollView.contentSize = CGSize(width: walkThroughScrollViewWidth * 4,
                                                   height: walkThroughScrollViewHeight)
        
        //frame of walkthrough page 1
        walkthroughPage1.view.frame = CGRect(x: 0,
                                             y: 0,
                                             width: walkThroughScrollViewWidth,
                                             height: walkThroughScrollViewHeight)
        
        //frame of walkthrough page 2
        walkthroughPage2.view.frame = CGRect(x: walkThroughScrollViewWidth,
                                             y: 0,
                                             width: walkThroughScrollViewWidth,
                                             height: walkThroughScrollViewHeight)
        
        //frame of walkthrough page 3
        walkthroughPage3.view.frame = CGRect(x: walkThroughScrollViewWidth * 2,
                                             y: 0,
                                             width: walkThroughScrollViewWidth,
                                             height: walkThroughScrollViewHeight)
        
        //frame of walkthrough page 4
        walkthroughPage4.view.frame = CGRect(x: walkThroughScrollViewWidth * 3,
                                             y: 0,
                                             width: walkThroughScrollViewWidth,
                                             height: walkThroughScrollViewHeight)
        
    }
}

//MARK: UIScrollViewDelegate
extension WalkThroughVC: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        walkthroughPageControl.currentPage = Int(pageNumber)
        
    }
    
}

//MARK: IBActions
extension WalkThroughVC{
    
    //go to next page
    func goToNextPage(_ sender: UIButton){
        
        if self.walkThroughScrollView.contentOffset.x < (self.view.frame.width * 3){
        
            UIView.animate(withDuration: 0.3,
                           delay: 0.0,
                           options: .curveLinear,
                           animations: {
                            self.walkThroughScrollView.contentOffset.x += self.view.frame.width
                            },
                           completion: nil)
        }else{
            
            skipWalkThrough(sender)
        }
        
    }
    
    //go to next page
    func skipWalkThrough(_ sender: UIButton){
        
        printlnDebug("Walkthrough Ended")
        
        let signInPage = SignInVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(signInPage, animated: true)
        
    }
}
