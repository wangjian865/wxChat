//
//  RelationViewController.swift
//  login
//
//  Created by gwj on 2019/6/26.
//  Copyright © 2019 com.ailearn.student. All rights reserved.
//

import UIKit


class RelationViewController: UIViewController {
    @IBOutlet weak var headerView: RelationHeaderView!
    private let searchView = UINib(nibName: "RelationSearchView", bundle: Bundle.main).instantiate(withOwner: self, options: nil).first as! RelationSearchView
    private let segmentedControl = HMSegmentedControl(sectionTitles: ["好友","公司","群聊"])
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    private var childVCs = [UIViewController]()
    
    private var currentIndex: Int = 0{
        didSet {
            segmentedControl?.selectedSegmentIndex = currentIndex
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.editButton.addTarget(self, action: #selector(gotoEditPersonInfoVC), for: .touchUpInside)
        setUI()
        addChildVC()
    }
    @objc func gotoEditPersonInfoVC(){
        let sb = UIStoryboard.init(name: "RelationViewController", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "personInfoVC")
        navigationController?.pushViewController(vc, animated: true)
    }
    private func setUI() {
        guard let segmentedControl = segmentedControl else {
            return
        }
        view.addSubview(segmentedControl)
        view.addSubview(searchView)
        segmentedControl.selectionIndicatorLocation = .down
        segmentedControl.selectionIndicatorHeight = 3
        segmentedControl.snp.makeConstraints({ (make) in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        })
        searchView.snp.makeConstraints { (make) in
            make.top.equalTo(segmentedControl.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(53)
        }
        currentIndex = 0
        view.addSubview(pageViewController.view)
        pageViewController.view.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom)
        }
        pageViewController.delegate = self
        pageViewController.dataSource = self
    }
    
    public func transition(to index: Int, animated: Bool = false) {
        let newIndex = currentIndex
        currentIndex = index
        var direction = UIPageViewController.NavigationDirection.reverse
        if newIndex < currentIndex {
            direction = .forward
        }
        let vc = childVCs[index]
        pageViewController.setViewControllers([vc], direction: direction, animated: animated, completion: nil)
    }
    
    private func addChildVC() {
        let vc = FriendsVC()
        vc.superVC = self
        vc.view.tag = 0
        let vc2 = CompanyVC()
        vc2.superVC = self
        vc2.view.tag = 1
        let vc3 = GroupChatVC()
        vc3.superVC = self
        vc3.view.tag = 2
        childVCs = [vc, vc2, vc3]
        pageViewController.setViewControllers([vc], direction: .forward, animated: true, completion: nil)
        segmentedControl?.indexChangeBlock = {[weak self] index in
            guard let self = self else {
                return
            }
            let newIndex = self.currentIndex
            self.currentIndex = index
            var direction = UIPageViewController.NavigationDirection.reverse
            if newIndex < self.currentIndex {
                direction = .forward
            }
            let vc = self.childVCs[index]
            self.pageViewController.setViewControllers([vc], direction: direction, animated: true, completion: nil)
        }
    }
}


extension RelationViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController,
                                   viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let index = currentIndex - 1
        print("before\(index)")
        if index > 2 || index < 0 {
            return nil
        }
        let vc = childVCs[index]
        return vc
    }

    public func pageViewController(_ pageViewController: UIPageViewController,
                                   viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = currentIndex + 1
        print("after\(index)")
        if index > 2 || index < 0 {
            return nil
        }
        let vc = childVCs[index]

        return vc
    }

    public func pageViewController(_ pageViewController: UIPageViewController,
                                   didFinishAnimating finished: Bool,
                                   previousViewControllers: [UIViewController],
                                   transitionCompleted completed: Bool) {
        guard let currentViewController = pageViewController.viewControllers?.first else {
            return
        }
        print("currentIndex\(currentIndex)")
        currentIndex = currentViewController.view.tag
        segmentedControl?.selectedSegmentIndex = currentIndex
    }
}

