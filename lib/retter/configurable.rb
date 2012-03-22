# coding: utf-8

module Retter
  module Configurable
    def configurable(*names)
      names.each do |name|
        define_configurable_method name
        define_instance_shortcut_method name
      end
    end

    def define_configurable_method(name)
      instance_eval <<-EOM
        def #{name}(val = nil)
          val ? @#{name} = val : @#{name}
        end
      EOM
    end

    def define_instance_shortcut_method(name)
      define_method name do
        self.class.send(name)
      end
    end
  end
end
