# frozen_string_literal: true

module GotchaPon
  class NullUser
    def id
      nil
    end

    def persisted?
      false
    end

    def to_global_id
      nil
    end

    # polymorphic association用
    def class
      NullUser
    end

    def self.name
      "GotchaPon::NullUser"
    end

    # インスタンス生成を避けるためのsingleton
    def self.instance
      @instance ||= new
    end

    private_class_method :new
  end
end