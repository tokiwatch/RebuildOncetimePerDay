RebuildOnceTimePerDayプラグイン
=====================

はじめに
--------

このプラグインは、指定されたIDのテンプレートを1日1回再構築するプラグインです。
インストール
------------

1. (事前準備) run-periodic-taskが定期的に実行されるようにcronを設定してください。
1. プラグインを、MTのプラグインディレクトリに設置してください。

使い方
------

1. 各ブログのプラグイン設定画面から、RebuildOnceTimePerDayを選択します。
1. 「このブログでプラグインを使用する。」にチェックを入れます。
1. 「再構築の対象にするテンプレートのID」にテンプレートIDを入力します。複数入力する場合は","(カンマ)で区切ってください。
1. 「再構築を行う時刻」に再構築させる時間を入力してください。再構築の処理はこの値より後のrun-periodic-taskが動作するタイミングで行なわれます。


