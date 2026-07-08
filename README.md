# TPSL

## TPSL Overview

TPSL (Take Profit / Stop Loss) is a lightweight calculator for traders. Enter an entry price, choose a stop-loss percentage, and set a take-profit percentage to see the target prices instantly.

The app is a static web app. It runs in a browser, can be installed as a PWA, and can also be packaged as the included macOS menu bar app.

### Install

- PWA: visit `https://spacesoda.github.io/TPSL/` in a browser, then use the browser's install or "Add to Home Screen" action.
- macOS app: download or clone this repository, open Terminal in the project folder, and run `./launch.command --install`. This builds the app, installs or updates `/Applications/TPSL.app`, and launches it. `./script/build_and_run.sh --install` is the equivalent lower-level command.

The macOS app build requires macOS 13 or later and Apple's Swift toolchain, usually installed with Xcode or the Xcode Command Line Tools.

<br>

## TPSL 簡介

TPSL（止盈 / 止損）是一個輕量的交易計算器。輸入進場價格，選擇止損百分比，並設定止盈百分比後，就能立即看到對應的目標價格。

這是一個靜態 Web App，可直接在瀏覽器中使用，也可以安裝成 PWA。此儲存庫也包含 macOS 選單列 App 的打包設定。

### 安裝

- PWA：用瀏覽器開啟 `https://spacesoda.github.io/TPSL/`，再使用瀏覽器的安裝或「加入主畫面」功能。
- macOS 簡易安裝：下載或 clone 此儲存庫後，在專案資料夾中開啟 Terminal，執行 `./launch.command --install`。此指令會建置 App，安裝或更新 `/Applications/TPSL.app`，並自動啟動。`./script/build_and_run.sh --install` 是等效的底層指令。

macOS App 建置需要 macOS 13 或更新版本，以及 Apple Swift 工具鏈；通常可透過 Xcode 或 Xcode Command Line Tools 安裝。

<br>

## TPSL の概要

TPSL（Take Profit / Stop Loss）は、トレーダー向けの軽量な計算ツールです。エントリー価格、損切り率、利益確定率を入力すると、目標価格をすぐに確認できます。

このアプリは静的な Web App として動作します。ブラウザでそのまま使えるほか、PWA としてインストールすることもできます。このリポジトリには、macOS のメニューバーアプリとしてパッケージ化するための構成も含まれています。

### インストール

- PWA：ブラウザで `https://spacesoda.github.io/TPSL/` を開き、ブラウザのインストール機能または「ホーム画面に追加」からインストールします。
- macOS の簡易インストール：このリポジトリをダウンロードまたは clone し、プロジェクトフォルダで Terminal を開いて `./launch.command --install` を実行します。このコマンドで App をビルドし、`/Applications/TPSL.app` にインストールまたは更新して、自動的に起動します。`./script/build_and_run.sh --install` は同等の下位コマンドです。

macOS App のビルドには、macOS 13 以降と Apple の Swift ツールチェーンが必要です。通常は Xcode または Xcode Command Line Tools でインストールできます。
