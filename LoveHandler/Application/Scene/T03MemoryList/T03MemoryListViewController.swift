//
//  T03MemoryListViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 10/06/2021.
//

import UIKit
import Combine
import Hero

class T03MemoryListViewController: BaseViewController {
    
    @IBOutlet weak var addButton: RoundButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toTopButton: RoundButton!
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var bannerHeightConstraint: NSLayoutConstraint!
    
    var viewModel: T03MemoryListViewModel?
    
    private var cancellables = Set<AnyCancellable>()
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var backgroundTap: UITapGestureRecognizer?

    private var onViewDidAppearSignal = PassthroughSubject<Void, Never>()
    private var onSelectedMemory = PassthroughSubject<CDMemory, Never>()
    private var onSearchStringChange = PassthroughSubject<String, Never>()

    private var memories: [CDMemory] = []
    
    private var isToTopButtonShow = false
    
    override func deinitView() {
        onViewDidAppearSignal.send(completion: .finished)
        onSelectedMemory.send(completion: .finished)
        onSearchStringChange.send(completion: .finished)
        cancellables.forEach { $0.cancel() }
    }
    
    override func setupView() {
        super.setupView()
        isBackButtonVisible = true
        isTitleVisible = true
        toTopButton.alpha = 0.0

        setupCollectionView()
        setupTransitionAnimation()
        setupSearchBarController()
        setupTapBackground()
    }
    
    override func refreshView() {
        super.refreshView()
        setBannerView(with: bannerView,
                      heightConstraint: bannerHeightConstraint)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        onViewDidAppearSignal.send(Void())
        onSearchStringChange.send("")
    }
    
    override func setupLocalizedString() {
        super.setupLocalizedString()
        navigationTitle = LocalizedString.t03NavigationTitle
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = viewModel else { return }
        
        let input = T03MemoryListViewModel.Input(viewDidAppear: onViewDidAppearSignal.eraseToAnyPublisher(),
                                                 dismissTrigger: closeButton.tapPublisher,
                                                 addButtonTrigger: addButton.tapPublisher,
                                                 selectedMemoryTrigger: onSelectedMemory.eraseToAnyPublisher(),
                                                 searchString: onSearchStringChange.eraseToAnyPublisher())
        
        let output = viewModel.transform(input)
        
        output.memories.sink(receiveValue: { [weak self] list in
            guard let self = self else { return }
            self.memories = list
            self.collectionView.reloadData()
        }).store(in: &cancellables)
        
        output.noRespone.sink(receiveValue: {}).store(in: &cancellables)
    }
    
    override func setupTheme() {
        super.setupTheme()
        addButton.backgroundColor = Colors.hotPink
        searchController.searchBar.tintColor = UIColor.white
        
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField

        textFieldInsideSearchBar?.textColor = UIColor.white
        textFieldInsideSearchBar?.backgroundColor = Colors.pink
    }
    
    override func keyboarDidShow(keyboardHeight: CGFloat) {
        super.keyboarDidShow(keyboardHeight: keyboardHeight)
        collectionView.setContentOffset(collectionView.contentOffset, animated: false)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: keyboardHeight + 10, right: 10)
    }

    override func keyboarDidHide() {
        super.keyboarDidHide()
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        setupCollectionViewCell()
        setupCollectionViewLayout()
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    private func setupCollectionViewCell() {
        let collectionViewNib = UINib(nibName: MemoryCollectionViewCell.className, bundle: nil)
        collectionView.register(collectionViewNib, forCellWithReuseIdentifier: MemoryCollectionViewCell.className)
    }
    
    private func setupCollectionViewLayout() {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = 3.0
        layout.minimumInteritemSpacing = 3.0
        collectionView.collectionViewLayout = layout
    }
    
    private func setupTransitionAnimation() {
        addButton.hero.id = HeroIdentifier.addButtonIdentifier
    }
    
    private func setupTapBackground() {
        backgroundTap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        backgroundTap?.cancelsTouchesInView = false
        collectionView.isUserInteractionEnabled = true
        collectionView.addGestureRecognizer(backgroundTap!)
    }
    
    @objc private func onTap() {
        searchController.searchBar.resignFirstResponder()
    }
    
    @IBAction func toTopButtonAction(_ sender: Any) {
        collectionView.setContentOffset(CGPoint(x: -10, y: -10), animated: true)
    }
}

extension T03MemoryListViewController: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let memory = memories[safe: indexPath.item],
              let data = memory.image,
              let image = UIImage(data: data) else { return CGSize.zero }
        let size = image.size
        return CGSize(width: size.width / 10, height: size.height / 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnCountFor section: Int) -> Int {
        return 2
    }
}

extension T03MemoryListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemoryCollectionViewCell.className, for: indexPath) as? MemoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let memory = memories[safe: indexPath.item] else { return UICollectionViewCell() }
        cell.setupContent(memory: memory)
        
        if !cell.isAnimated {
            UIView.animate(withDuration: 0.5,
                           delay: 0.5 * Double(indexPath.row),
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0.5,
                           options: .transitionCurlUp,
                           animations: {
                            AnimationUtility.viewSlideInFromBottom(toTop: cell)
                           }, completion: { (done) in
                            cell.isAnimated = true
                           })
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let memory = self.memories[safe: indexPath.item] else { return }

        if isKeyboardShow {
            searchController.searchBar.resignFirstResponder()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
                self?.onSelectedMemory.send(memory)
            }
        } else {
            self.onSelectedMemory.send(memory)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
    
        if scrollView.contentOffset.y > Utilities.getWindowBound().height {
            if !isToTopButtonShow {
                isToTopButtonShow = true
            
                UIView.animate(withDuration: 0.3,
                               animations: { [weak self] in
                                self?.toTopButton.alpha = 1.0
                })
            }
        } else {
            if isToTopButtonShow {
                isToTopButtonShow = false
                
                UIView.animate(withDuration: 0.3,
                               animations: { [weak self] in
                                self?.toTopButton.alpha = 0.0
                })
            }
        }
    }
}

// MARK: - SearchBar
extension T03MemoryListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        onSearchStringChange.send(searchController.searchBar.text ?? "")
    }
        
    private func setupSearchBarController() {
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = LocalizedString.t03SearchBarPlaceholder
        searchController.obscuresBackgroundDuringPresentation = false

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.sizeToFit()
    }
}

extension T03MemoryListViewController: AdsPresented {
    func bannerViewDidShow(bannerView: UIView, height: CGFloat) {}
    
    func removeAdsIfNeeded(bannerView: UIView) {
        bannerHeightConstraint.constant = 0
    }
}
