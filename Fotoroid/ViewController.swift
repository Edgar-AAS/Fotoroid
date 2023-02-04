import UIKit

enum ActionType: String {
    case camera = "Câmera"
    case photoLibrary = "Biblioteca de fotos"
    case savedPhotosAlbum = "Albúms de fotos"
    case cancel = "Cancelar"
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func selectSource(_ sender: UIButton) {
        DisplayAlertMessage(title: "Selecionar foto", message: "De onde você quer escolher a sua foto?")
    }
    
    func DisplayAlertMessage(title: String, message: String, preferredStyle: UIAlertController.Style = .actionSheet) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(makeAlertAction(actionType: .camera) { _ in self.selectPicture(sourceType: .camera) })
        }
        
        alert.addAction(makeAlertAction(actionType: .photoLibrary) { _ in self.selectPicture(sourceType: .photoLibrary) })
        alert.addAction(makeAlertAction(actionType: .savedPhotosAlbum) { _ in self.selectPicture(sourceType: .savedPhotosAlbum) })
        alert.addAction(makeAlertAction(actionType: .cancel))
        present(alert, animated: true)
    }
    
    func makeAlertAction(actionType: ActionType, style: UIAlertAction.Style = .default, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: actionType.rawValue, style: style, handler: handler)
    }
    
    func selectPicture(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! EffectsViewController
        vc.image = sender as? UIImage
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            
            let originalWidht = image.size.width
            let aspectRatio = originalWidht / image.size.height
            var smallSize: CGSize
            
            if aspectRatio > 1 { //landscape
                smallSize = CGSize(width: 1000, height: 1000/aspectRatio)
            } else {
                smallSize = CGSize(width: 1000*aspectRatio, height: 1000)
            }
            
            UIGraphicsBeginImageContext(smallSize)
            image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
            let smallImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            dismiss(animated: true) {
                self.performSegue(withIdentifier: "effectSegue", sender: smallImage)
            }
        }
    }
}
