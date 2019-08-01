//
//  WXEditPersonInfoViewController.swift
//  WXChat
//
//  Created by WX on 2019/7/8.
//  Copyright © 2019 WDX. All rights reserved.
//

import UIKit

class WXEditPersonInfoViewController: UITableViewController {
    
    @IBOutlet weak var userIconView: UIImageView!
    @IBOutlet weak var sexyLabel: UILabel!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var workLabel: UILabel!
    
    @IBOutlet weak var companyLabel: UILabel!
    
    var userInfoModel: UserInfoModel?
    lazy var pickerView: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.allowsEditing = true;
        picker.delegate = self
        return picker
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userIconView.sd_setImage(with: URL.init(string: userInfoModel?.tgusetimg ?? ""), placeholderImage: UIImage.init(named: "normal_icon"))
        userName.text = userInfoModel?.tgusetname
        sexyLabel.text = userInfoModel?.tgusetsex
        workLabel.text = userInfoModel?.tgusetposition
        companyLabel.text = userInfoModel?.tgusetcompany
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let bottomView = Bundle.main.loadNibNamed("WXBottomChooseView", owner: nil, options: nil)?.first as! WXBottomChooseView
            bottomView.chooseClosure = {[weak self] (tag) in
                print(tag)
                if tag == 0{
                    //查看大图
                }else if tag == 1{
                    //相机
                    self?.openCamera()
                }else{
                    //相册
                    self?.openAlbum()
                }
            }
            view.window?.addSubview(bottomView)
            bottomView.snp.makeConstraints { (make) in
                make.top.left.right.bottom.equalToSuperview()
            }
        }else if indexPath.row == 3{
            let sexyVC = WXSexyChooseViewController.init()
            sexyVC.title = "性别"
            navigationController?.pushViewController(sexyVC, animated: true)
        }else if indexPath.row == 2{
            let settingVC = WXSettingViewController()
            settingVC.textField.text = userName.text
            settingVC.callBackClosure = { [weak self] (string) in
                self?.userName.text = string
            }
            settingVC.title = "姓名"
            navigationController?.pushViewController(settingVC, animated: true)
        }else if indexPath.row == 4{
            let settingVC = WXSettingViewController()

            settingVC.textField.text = workLabel.text
            settingVC.callBackClosure = { [weak self] (string) in
                self?.workLabel.text = string
            }
            settingVC.title = "职位"
            navigationController?.pushViewController(settingVC, animated: true)
        }else if indexPath.row == 5{
            let settingVC = WXSettingViewController()
            settingVC.textField.text = companyLabel.text
            settingVC.callBackClosure = { [weak self] (string) in
                self?.companyLabel.text = string
            }
            settingVC.title = "公司"
            navigationController?.pushViewController(settingVC, animated: true)
        }else if indexPath.row == 6{
            //二维码
            let qrcodeVC = WXMyQRCodeViewController()
            qrcodeVC.userInfoModel = userInfoModel
            navigationController?.pushViewController(qrcodeVC, animated: true)
        }else if indexPath.row == 7{
            //企业圈
            
        }else if indexPath.row == 8{
            //隐私
            let vc = UIStoryboard.init(name: "RelationViewController", bundle: nil).instantiateViewController(withIdentifier: "privateVC")
            navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 9{
            //设置
            let vc = UIStoryboard.init(name: "RelationViewController", bundle: nil).instantiateViewController(withIdentifier: "settingTBVC")
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

extension WXEditPersonInfoViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func openCamera() {
        if UIImagePickerController.isCameraDeviceAvailable(.rear) {
            pickerView.sourceType = .camera
            self.present(pickerView, animated: true, completion: nil)
        } else {
//            HUDTool.showText(text: "暂无相机权限")
        }
    }
    
    func openAlbum() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            pickerView.sourceType = .photoLibrary
            self.present(pickerView, animated: true, completion: nil)
        } else {
//            HUDTool.showText(text: "暂无相册权限")
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[.editedImage] as! UIImage
        userIconView.image = image
        //WDX http
        changeUserIcon()
    }
    func changeUserIcon() {
        let urlString = "http://106.52.2.54:8080/SMIMQ/" + "manKeepToken/updateTgInfoImg"
        let account = UserDefaults.standard.string(forKey: "account")
        let params:[String:String] = ["tgusetaccount":account ?? ""]
        WXNetWorkTool.uploadFile(withUrl: urlString, imageName: ["img"], image: [userIconView.image!], parameters: params, progressBlock: { (progress) in
            print(progress)
        }, successBlock: { (success) in
            print(success)
        }) { (error) in
            print(error)
        }
    }
    
    //裁剪图片
    func imageWithImageSimple(image:UIImage,scaledToSize newSize:CGSize)->UIImage{
        var width:CGFloat!
        var height:CGFloat!
        if image.size.width/newSize.width >= image.size.height / newSize.height{
            width = newSize.width
            height = image.size.height / (image.size.width/newSize.width)
        }else{
            height = newSize.height
            width = image.size.width / (image.size.height/newSize.height)
        }
        let sizeImageSmall = CGSize(width:width,height:height)
        //print(sizeImageSmall)
        UIGraphicsBeginImageContext(sizeImageSmall);
        image.draw(in: CGRect(x:0,y:0,width:sizeImageSmall.width,height:sizeImageSmall.height))
        let newImage:UIImage=UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return newImage;
    }
}
