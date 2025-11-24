class Item < ApplicationRecord
  include GotchaPon::Gotchable

  track_gotcha_pon_history
end
