# $Id$

package RebuildOncetimePerDay::L10N::ja;

use strict;
use base 'RebuildOncetimePerDay::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
    'description of RebuildOncetimePerDay' => '1日1回、IDで指定されたインデックステンプレートを強制的に再構築します。',
    'RebuildOncetimePerDay enable:' => 'このブログでプラグインを使用する。',
    'Enable this plugin in this blog' => '使用する。',
    'RebuildOncetimePerDay target template ids:' => '再構築の対象にするテンプレートのID',
    'RebuildOncetimePerDay target template ids Hint' => '","(カンマ)でIDを区切って入力してください。',
    'RebuildOncetimePerDay starttime:' => '再構築を行う時刻',
    'RebuildOncetimePerDay starttime Hint' => 'run-periodic-taskがここで指定した時刻以降に駆動した際に1回だけ本プラグインは動作します。',
    'RebuildOncetimePerDay lastdate:' => '最後に本プラグインが動作した日',
    'RebuildOncetimePerDay lastdate Hint' => '自動的に値が変更されるので、設定は不要です。',
);

1;
