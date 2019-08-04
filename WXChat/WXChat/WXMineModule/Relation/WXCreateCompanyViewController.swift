//
//  WXCreateCompanyViewController.swift
//  WXChat
//
//  Created by WX on 2019/7/8.
//  Copyright © 2019 WDX. All rights reserved.
//

import UIKit

class WXCreateCompanyViewController: UITableViewController {
    @IBOutlet weak var companyIconView: UIImageView!
    
    @IBOutlet weak var myTextView: YYTextView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var numberTF: UITextField!
    @IBOutlet weak var induTF: UITextField!
    @IBOutlet weak var locationTF: UITextField!
    
    
    lazy var pickerView: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.allowsEditing = true;
        picker.delegate = self
        return picker
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "创建公司"
        myTextView.placeholderText = "请输入公司简介"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let bottomView = Bundle.main.loadNibNamed("WXBottomChooseView", owner: nil, options: nil)?.first as! WXBottomChooseView
            bottomView.chooseClosure = {[weak self] (tag) in
                print(tag)
                if tag == 0{
                    //查看大图
                    if (self?.companyIconView.image == nil){
                        MBProgressHUD.showText("您还未设置图片")
                        return
                    }
                    //大图模式
                }else if tag == 1{
                    //相机
                    self?.openCamera()
                }else{
                    //相册
                    self?.openAlbum()
                }
            }
            bottomView.setShowData(array: ["查看logo大图","拍照","从相册选择"])
            view.window?.addSubview(bottomView)
            bottomView.snp.makeConstraints { (make) in
                make.left.top.right.bottom.equalToSuperview()
            }
        }
    }
    @IBAction func createCompanyAction(_ sender: UIButton) {
        
        MineViewModel.createCompany(companyname: nameTF.text ?? "", logofiles: companyIconView.image!, companysynopsis: myTextView.text, companyindustry: induTF.text ?? "", companyregion: locationTF.text ?? "", success: { (model) in
            print("1")
        }) { (error) in
            
        }
    }
    
}
extension WXCreateCompanyViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
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
//大图预览
extension WXCreateCompanyViewController {
    func showBigImage() {
        let scrollView = UIScrollView.init()
        scrollView.frame = UIScreen.main.bounds
        scrollView.backgroundColor = UIColor.black
    }
}
