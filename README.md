# 「Proglog」(https://proglog.life/)

※画面右上の「ゲストログイン」をクリックすると、ゲスト用のメールアドレス(guest_user@example.com)・パスワード(password)が既に入力されているため、そのまま「ゲストとしてログインする」をクリックし、お試しでログインできます。

ブログサイトです。書籍や公式ドキュメント、企業ブログ、プログラミングスクール(全て参照元一覧に記載致します)から得られた知識を使いこなすためのアウトプットとして作成しました。  
twitterAPIを用いた、お手軽ログイン機能、記事の拡散を目論む告知ツイート機能を実装しています。  
Rail6から標準機能となったAction Textを用いた、文字の修飾機能(太字、イタリック等)、画像のドラッグ＆ドロップ機能を実装しています。  
その他の機能は機能一覧に記載致します。
<img width="1680" alt="スクリーンショット 2021-09-28 0 33 13" src="https://user-images.githubusercontent.com/69506096/134939659-c82b0923-c20d-46d0-a323-cf6e42556559.png">

__使用技術__  
* 主要開発言語  
Ruby 3.0.0  

* 開発フレームワーク  
Ruby on Rails 6.1.3.2  

* テンプレートエンジン  
Slim

* データベース  
postgres 12.6  

* アプリケーションサーバー  
puma  

* コンテナ管理ツール  
Docker 20.10.7 / docker-compose 1.29.2  

* CI/CDツール
CircleCI

* デプロイ環境
aws  
  EC2  
  ECR  
  ECS  
  S3  
  RDS  
  VPC  
  Route53  
  CloudFormation  

__機能一覧__
* ログイン・ログアウト機能
* Twitterアカウントによるログイン認証機能(omniauth-twitter, omniauth-rails_csrf_protection)
* 投稿記事・ユーザー検索機能(ransack)
* 画像投稿機能(image_processing, aws-sdk-s3)
* 記事内リンク有効化機能
* 文字の修飾機能
* ページネーション機能(kaminari)
* 記事投稿の告知ツイート及びアプリ内でのツイート閲覧機能(twitter)
* ユーザー別の記事のカテゴライズ機能
* 管理者の追加権限(ユーザー、投稿記事の削除)
* 「N+1問題」のチェック(bullet)  

__テスト__
* RSpec  
  各モデルの検証機能のテスト(model)  
  各コントローラーのHTTPレスポンスのテスト(request)  
  統合テスト(system)  

* rubocop

* brakeman

__参照元一覧__  
_○書籍_  
* 「プロを目指す人のためのRuby入門 言語仕様からテスト駆動開発・デバッグ技法まで」　伊藤 淳一 (著)　技術評論社  
* 「現場で使える Ruby on Rails 5速習実践ガイド」
  大場寧子 (著), 松本拓也 (著), 櫻井達生 (著), 小田井優 (著), 大塚隆弘 (著), 依光奏江 (著), 銭神裕宜 (著), 小芝美由紀 (著)　マイナビ出版  
* 「パーフェクト Ruby on Rails 【増補改訂版】」 すがわらまさのり (著), 前島真一 (著), 橋立友宏 (著), 五十嵐邦明 (著), 後藤優一 (著)　技術評論社  
* 「Everyday Rails - RSpecによるRailsテスト入門 テスト駆動開発の習得に向けた実践的アプローチ」
  Aaron Sumner(著), Junichi Ito (伊藤淳一)(訳), AKIMOTO Toshiharu(訳), 魚振江(訳)　Leanpub  
* 「CircleCI実践入門──CI/CDがもたらす開発速度と品質の両立」　浦井 誠人 (著), 大竹 智也 (著), 金 洋国 (著)　技術評論社  
* 「さわって学ぶクラウドインフラ　docker基礎からのコンテナ構築」　大澤 文孝 (著), 浅居 尚 (著)　日経BP  
* 「Amazon ECSとAmazon RDSで作るRuby on Railsアプリ」　よろず屋H(著)　技術書典  
* 「Amazon Web Servicesインフラサービス活用大全 システム構築/自動化、データストア、高信頼化」　Michael Wittig (著), Andreas Wittig (著), 株式会社クイープ (翻訳)　インプレス  
* 「リーダブルコード ―より良いコードを書くためのシンプルで実践的なテクニック」　Dustin Boswell (著), Trevor Foucher (著), 須藤 功平 (解説), 角 征典 (翻訳)　オライリージャパン  
* 「Webを支える技術 -HTTP、URI、HTML、そしてREST」　山本 陽平 (著)　技術評論社  
* 「キタミ式イラストIT塾 応用情報技術者 令和02年」　きたみ りゅうじ (著)　技術評論社  
* 「令和02年【春期】【秋期】 応用情報技術者 合格教本」　大滝 みや子 (著), 岡嶋 裕史 (著)　技術評論社  

_○webサイト_  
* 「Ruby on Rails チュートリアル」(https://railstutorial.jp/)  
* 「オブジェクト指向スクリプト言語 Ruby リファレンスマニュアル」(https://docs.ruby-lang.org/ja/latest/doc/index.html)  
* 「AWS CloudFormationユーザーガイド」(https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/Welcome.html)  
* 「Qiita」(https://qiita.com/)  
* 「stackoverflow」(https://stackoverflow.com/)  
* 「DevelopersIO produced by Classmethod」(https://dev.classmethod.jp/)

_○プログラミングスクール_  
* 「ポテパンキャンプ」  
