# システム自動化

## 検証

### 各種サーバ連携

#### トリガー監視デーモン

- 実行するツールは同期処理とする。
- 実行するツールは戻り値を返却する。
  - エラーが発生した場合はどのタイミングで発生したかわかるよう戻り値を定義する。
    - エラーの場合の自動化DB登録はツール、またはトリガー側で行うかは未定。
- 実行ツールが使用するパラメータは環境変数に設定しておく。

#### シーケンス

```mermaid
sequenceDiagram
  participant A as 管理サーバ
  participant B as 疑似CPP
  participant C as 疑似Java
  participant D as ZDC-S3
  Note over A,D: 新規(木崎)トリガー監視デーモンが実行するツール
  A->>B: サーバ起動(awscli)
  B->>A: 起動結果返却
  A->>C: サーバ起動(awscli)
  C->>A: 起動結果返却
  A->>B: コンテナ状態確認(ssh)
  B->>A: コンテナ状態返却
  alt コンテナ未起動 
    A->>B: コンテナ起動(ssh)
    B->>A: 起動結果返却
  end
  rect rgb(178, 101, 255)
    Note over A,C: 既存
    A->>+B: 対象バージョン取得(ssh)
    B->>-A: 対象バージョン返却
    A->>+B: 運用ツール実行(ssh)
    B-->>C: データ配置
    B->>-A: 実行結果返却
  end
  A->>C: 抽出用パラメータ設置(scp)
  rect rgb(255, 255, 153)
    Note over A,C: 新規(中畑さん？)
    A->>+C: 抽出ツール実行(ssh)
    C->>-A: 実行結果返却
  end
  rect rgb(255, 153, 153)
    Note over A,D: 新規(木崎)
    A->>+C: 抽出結果アップロードツール実行(ssh)
    C-->>D: データアップロード
    C->>-A: 実行結果返却
  end
  A->>C: サーバ状態確認(awscli)
  C->>A: サーバ状態返却
  alt サーバ起動中
    A->>C: 処理/ログイン確認(ssh)
    C->>A: 結果返却
    alt 処理/ログインなし
      A->>C: サーバ停止(awscli)
      C->>A: 停止結果返却
    end
  end
  
  A->>B: コンテナ状態確認(ssh)
  B->>A: コンテナ状態返却
  alt 対象コンテナ起動中
    A->>B: 処理/ログイン確認(ssh)
    B->>A: 結果返却
    alt 処理/ログインなし
      A->>B: 対象コンテナ停止(ssh)
      B->>A: 停止結果返却
    end
  end
  alt その他コンテナ起動なし
    A->>B: ホスト側処理/ログイン確認
    B->>A: 結果返却
    alt 処理/ログインなし
      A->>B: サーバ停止(awscli)
      B->>A: 停止結果返却
    end
  end
```
