require File.expand_path(File.join(File.dirname(__FILE__), "has_attributes", "version"))
require "set"

module HasAttributes
  def self.included(base)
    base.class.send(:attr_accessor, :model_attributes)
    base.send(:model_attributes=, Set.new)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def has_attributes(*attrs)
      options = attrs.last.instance_of?(Hash) ? attrs.pop : {}
      inherit_parent_attributes = options[:inherit] != false

      parent_attributes = if superclass.respond_to?(:model_attributes) && superclass.model_attributes.is_a?(Set)
        superclass.model_attributes.dup
      else
        Set.new
      end

      attrs = model_attributes.merge(attrs.map(&:to_sym))

      if inherit_parent_attributes
        attrs = parent_attributes.merge(attrs)
      elsif !parent_attributes.empty?
        methods_to_remove = parent_attributes.reduce([]) do |memo, getter|
          setter = (getter.to_s << "=").to_sym
          memo.push(getter) if public_method_defined?(getter)
          memo.push(setter) if public_method_defined?(setter)
          memo
        end
        instance_eval {undef_method *methods_to_remove}
      end

      self.model_attributes = attrs
      instance_eval {attr_accessor *attrs}
    end
  end

  def attributes=(attrs)
    self.class.model_attributes.each do |attr|
      public_send((attr.to_s << "=").to_sym, attrs[attr])
    end
  end

  def attributes
    self.class.model_attributes.reduce({}) do |memo, attr|
      unless (value = public_send(attr)).nil?
        memo[attr] = value
      end
      memo
    end
  end
end
