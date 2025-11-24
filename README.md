# GotchaPon

Rails plugin that adds gacha (lottery) functionality to any ActiveRecord model with optional history tracking.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "gotcha_pon"
```

And then execute:

```bash
$ bundle install
$ rails generate gotcha_pon:install
$ rails db:migrate
```

## Usage

### Basic Gacha

```ruby
class Item < ApplicationRecord
  include GotchaPon::Gotchable
end

# Get one random item
item = Item.gotcha_pon

# Get multiple random items
items = Item.gotcha_pon(count: 3)
```

### History Tracking

Enable history tracking to record gacha executions:

```ruby
class Item < ApplicationRecord
  include GotchaPon::Gotchable
  track_gotcha_pon_history
end

# Execute gacha with user tracking
Item.gotcha_pon(user: current_user)

# Execute gacha without user (anonymous)
Item.gotcha_pon

# View history
GotchaPon::History.recent
GotchaPon::History.for_user(current_user)
```
