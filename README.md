# HMAC

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hmac'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install hmac

## Usage

### Configuration

You'll need to set a secret key, for example:

`config/initializers/hmac.rb`
```ruby
HMAC.configure do |config|
  config.secret = ENV["HMAC_SECRET"]
end
```

This can be overriden when intializing the HMAC generator if needed.

### Generating an HMAC

Firstly, create yourself a generator, giving it a context for the HMAC.

The idea is that you can produce tokens for the same record ID in
different contexts, without allowing someone to use a token from one
context in another.

```ruby
generator = HMAC::Generator.new(context: "user_sessions")
```

Then you can generate a token for a given record ID:

```ruby
token = generator.generate(user.id)
```

You can also pass in a `public` boolean when creating the generator to
similarly produce a different HMAC for the same ID and context but in
public and private situations.  To be honest I don't remember why I
added this, but it's there if you need it.

```ruby
generator = HMAC::Generator.new(context: "user_sessions", public: true)
```

Finally, you can pass in an arbitrary hash of extra fields to be
included in the hash, if you want to confirm more than just the ID.

```ruby
token = generator.generate(user.id, { email_address: user.email_address })
```

### Validating an HMAC

You can verify a token by creating a validator with the same context
and then calling `verify` on it.  The initializer is identical to the
generator.

```ruby
validator = HMAC::Validator.new(context: "user_sessions")
```

Then you can verify a token for a given record ID:

```ruby
validator.verify(token, against_id: user.id)
```

Similarly, extra fields can be passed in to be checked.

```ruby
validator.verify(token, against_id: user.id, extra_fields: {
  email_address: user.email_address,
})
```

The `#verify` method will return `true` or `false`.  If `false`,
something doesn't match and you should refuse the request.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/SmartCasual/hmac.
