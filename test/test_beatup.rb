class TestBeatup < TestHelper::TestCase

  sub_test_case 'Given triggers and listeners' do
    class ::Kernel::SampleTrigger0
      include ::Beatup::Triggerable
    end
    class ::Kernel::SampleTrigger1
      include ::Beatup::Triggerable
    end

    [0, 1].each do|listener_number|

      listener_class = Class.new do
        extend ::Beatup::Listener

        def self.do_something_with_event event, *args
          # record with crispy
        end
      end
      ::Kernel.const_set :"SampleListener#{listener_number}", listener_class

      [0, 1].each do|trigger_number|
        [0, 1].each do|event_number|
          trigger_class = const_get :"SampleTrigger#{trigger_number}"

          listener_class.class_eval do
            listen_to trigger_class, :"both_event#{event_number}" do|event, *args|
              self.do_something_with_event event, *args
            end

            listen_to trigger_class, :"only_listener#{listener_number}_event#{event_number}" do|event, *args|
              self.do_something_with_event event, *args
            end
          end

        end
      end
    end

    setup do
      @listeners = [0, 1].map do|listener_number|
        ::Kernel.const_get :"SampleListener#{listener_number}"
      end
      @listeners.each {|listener| ::Crispy.spy_into(listener) }
    end

    [0, 1].each do|trigger_number|
      [0, 1].each do|event_number|
        sub_test_case "when trigger#{trigger_number} fires event#{event_number} for both" do

          setup do
            @trigger = ::Kernel.const_get(:"SampleTrigger#{trigger_number}").new
            @trigger.trigger(:"both_event#{event_number}", :argument)
          end

          [0, 1].each do|listener_number|
            test "listener#{listener_number} listens the event#{event_number}" do
              assert_include(
                ::Crispy.spy(@listeners[listener_number]).received_messages,
                ::Crispy::CrispyReceivedMessage[
                  :do_something_with_event,
                  ::Beatup::Event[@trigger, :"both_event#{event_number}"],
                  :argument,
                ],
              )
            end
          end
        end

          [0, 1].permutation do|(triggered_listener_number, non_triggered_listener_number)|
            sub_test_case "when trigger#{trigger_number} fires event#{event_number} only for listener#{triggered_listener_number}" do

              setup do
                @trigger = ::Kernel.const_get(:"SampleTrigger#{trigger_number}").new
                @trigger.trigger(:"only_listener#{triggered_listener_number}_event#{event_number}", :argument)
              end

              test "listener#{triggered_listener_number} listens the event#{event_number}" do
                assert_include(
                  ::Crispy.spy(@listeners[triggered_listener_number]).received_messages,
                  ::Crispy::CrispyReceivedMessage[
                    :do_something_with_event,
                    ::Beatup::Event[@trigger, :"only_listener#{triggered_listener_number}_event#{event_number}"],
                    :argument,
                  ],
                )
              end

              test "listener#{non_triggered_listener_number} does not listen the event#{event_number}" do
                assert_not_include(
                  ::Crispy.spy(@listeners[non_triggered_listener_number]).received_messages,
                  ::Crispy::CrispyReceivedMessage[
                    :do_something_with_event,
                    ::Beatup::Event[@trigger, :"only_listener#{non_triggered_listener_number}_event#{event_number}"],
                    :argument,
                  ],
                )
              end

            end
          end

      end
    end

  end

end
