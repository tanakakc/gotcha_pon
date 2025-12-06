# GotchaPon

Rails plugin that adds gacha (lottery) functionality to any ActiveRecord model with optional history tracking.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "gotcha_pon", github: "tanakakc/gotcha_pon"
```

And then execute:

```bash
$ bundle install
$ rails generate gotcha_pon:install
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

### History Tracking (Optional)

To enable history tracking, run the generator with `--with-history` option:

```bash
$ rails generate gotcha_pon:install --with-history
$ rails db:migrate
```

Then use `gotcha_pon_with_history` method:

```ruby
# Execute gacha with history tracking
Item.gotcha_pon_with_history(user: current_user)

# Execute gacha without user (anonymous)
Item.gotcha_pon_with_history(count: 3)

# View history
GotchaPon::History.recent
GotchaPon::History.for_user(current_user)
```