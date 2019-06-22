//
//  SecondViewController.swift
//  AlertMemoApp2
//
//  Created by Yuta Matsuo on 2018/12/21.
//  Copyright © 2018 ym9mmApp. All rights reserved.
//

import UIKit
import UserNotifications

class SecondViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    
    //AppDeligateクラスの変数
    var delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    
    //タイマーの変数
    var timer:Timer?
    var timers:[Timer?] = []
    
    //カウント(経過時間)の変数
    var count =  0
    var counts:[Int] = []
    
    //配列保持
    var contentsData:[String] = []
    var timesData:[Int] = []
    
    //UserDefaultsのインスタンス
    var userDefaults = UserDefaults.standard

    @IBOutlet weak var tableView: UITableView!
    
    var content:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.insetsLayoutMarginsFromSafeArea = true
       
        
        //TableViewのdataSourceを設定
        tableView.dataSource = self
        tableView.delegate = self
        
        //tableViewの背景を透明に
        let tblBackColor: UIColor = UIColor.clear
        tableView.backgroundColor = tblBackColor
        
       /* //tableViewに背景を設定
         
        let image = UIImage(named: "wallPaper_black_brilliance_goldfish.png")
        let imageView = UIImageView(frame: CGRect(x:0, y:0, width:self.tableView.frame.width, height:self.tableView.frame.height))
        imageView.image = image
        self.tableView.backgroundView = imageView
      */
       
    }
 
    //tableのレイアウト
   /* override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let screenRect = UIScreen.main.bounds
        tableView.frame = CGRect(x: 0, y: 0, width: screenRect.width, height: screenRect.height)
    }
   */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Cellの総数を返すdataSourceメソッド
    func tableView(_ tableView:UITableView,numberOfRowsInSection section:Int) -> Int{
        return delegate.contentsData.count
    }
    
    //Cellに値を設定するdataSourceメソッド
    func tableView(_ tableView:UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell{
        //Cellオブジェクトを取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell",for:indexPath)
        
        //Tag番号でセルに含まれるラベルを取得する。
        let label1 = cell.viewWithTag(1) as! UILabel
        let label2 = cell.viewWithTag(2) as! UILabel
        
        //配列の中身の番号
        let arrayPath = (delegate.contentsData.count - 1) - indexPath.row
        
        //内容設定
        label1.text = delegate.contentsData[arrayPath]
        //登録日設定
        guard let formatString = DateFormatter.dateFormat(fromTemplate: "yyyyMdHm", options: 0, locale: Locale(identifier: "ja_JP")) else { fatalError() }
        print(formatString)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatString
        label2.text = dateFormatter.string(from: delegate.dates[arrayPath]) + " → " + "\(delegate.timesLabel[arrayPath])"
        
      
        //設定済みのCellオブジェクトを画面に反映
        return cell

    }
    
    //画面が表示されるときに呼び出される
    override func viewWillAppear(_ animated: Bool) {
        //テーブルビューの更新
        self.tableView.reloadData()
    }
    
  
   //↓タイマー処理
   /*
    //同じidに対する配列を追加しないためのフラグ
    private var idFlg:Int = 0
    
    //カウントダウン開始処理（登録ボタンを押すと呼び出される）
    func startTimer(id:Int){
         print("タイマー起動")
        if(idFlg == 0){
        //配列に要素を追加
        timers.append(Timer())
        counts.append(0)
        idFlg = 1
        }
        //timerをアンラップ
        if let nowTimer = timers[id]{
            //もしタイマーが実行中だったら
            if nowTimer.isValid ==  true{
                return
            }
        }
        if(delegate.times[id] != 0){
        //タイマーをスタート
            timers[id] = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerInturrupt(_:)), userInfo: id, repeats: true)
         idFlg = 0
            
            //永続化保存された値の取得
           
            //取得した配列に追加
            contentsData.append(delegate.memo)
            timesData.append(delegate.time)
            //userDefaultsに保持
            userDefaults.set(contentsData,forKey:"contentsDataBefore")
            userDefaults.set(timesData, forKey: "timesDataBefore")
            
        }
        
    }
    
    //タイマーによって定期的に呼び出される処理
    @objc func timerInturrupt(_ timer:Timer){
        //送られた値を保持
        let id:Int = timer.userInfo as! Int
        //countsに＋１
        counts[id] += 1
        //残り時間が０以下の時の処理
        if judgeTime(id: id) <= 0{
            //0に戻す
            counts[id] = 0
            //タイマー停止
            timer.invalidate()
            
            print("タイマー終了")
            //
            
        }
        
    }
    
    //時間経過の判定
    func judgeTime(id : Int) -> Int{
        //残り時間を生成
        let remainCount = delegate.times[id] - counts[id]
        
        return remainCount
    }
    
    */
 // タップされたボタンのtableviewの選択行を取得
    @IBAction func tapDeleteButton(_ sender: Any) {
        
        let btn = sender as! UIButton
        let cell = btn.superview?.superview as! UITableViewCell
        let row = (delegate.contentsData.count - 1) - (tableView.indexPath(for: cell)?.row)!
      
        //↓アラート処理
        // ① UIAlertControllerクラスのインスタンスを生成
        // タイトル, メッセージ, Alertのスタイルを指定する
        // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
        let alert: UIAlertController = UIAlertController(title: "削除確認", message: "削除してもよろしいですか？", preferredStyle:  UIAlertController.Style.alert)
        
        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            
            //アラートを削除
            self.deleteAlert(row: row)
    
            //配列から指定の要素を削除
            self.delegate.contentsData.remove(at: row)
            self.delegate.timesData.remove(at: row)
            self.delegate.iDs.remove(at: row)
            self.delegate.dates.remove(at: row)
            self.delegate.timesLabel.remove(at: row)
            
            //デリゲートの変数の中身をuserdefaultに更新
            self.delegate.appendContents()
            //テーブルビューの更新
            self.tableView.reloadData()
            
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
       
        })
        
        // ③ UIAlertControllerにActionを追加
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        // ④ Alertを表示
        present(alert, animated: true, completion: nil)

    }
    
    //指定のアラートを削除
    func deleteAlert(row:Int){
        // 通知の削除
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [delegate.iDs[row]])
    }
}

