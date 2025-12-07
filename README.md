# GotchaPon

Rails plugin that adds gacha (lottery) functionality to any ActiveRecord model with optional history tracking.

[![Chiikawa Anime GIF](https://media1.tenor.com/m/VTwpo8Pk4gAAAAAC/chiikawa-anime.gif)](https://tenor.com/view/chiikawa-anime-kawaii-cute-cartoon-gif-6141829775169479168)
*GIF from Tenor*

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

# Works with scopes
Item.where(category: "rare").gotcha_pon(count: 3)
```

### Weighted Selection (Optional)

To use weighted selection, add a numeric column to your model:

```bash
$ rails generate migration AddWeightToItems weight:integer
$ rails db:migrate
```

Then configure the weight column:

```ruby
class Item < ApplicationRecord
  include GotchaPon::Gotchable
  gotcha_pon_weight column: :weight
end

# Items with higher weight values are more likely to be selected
# weight: 80 -> 80% chance
# weight: 15 -> 15% chance
# weight: 5  ->  5% chance
Item.gotcha_pon
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