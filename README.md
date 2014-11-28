# Beatup

Observer extension for class.
Maybe better than the existing libraries to implement observer pattern easily because:

- TODO

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'beatup'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install beatup

## Usage

Example: Notify when some data added.

```ruby
class User
  include Beatup::Triggerable

  def update_profle new_profile
    # ... some codes to update profile ...

    # Then notify the listener classes (below).
    trigger :after_update_profile
  end

  def followers
    # ... some code to retreive a user's follwers ...
  end
end

class Notification
  extend Beatup::Listener

  # Execute the block when some of the given class's instance triggers the specified event.
  # the triggered user is passed to the block argument
  listen_to User, :after_update_profile do|updated_user|
    updated_user.followers.each do|follower_user|
      Notification.create from: updated_user, to: follower_user
    end
  end
end
```

## Contributing

1. Fork it ( https://github.com/igrep/beatup/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
