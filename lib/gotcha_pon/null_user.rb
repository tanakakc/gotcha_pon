# frozen_string_literal: true

module GotchaPon
  class NullUser
    def name
      "anonymous"
    end

    def id
      nil
    end

    def persisted?
      false
    end

    # インスタンス生成を避けるためのsingleton
    def self.instance
      @instance ||= new
    end

    private_class_method :new
  end
end
