# GachaPon Gem 仕様書

## 概要
任意のRailsモデルにガチャ機能を追加するgem。日本のガチャポン文化をイメージした楽しいネーミングで、データが「ポン」と出てくる体験を提供。

## 主要機能

### 1. 基本ガチャ機能
- 重み付き確率抽選
- 複数ルール対応
- 一回/複数回抽選

### 2. 履歴管理
- ガチャ実行履歴の記録
- ユーザー別履歴
- 統計情報

### 3. 高度な機能
- 天井システム（確定演出）
- 期間限定ガチャ
- 重複排除機能

## API設計

### 基本使用例

```ruby
# モデル設定
class Item < ApplicationRecord
  include GachaPon::Ponnable
  
  gacha_pon_config do |config|
    config.weight_column = :rarity_weight
    config.rules = {
      standard: [
        { rate: 70, scope: -> { where(rarity: 'common') } },
        { rate: 25, scope: -> { where(rarity: 'rare') } },
        { rate: 5, scope: -> { where(rarity: 'legendary') } }
      ],
      premium: [
        { rate: 50, scope: -> { where(rarity: 'rare') } },
        { rate: 40, scope: -> { where(rarity: 'legendary') } },
        { rate: 10, scope: -> { where(rarity: 'mythic') } }
      ]
    }
  end
end

# ガチャ実行
user = User.find(1)

# 単発ガチャ
item = Item.gacha_pon(user: user)

# 10連ガチャ
items = Item.gacha_pon(user: user, count: 10)

# ルール指定
items = Item.gacha_pon(user: user, rule: :premium, count: 10)

# 履歴確認
histories = user.gacha_pon_histories
recent_items = histories.recent.includes(:ponnable)
```

### 設定オプション

```ruby
gacha_pon_config do |config|
  # 基本設定
  config.weight_column = :weight        # 重みカラム（デフォルト: nil = 均等）
  config.default_rule = :standard       # デフォルトルール
  
  # ルール定義
  config.rules = {
    standard: [
      { rate: 70, scope: -> { common_items } },
      { rate: 30, scope: -> { rare_items } }
    ]
  }
  
  # 天井システム
  config.pity_system = {
    enabled: true,
    max_attempts: 90,           # 90回で確定
    target_scope: -> { legendary_items },
    reset_on_success: true
  }
  
  # 重複排除
  config.duplicate_protection = {
    enabled: true,
    scope: ->(user) { user.owned_items.pluck(:id) }
  }
  
  # 期間限定
  config.time_limited_rules = {
    summer_event: {
      active_period: 1.month.from_now,
      rules: [
        { rate: 60, scope: -> { summer_items } },
        { rate: 40, scope: -> { rare_items } }
      ]
    }
  }
end
```

## データベース設計

### gacha_pon_histories テーブル
```ruby
create_table :gacha_pon_histories do |t|
  t.references :user, polymorphic: true, null: false
  t.references :ponnable, polymorphic: true, null: false
  t.string :rule_name, default: 'standard'
  t.integer :attempt_count, default: 1
  t.json :metadata  # 追加情報（確率、重み等）
  t.timestamps
end
```

### gacha_pon_pity_counters テーブル（天井システム用）
```ruby
create_table :gacha_pon_pity_counters do |t|
  t.references :user, polymorphic: true, null: false
  t.string :ponnable_type, null: false
  t.string :rule_name, default: 'standard'
  t.integer :current_count, default: 0
  t.timestamps
end
```

## Gem構造

```
gacha_pon/
├── lib/
│   ├── gacha_pon.rb
│   ├── gacha_pon/
│   │   ├── engine.rb
│   │   ├── ponnable.rb           # メインconcern
│   │   ├── drawer.rb             # 抽選ロジック
│   │   ├── configuration.rb      # 設定管理
│   │   ├── pity_system.rb        # 天井システム
│   │   ├── history_manager.rb    # 履歴管理
│   │   └── version.rb
│   └── generators/
│       └── gacha_pon/
│           └── install_generator.rb
├── app/
│   └── models/
│       └── gacha_pon/
│           ├── history.rb
│           └── pity_counter.rb
├── db/
│   └── migrate/
│       ├── 001_create_gacha_pon_histories.rb
│       └── 002_create_gacha_pon_pity_counters.rb
├── spec/
├── README.md
└── gacha_pon.gemspec
```

## 実装優先度

### Phase 1: 基本機能
1. ✅ Ponnable concern
2. ✅ 基本抽選ロジック（gacha_pon メソッド）
3. ✅ 履歴管理
4. ✅ Generator

### Phase 2: 高度な機能
1. 天井システム
2. 重複排除
3. 期間限定ルール

### Phase 3: 便利機能
1. 統計情報
2. デバッグ機能
3. パフォーマンス最適化

## 使用想定シーン

### 1. ゲームアプリ
```ruby
class Card < ApplicationRecord
  include GachaPon::Ponnable
  
  gacha_pon_config do |config|
    config.weight_column = :drop_rate
    config.rules = {
      normal: [
        { rate: 80, scope: -> { where("rarity <= ?", 3) } },
        { rate: 20, scope: -> { where("rarity > ?", 3) } }
      ]
    }
  end
end
```

### 2. ECサイトのキャンペーン
```ruby
class Prize < ApplicationRecord
  include GachaPon::Ponnable
  
  gacha_pon_config do |config|
    config.rules = {
      campaign: [
        { rate: 60, scope: -> { discount_coupons } },
        { rate: 30, scope: -> { point_bonuses } },
        { rate: 10, scope: -> { free_shipping_tickets } }
      ]
    }
  end
end
```

### 3. 学習アプリ
```ruby
class Question < ApplicationRecord
  include GachaPon::Ponnable
  
  gacha_pon_config do |config|
    config.rules = {
      practice: [
        { rate: 70, scope: -> { basic_level } },
        { rate: 30, scope: -> { advanced_level } }
      ]
    }
  end
end
```

## テスト方針

### 単体テスト
- 抽選ロジックの確率検証
- 履歴記録の正確性
- エラーハンドリング

### 統合テスト
- 実際のRailsアプリとの連携
- パフォーマンステスト
- 複数ユーザー同時アクセス

### シード値固定テスト
```ruby
# 再現可能なテスト
Random.srand(42)
items = Item.gacha_pon(user: user, count: 100)
# 期待される結果と比較
```

## 今後の拡張可能性

1. **アニメーション連携**: フロントエンドでのガチャ演出
2. **確率表示**: 法的要求に対応した確率開示
3. **A/Bテスト**: 複数ルールの効果測定
4. **機械学習**: ユーザー行動に基づく最適化

---

*このgemで、みんなの開発に「ポン！」と楽しさを！* 🎰✨