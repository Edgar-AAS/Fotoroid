import UIKit
import Photos

class FinalViewController: UIViewController {
    @IBOutlet var ivPhoto: UIImageView!
    
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ivPhoto.image = image
        ivPhoto.layer.borderWidth = 10
        ivPhoto.layer.borderColor = UIColor.white.cgColor
    }
    
    func saveToAlbum() {
        PHPhotoLibrary.shared().performChanges {
            let creationRequest = PHAssetChangeRequest.creationRequestForAsset(from: self.image)
            let addAssetRequest = PHAssetCollectionChangeRequest()
            addAssetRequest.addAssets([creationRequest.placeholderForCreatedAsset ?? []] as NSArray)
        } completionHandler: { [weak self] (success, error) in
            if !success {
                print(error!.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Imagem salva", message: "Sua imagem foi save no album de fotos", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel)
                    alert.addAction(okAction)
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    @IBAction func save(_ sender: UIButton) {
        PHPhotoLibrary.requestAuthorization { [weak self] (status) in
            switch status {
            case .authorized:
                self?.saveToAlbum()
            default:
                let alert = UIAlertController(title: "ERRO", message: "Voce precisa autorizar o acesso ao album para poder salvar suas fotos", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel)
                alert.addAction(okAction)
                self?.present(alert, animated: true)
            }
        }
    }
    
    @IBAction func restart(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
}
