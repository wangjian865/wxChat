//
//  WXEditCompanyViewController.swift
//  WXChat
//
//  Created by WX on 2019/7/6.
//  Copyright © 2019 WDX. All rights reserved.
//

import UIKit


class WXEditCompanyViewController: UITableViewController {
    @IBOutlet weak var companyIconView: UIImageView!
    
    lazy var pickerView: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.allowsEditing = true;
        picker.delegate = self
        return picker
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "编辑公司信息"
        
        let rightBtn = UIButton.init(type: .custom)
        rightBtn.setTitle("保存", for: .normal)
        rightBtn.backgroundColor = UIColor.clear
        rightBtn.layer.cornerRadius = 3
        rightBtn.layer.borderColor = UIColor.white.cgColor
        rightBtn.layer.borderWidth = 1
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        rightBtn.frame.size = CGSize.init(width: 52, height: 28)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        switch row {
        case 0:
            //设置logo
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
            bottomView.setShowData(array: ["查看logo大图","拍照","从相册选择"])
            self.view.window?.addSubview(bottomView)
            break
        case 1:
        //公司成员管理
            
            break
        case 2:
        //管理员设置
        
            let vc = WXAttendantViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 3:
        //超级管理员设置
            
            break
        default:
            break
        }
    }
}
extension WXEditCompanyViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
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
        companyIconView.image = image
        print("2")
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
