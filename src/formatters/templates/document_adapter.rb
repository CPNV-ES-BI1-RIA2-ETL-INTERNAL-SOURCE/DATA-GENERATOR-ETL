# frozen_string_literal: true

require 'prawn'
require 'prawn/table'
require 'prawn/text/formatted'

module DocumentGenerators
  # Base adapter interface for document generation
  class DocumentAdapter
    attr_reader :document

    def initialize(options = {})
      @options = options
      create_document
    end

    def text(content, options = {})
      raise NotImplementedError, "#{self.class} must implement text method"
    end

    def move_down(amount)
      raise NotImplementedError, "#{self.class} must implement move_down method"
    end

    def image(path, options = {})
      raise NotImplementedError, "#{self.class} must implement image method"
    end

    def table(data, options = {})
      raise NotImplementedError, "#{self.class} must implement table method"
    end

    def font(name, options = {}, &block)
      raise NotImplementedError, "#{self.class} must implement font method"
    end
    
    def font_size(size, &block)
      raise NotImplementedError, "#{self.class} must implement font_size method"
    end

    def render_file(filename)
      raise NotImplementedError, "#{self.class} must implement render_file method"
    end

    def render
      raise NotImplementedError, "#{self.class} must implement render method"
    end

    protected

    def create_document
      raise NotImplementedError, "#{self.class} must implement create_document method"
    end
  end

  # Prawn implementation of DocumentAdapter
  class PrawnAdapter < DocumentAdapter
    def create_document
      @document = Prawn::Document.new(@options)
    end

    def text(content, options = {})
      @document.text(content, options)
    end

    def move_down(amount)
      @document.move_down(amount)
    end

    def image(path, options = {})
      @document.image(path, options)
    end

    def table(data, options = {})
      @document.table(data, options)
    end

    def font(name, options = {}, &block)
      @document.font(name, options, &block)
    end

    def font_size(size, &block)
      @document.font_size(size, &block)
    end

    def render_file(filename)
      @document.render_file(filename)
    end

    def render
      @document.render
    end
  end
end 