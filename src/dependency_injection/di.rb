# frozen_string_literal: true

module DI
  class Container
    def initialize
      @dependencies = {}
    end

    def register(key, value)
      @dependencies[key] = value
    end

    def resolve(key)
      @dependencies[key]
    end

    def [](key)
      resolve(key)
    end
  end
end
