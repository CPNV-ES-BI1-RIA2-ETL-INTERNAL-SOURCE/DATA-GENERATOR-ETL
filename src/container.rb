# frozen_string_literal: true

require 'dry/container'
require 'dry/auto_inject'

# Container module for dependency management
class Container
  extend Dry::Container::Mixin

  # The register method is used here - defined by Dry::Container
end

# Import module for dependency injection
Import = Dry::AutoInject(Container)
