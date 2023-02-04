import UIKit

class EffectsViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var viLoading: UIView!
    @IBOutlet var ivPhoto: UIImageView!
    
    var image: UIImage?
    
    lazy var filterManager: FilterManager = {
        let filterManager = FilterManager(image: image!)
        return filterManager
    }()
    
    let filterImagesNames = [
        "comic", "sepia", "halftone", "crystallize", "vignette", "noir"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        ivPhoto.image = image
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? FinalViewController else { return }
        vc.image = ivPhoto.image
    }
    
    func showLoading(_ show: Bool) {
        viLoading.isHidden = !show
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension EffectsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let type = FilterType(rawValue: indexPath.row) {
            showLoading(true)
            DispatchQueue.global(qos: .userInitiated).async {
                let filteredImage = self.filterManager.applyFilter(type: type)
                
                DispatchQueue.main.async {
                    self.ivPhoto.image = filteredImage
                    self.showLoading(false)
                }
            }
        }
    }
}

extension EffectsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterManager.filterNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? EffectsCollectionViewCell
        cell?.ivEffect.image = UIImage(named: filterImagesNames[indexPath.row])
        return cell ?? UICollectionViewCell()
    }
}
