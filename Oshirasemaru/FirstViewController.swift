//
//  FirstViewController.swift
//  AlertMemoApp2
//
//  Created by Yuta Matsuo on 2018/12/21.
//  Copyright © 2018 ym9mmApp. All rights reserved.
//

import UIKit
import UserNotifications

class FirstViewController: UIViewController,UITextFieldDelegate  ,UIPickerViewDelegate,UIPickerViewDataSource{

    //AppDeligateクラスの変数
    var delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //userDefaults
    var userDefaults = UserDefaults.standard
    
    
    @IBOutlet weak var timePicker: UIPickerView!
    
    @IBOutlet weak var contentText: UITextField!
    
    //リセットボタンデバッグ用
   // @IBAction func resetButton(_ sender: Any) {
    //    delegate.resetDatas()
    //}
    
    //「登録」を押した時
    @IBAction func registerButton(_ sender: Any) {
        
        var nilFlgC:Int = 0
        var nilFlgT:Int = 0
        var errorMessgae:String = ""
        
        //条件分岐、入力内容が正常な場合
        if contentText.text != ""{
            if selectedTime != nil{
                
                //入力内容を保持
                let ct = contentText.text!
                let st = selectedTime!
                let sl = selectedLabel!
                //id生成
                let id:String = UUID.init().uuidString
                //押した時の日時を取得
                let now = Date()
                
                //nilでなければAppDelegateの変数に入力内容を代入
                delegate.contentsData.append(ct)
                delegate.timesData.append(st)
                delegate.iDs.append(id)
                delegate.dates.append(now)
                delegate.timesLabel.append(sl)
                //デリゲートの変数の中身をuserdefaultに更新
                delegate.appendContents()
                //通知をセット
                alertSet(ct:ct, st: st,id: id)
                
                /////////ダイアログ作成↓・////////
                let alertController = UIAlertController(title:"登録完了",message:"登録が完了しました",preferredStyle:.alert)
                //ダイアログに表示させるOKボタンを作成
                let defaultAction = UIAlertAction(title:"OK",style:.default,handler:nil)
                //アクションを追加
                alertController.addAction(defaultAction)
                //ダイアログの表示
                present(alertController,animated:true,completion:nil)
                //タイマースタート
                //secondViewController.startTimer(id: id)
                
                //内容記入欄リセット
                contentText.text = ""
              
            }
            else{
                nilFlgT = 1
            }
        }
        else{
            nilFlgC = 1
        }
        //入力エラーがある場合
        if(nilFlgC == 1 || nilFlgT == 1){
            if(nilFlgC == 1){
                errorMessgae = "内容"
            }
            //ダイアログ作成
            let alertController = UIAlertController(title:"登録エラー",message:"\(errorMessgae)を入力してください",preferredStyle:.alert)
            //ダイアログに表示させるOKボタンを作成
            let defaultAction = UIAlertAction(title:"OK",style:.default,handler:nil)
            //アクションを追加
            alertController.addAction(defaultAction)
            //ダイアログの表示
            present(alertController,animated:true,completion:nil)
            
           
        }
       
    }
    
    //内容を保持する変数
    var content:String?
    //選択された時間を保持する
    var selectedTime:Int?
    //選択された時間のラベルを保持
    var selectedLabel:String?
    
    //ピッカーのラベル
    private let data: NSArray = [
    "10秒後(デバッグ用)","15分後","30分後","1時間後","3時間後","6時間後","12時間後","24時間後","3日後","１週間後"
    ]
    
    //時間の格納(単位：分）
    private let dataTimes:NSArray = [
    10,15*60,30*60,60*60,180*60,360*60,720*60,1440*60,4320*60,10080*60
    ]
    
    
    //メインメソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //textFieldの設定
        self.contentText.delegate = self
        
       //pickerの設定
        timePicker.delegate = self
        timePicker.dataSource = self
        
        //フィールドの初期値
        self.contentText.placeholder = "メモ内容を入力"
        
        //時間の初期値を設定
        selectedTime = dataTimes[0] as? Int
        selectedLabel = data[0] as? String
        
    }
    
    //決定を押したらキーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    //keyboard以外の画面を押すと、keyboardを閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.contentText.isFirstResponder) {
            self.contentText.resignFirstResponder()
        }
    }
    
    //UITextFieldの編集後に処理を行う
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    //pickerViewの個数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //表示する行数、配列の個数を返している
    func pickerView(_ pickerView: UIPickerView,numberOfRowsInComponent component: Int) -> Int{
        return data.count
    }
    
    //表示する値
    func pickerView(_ pickerView: UIPickerView,titleForRow row:Int,forComponent component: Int) -> String?{
        return data[row] as? String
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        
    }
    
    
    // pickerに表示するUIViewを返す
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let pickerLabel = UILabel()
        let titleData = data[row] as! String
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.font:UIFont(name: "HiraKakuProN-W3", size: 20.0)!,NSAttributedString.Key.foregroundColor:UIColor.white])
        
        // fontサイズ、テキスト
        pickerLabel.attributedText = myTitle
        // 中央寄せ ※これを指定しないとセンターにならない
        pickerLabel.textAlignment = NSTextAlignment.center
        //pickerLabel.frame = CGRectMake(0, 0, 200, 30)
        // ラベルを角丸に
        pickerLabel.layer.masksToBounds = true
        pickerLabel.layer.cornerRadius = 5.0
        
       /* // 既存ラベル、選択状態のラベルが存在している
        if let lb = pickerView.view(forRow: row, forComponent: component) as? UILabel,
            let selected = self.preSelectedLb {
            // 設定
            self.preSelectedLb = lb
            self.preSelectedLb.backgroundColor = UIColor.orangeColor()
            self.preSelectedLb.textColor = UIColor.whiteColor()
        }
        */
        return pickerLabel
    }
    
    //ピッカー選択時に呼ばれる
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 選択時の処理
        selectedTime = dataTimes[row] as? Int
        selectedLabel = data[row] as? String
    }
    
    //通知の発行：タイマーを指定して発行
    //※アプリを落としても残る
    func alertSet(ct:String,st:Int,id:String){
        
        let content = UNMutableNotificationContent()
        content.title = "忘れていませんでしたか？"
        content.subtitle = "メモ内容↓"
        content.body = ct
        content.sound = UNNotificationSound.default
        
        //trigger
        let trigger:UNNotificationTrigger
        trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(st), repeats: false)
        
        //request includes content & trigger
        //*identifierは一意の値でないと上書きされてしまう
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        //schedule notification by adding request to notification center
        let center = UNUserNotificationCenter.current()
        //通知をセット
        center.add(request){(error) in
            if let error = error{
                print(error.localizedDescription)
            }
        }
        
    }
    
    

}



