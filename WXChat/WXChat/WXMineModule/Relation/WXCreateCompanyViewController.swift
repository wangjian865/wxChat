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
    
    ///支持图片放大的属性
    var scrollView: UIScrollView?
    var lastImageView: UIImageView?
    var originalFrame: CGRect!
    var isDoubleTap: ObjCBool!
    
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
                    self?.showZoomImageView()
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
            MBProgressHUD.showSuccess("创建成功")
            self.navigationController?.popViewController(animated: true)
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
    func showZoomImageView() {
        let bgView = UIScrollView.init(frame: UIScreen.main.bounds)
        bgView.backgroundColor = UIColor.black
        let tapBg = UITapGestureRecognizer.init(target: self, action: #selector(tapBgView(tapBgRecognizer:)))
        bgView.addGestureRecognizer(tapBg)
        let picView = companyIconView!
        let imageView = UIImageView.init()
        imageView.image = picView.image;
        imageView.frame = bgView.convert(picView.frame, from: self.view)
        bgView.addSubview(imageView)
        UIApplication.shared.keyWindow?.addSubview(bgView)
        self.lastImageView = imageView
        self.originalFrame = imageView.frame
        self.scrollView = bgView
        self.scrollView?.maximumZoomScale = 1.5
        self.scrollView?.delegate = self
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            options: .beginFromCurrentState,
            animations: {
                var frame = imageView.frame
                frame.size.width = bgView.frame.size.width
                frame.size.height = frame.size.width * ((imageView.image?.size.height)! / (imageView.image?.size.width)!)
                frame.origin.x = 0
                frame.origin.y = (bgView.frame.size.height - frame.size.height) * 0.5
                imageView.frame = frame
        }, completion: nil
        )
        
    }
    
    @objc func tapBgView(tapBgRecognizer:UITapGestureRecognizer)
    {
        self.scrollView?.contentOffset = CGPoint.zero
        UIView.animate(withDuration: 0.5, animations: {
            self.lastImageView?.frame = self.originalFrame
            tapBgRecognizer.view?.backgroundColor = UIColor.clear
        }) { (finished:Bool) in
            tapBgRecognizer.view?.removeFromSuperview()
            self.scrollView = nil
            self.lastImageView = nil
        }
    }
    
    //正确代理回调方法
    override func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.lastImageView
    }
}
