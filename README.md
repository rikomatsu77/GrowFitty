# GrowFitty

　ー子供服サイズ予測で、成長をもっと楽しく！ー

## ■サービス概要

幼児の成長段階に応じて服のサイズを提案するサービスです。

幼児の生年月日・体重・身長・性別等を管理し、先季節でのサイズを確認できます。

コーディネートの投稿・コメント・いいね・気に入ったコーディネートをブックマークできます。

## ■ このサービスへの思い・作りたい理由

幼児服を購入するときに、以下のシーンで課題を感じていました。

- **季節の終わりにセールで安くなっている服を購入するとき**

- １年後の同じ季節で着るために買っておきたいが、どのサイズを購入すれば良いのかが瞬時に分からない。

- **友人・知人の子どもに服をプレゼントするとき**

- 出産祝いなどで少し先の季節で着れるような服を選びたいが、生年月日と性別以外の情報がなく購入すべきサイズに悩む。

- **服のコーディネートがいつも同じようなものになってしまう**

家族や友人・知人との会話でも服選びに関する不便さが挙がり、解決したいと思ったのがきっかけです。

上記の課題を解決するために、幼児服のサイズを簡単に予測できて買い物の効率を上げられるサービスを企画しました。

また他の人のコーディネート投稿を服選びの参考にし、新たな組み合わせパターンなどを知ることで、買い物体験をより楽しく充実させることを付加価値として考えています。

## ■ ユーザー層について

- 小さい子どもがいるご家庭
- ギフト目的で幼児服を購入する人

いずれも理由は、一般的に７歳未満の「幼児」と言われる期間はサイズ変化が頻繁にあるため、子育て中の方や出産祝い等で服をプレゼントする人が服選びで不便と感じる部分を解消したいからです。

## ■サービスの利用イメージ

- 外出先のお店などで服のサイズ確認の手間を省き、効率よく買い物ができる。
  - ユーザー登録により子どものプロフィール情報を保持・自動更新できるので、情報入力の手間を省くことができる。
- コーディネートの投稿をチェックすることでイメージの幅を広げ、買い物体験を充実させることができる。

## ■ ユーザーの獲得について

X（旧Twitter）、Instagram等のSNSでの宣伝

## ■ サービスの差別化ポイント・推しポイント

幼児服のサイズ一覧表やサイズ予測のサービスは複数存在します。

例）

- 子のプロフィールを入力するとその子に応じたサイズを提案してくれるサービス

  https://cl.unisize.makip.co.jp/lp/kids.html

- ＡＩのプロンプトを作成してくれるサービス

  https://chapro.jp/prompt/6323

しかしどれも基本的にその日時点での子の情報を毎回ユーザーが入力しなければなりません。
その点において当アプリは、以下のようなメリットがあります。

## **【差別化ポイント】**

- 子の生年月日等の情報を一度入力すれば、成長曲線のデータ(公式データは6歳半未満まで)に基づいて自動的に算出されるためその後の入力は基本的に不要
- 半年や１年に一度の子の健診等で最新の情報を得たタイミングに新しい情報のみ入力してもらうと再計算が可能
- 服購入日時点から約１年間、季節ごとのサイズ変化を予測可能

以上の点からユーザーの負担を減らせると考えています。

## 使用予定データ

※現状は以下のデータ使用予定ですが、精度の確認中で変更となる可能性はあります。

日付を１日単位になるように加工して使用する予定です。

### **令和５年乳幼児身体発育調査**＜体重＞

https://www.e-stat.go.jp/stat-search/files?page=1&layout=datalist&toukei=00450272&tstat=000001024533&cycle=0&tclass1=000001224821&stat_infid=000040240361&tclass2val=0

### **令和５年乳幼児身体発育調査**＜身長＞

https://www.e-stat.go.jp/stat-search/files?page=1&layout=datalist&toukei=00450272&tstat=000001024533&cycle=0&tclass1=000001224821&stat_infid=000040240362&tclass2val=0

### パーセンタイルとは

> 計測値の統計的分布の上で、小さいほうから数えて何％目の値は、どれくらいかという見方をする統計的表示法である。それぞれの計測項目については、3、10、25、50、75、90及び97パーセンタイルの数値が男女別に示されているが、これらは、それぞれの計測値につき、小さいほうから数えて3、10、25、50、75、90及び97％目の数値に当たっている。
> 

> 50パーセンタイル値は中央値とも呼ばれているもので、この値より小さいものと大きいものが半数ずついることになる。また、3パーセンタイル未満のものは全体の3％、97パーセンタイルを超えるものは3％いるはずであり、両者の間には94％のものが含まれていることになる。
> 

引用：https://www.cfa.go.jp/policies/boshihoken/r5-nyuuyoujityousa

つまり、パーセンタイルはデータ全体の中でその値がどの辺りに位置するのかを理解するための指標で、分布の特徴や偏りなどを把握するのに役立つ

## サイズ予測方法

・生年月日から現在の日付で月齢を出す。（生年月日を生後０日と設定する）

・パーセンタイルは範囲指定して命名する。

・現在の月齢、身長（体重）から当てはまるパーセンタイルの範囲を決定する。

・季節をグループ分けする

- 冬（12/1～3/31）
- 春（4/1～5/31）
- 夏（6/1～9/30）
- 秋（10/1～11/30）

・現在の日付から今の季節を決定（例：3/25なら「冬」）

・現在の日付（季節）から予測対象の季節の開始日までの日数に基づいて、成長曲線のパーセンタイルを参照する。

・そのパーセンタイルに該当する予測された体重や身長から服のサイズを提案する。

## ■ 機能候補

## MVP

1.ログイン機能
2.ログアウト機能
3.リセットパスワード機能
4.サイズ予測機能
5.投稿一覧
6.投稿詳細
7.投稿作成
8.投稿編集
9.投稿削除
10.プロフィール詳細
11.プロフィール編集

## 本リリース

1.検索機能
2.ブックマーク機能
3.SNS共有機能
4.オートコンプリート機能
5.タグ機能
6.LINEプッシュ通知
7.Google認証
8.コメント作成 
9.コメント編集 
10.コメント削除

## ■ 機能の実装方針予定

- 検索機能：gem ransack
- オートコンプリート機能：Stimulus Autocomplete（Rails7 ）
- LINEプッシュ通知： LINE Messaging API、LINE Messaging API SDK for Ruby

# 使用技術（予定）

- 開発環境

　Docker

- フロントエンド

　HTML、JavaScript、Tailwind CSS

- バックエンド

　Ruby、Ruby on Rails７系

- インフラ

　・Webアプリケーションサーバ：Render.com

　・データベースサーバ：PostgreSQL

- 認証

　gem devise、Google認証

## 画面遷移図

https://www.figma.com/design/nyig3NgC0ol8JWr83RJxCV/GrowFitty?node-id=0-1&t=FM9r15Dz26505Yq3-1

## ER図

dbdiagram.io：https://dbdiagram.io/d/680d95001ca52373f57f695f

[![Image from Gyazo](https://i.gyazo.com/d711904af86e5e5add4d1501384d4524.png)](https://gyazo.com/d711904af86e5e5add4d1501384d4524)