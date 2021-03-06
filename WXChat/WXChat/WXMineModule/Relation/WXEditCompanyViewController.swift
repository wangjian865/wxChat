//
//  WXEditCompanyViewController.swift
//  WXChat
//
//  Created by WX on 2019/7/6.
//  Copyright © 2019 WDX. All rights reserved.
//

import UIKit


class WXEditCompanyViewController: UITableViewController ,UUActionSheetDelegate{
    @IBOutlet weak var companyIconView: UIImageView!
    var myModel :CompanyModel?
    //更改管理员时存在
    var newAdminId: String = ""
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var numberTF: UITextField!
    @IBOutlet weak var descTF: YYTextView!
    @IBOutlet weak var indusTF: UITextField!
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var outBtn: UIButton!
    
    //公司权限标识
    var companyPositionStr = "0"
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
        title = "编辑公司信息"
        
        let rightBtn = UIButton.init(type: .custom)
        rightBtn.setTitle("保存", for: .normal)
        rightBtn.backgroundColor = UIColor.clear
        rightBtn.layer.cornerRadius = 3
        rightBtn.layer.borderColor = UIColor.white.cgColor
        rightBtn.layer.borderWidth = 1
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        rightBtn.frame.size = CGSize.init(width: 52, height: 28)
        rightBtn.addTarget(self, action: #selector(editCompany), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        //控件赋值
        companyIconView.sd_setImage(with: URL.init(string: myModel?.companylogo ?? ""), placeholderImage: UIImage.init(named: "normal_icon"))
        nameTF.text = myModel?.companyname
        numberTF.text = myModel?.companyid
        descTF.text = myModel?.companysynopsis
        indusTF.text = myModel?.companyindustry
        locationTF.text = myModel?.companyregion
        getUserPositionOfCompany()
    }
    ///判断用户的公司权利
    func getUserPositionOfCompany() {
        CompanyViewModel.getMyPosition(ofCompany: myModel?.companyid ?? "" , successBlock: { (data) in
            self.companyPositionStr = data
            //底部按钮的判断
            if data == "2"{
                self.deleteBtn.isHidden = false
                self.outBtn.isHidden = true
            }else{
                self.deleteBtn.isHidden = true
                self.outBtn.isHidden = false
            }
            self.nameTF.isUserInteractionEnabled = data != "0"
            self.descTF.isUserInteractionEnabled = data != "0"
            self.indusTF.isUserInteractionEnabled = data != "0"
            self.locationTF.isUserInteractionEnabled = data != "0"
            self.tableView.reloadData()
        }) { (error) in
            
        }
    }
    @objc func editCompany(){
        
        MineViewModel.updateCompanyInfo(companyid: myModel?.companyid ?? "", companyname: nameTF.text ?? "", logofiles: companyIconView.image!, companysynopsis: descTF.text, companyindustry: indusTF.text ?? "", companyregion: locationTF.text ?? "",companysystem: newAdminId, success: { (model) in
            let alert = UIAlertController.init(title: "修改成功", message: "该公司信息已修改", preferredStyle: .alert)
            let action = UIAlertAction.init(title: "确认", style: .default, handler: { (action) in
                
            })
            alert.addAction(action)
            self.present(alert, animated: true, completion: {
                
            })
//            print(model)
        }) { (error) in
            
        }
    }
    func setContentData(model: CompanyModel){
        myModel = model
    }
    
    //action
    @IBAction func deleteCompanyAction(_ sender: Any) {
        let sheet = Bundle.main.loadNibNamed("WXBottomChooseView", owner: nil, options: nil)?.last as! WXTwoBottomChooseView
        sheet.firstBtn.setTitle("删除公司后,该公司下的所有成员将一并移除", for: .normal)
        sheet.secondBtn.setTitle("删除公司", for: .normal)
        sheet.chooseClosure = { [weak self] (index) in
            if index == 102{
                //101作为title  无视点击事件
                self?.deleComRequest()
            }
        }
        view.window?.addSubview(sheet)
        sheet.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(view.window!)
        }
    }
    func deleComRequest() {
        MineViewModel.deleCompany(companyid: myModel?.companyid ?? "", success: { (success) in
            self.navigationController?.popToRootViewController(animated: true)
        }) { (error) in
            print("删除公司出现错误")
        }
    }
    @IBAction func removeFromCompanyAction(_ sender: Any) {
        MineViewModel.leaveCompany(companyid: myModel?.companyid ?? "", success: { (success) in
            self.navigationController?.popToRootViewController(animated: true)
        }) { (error) in
            print("退出公司出现错误")
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row
        switch row {
        case 0:
            return 150
            
        case 1:
            if companyPositionStr == "0"{
                return 0
            }
            return 44
            
        case 2:
            if companyPositionStr == "0" || companyPositionStr == "1"{
                return 0
            }
            return 44
            
        case 3:
            if companyPositionStr == "0" || companyPositionStr == "1"{
                return 0
            }
            return 44
            
        case 4:
            return 333
            
        default:
            return 44
            
        }
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
                    self?.showZoomImageView()
                }else if tag == 1{
                    //相机
                    if self?.companyPositionStr == "0"{
                        MBProgressHUD.showError("您暂无权限更改公司图标")
                        return
                    }
                    self?.openCamera()
                }else{
                    //相册
                    if self?.companyPositionStr == "0"{
                        MBProgressHUD.showError("您暂无权限更改公司图标")
                        return
                    }
                    self?.openAlbum()
                }
            }
            bottomView.setShowData(array: ["查看logo大图","拍照","从相册选择"])
            self.view.window?.addSubview(bottomView)
            bottomView.snp.makeConstraints { (make) in
                make.left.top.right.bottom.equalToSuperview()
            }
            break
        case 1:
        //公司成员管理
            let vc = WXAttendantViewController()
            vc.companyID = myModel?.companyid ?? ""
            vc.title = "公司成员管理"
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 2:
        //管理员设置
        
            let vc = WXAttendantViewController()
            vc.companyID = myModel?.companyid ?? ""
            vc.title = "管理员设置"
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 3:
        //超级管理员设置
            
            let vc = WXUsersListViewController.init()
            vc.cardCallBack = {[weak self] ID in
                self?.newAdminId = ID
            }
            vc.isEditing = true
            vc.isInfoCard = true
            let nav = WXPresentNavigationController.init(rootViewController: vc)
            present(nav, animated: true, completion: nil)
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
            MBProgressHUD.showError("暂无相机权限")
        }
    }
    
    func openAlbum() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            pickerView.sourceType = .photoLibrary
            self.present(pickerView, animated: true, completion: nil)
        } else {
            MBProgressHUD.showError("暂无相册权限")
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
///放大图片
extension WXEditCompanyViewController {
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
