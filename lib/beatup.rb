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

  module Triggerable

    class << self
      attr_accessor :__BEATUP_CALLBACKS__

      def included mod
        mod.__BEATUP_CALLBACKS__ = {}
      end

    end

    def trigger(event_name, *args)
      event = Event[self, event_name].freeze
      self.class.__BEATUP_CALLBACKS__[event_name].each do|callback|
        callback.call(event, *args)
      end
    end

  end

  class Event
    attr_reader :source, :name
    def initialize source, name
      @source = source
      @name = name
    end

    def == other
      @name == other.name && @source == other.source
    end

    class << self
      alias [] new
    end
  end

  def self.list_callbacks_of(klass, on: nil)
    if on
      on_events = Array(on)
      klass.__BEATUP_CALLBACKS__.values_at(*on_events)
    else
      klass.__BEATUP_CALLBACKS__.values
    end.flatten!
  end

end
