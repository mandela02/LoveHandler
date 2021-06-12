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
    
    var viewModel: T03MemoryListViewModel?
    
    private var cancellables = Set<AnyCancellable>()
    
    private var onViewWillAppearSignal = PassthroughSubject<Void, Never>()
    private var onSelectedMemory = PassthroughSubject<CDMemory, Never>()

    private var memories: [CDMemory] = []
    
    deinit {
        onViewWillAppearSignal.send(completion: .finished)
        onSelectedMemory.send(completion: .finished)
        cancellables.forEach { $0.cancel() }
    }

    override func setupView() {
        super.setupView()
        isBackButtonVisible = true
        isTitleVisible = true
        setupCollectionView()
        setupTransitionAnimation()
    }
    
    override func refreshView() {
        super.refreshView()
        onViewWillAppearSignal.send(Void());
    }
    
    override func setupLocalizedString() {
        super.setupLocalizedString()
        navigationTitle = "Memory"
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = viewModel else { return }
        
        let input = T03MemoryListViewModel.Input(viewWillAppear: onViewWillAppearSignal.eraseToAnyPublisher(),
                                                 dismissTrigger: closeButton.tapPublisher,
                                                 addButtonTrigger: addButton.tapPublisher,
                                                 selectedMemoryTrigger: onSelectedMemory.eraseToAnyPublisher())
        
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
}

extension T03MemoryListViewController: CHTCollectionViewDelegateWaterfallLayout  {
    
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
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let memory = memories[safe: indexPath.item] else { return }
        onSelectedMemory.send(memory)
    }
}
