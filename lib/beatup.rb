require "beatup/version"

module Beatup

  module Listener

    def listen_to klass, event_name, method_name = nil, &callback
      if method_name && callback
        raise ArgumentError, "You can't specify both callback and method_name at once!"
      end

      callbacks = (klass.__BEATUP_CALLBACKS__[event_name] ||= [])
      callbacks << method_name ?  self.method(method_name) : callback
      self
    end

  end

  # Your code goes here...
end
