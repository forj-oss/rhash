# Recursive Hash

Recursive Hash is a set of tools which facilitate data structured as tree of Hash or Array to be
set and get.

It provides following functions to the Ruby Hash object:

- Hash.rh\_get
- Hash.rh\_set
- Hash.rh\_exist? or Hash.rh\_lexist?
- Hash.rh\_del
- Hash.rh\_merge
- Array.rh\_merge

Thanks to set of functions, you can easily create a tree of Hash or Array.

Ex:
 
    data = {}

    data.rh_set(:value, :level1, :level2, :level3)
    # => { :level1 => { :level2 => { :level3 => :value } } }

    # And it is easy to add or remove
    data.rh_set(:value2, :level1, :level2, :level3)
    # => { :level1 => { :level2 => { :level3 => :value } } }
    data.rh_set(:value, :level1, :level2, :level3_second)
    # => { :level1 => { :level2 => { :level3 => :value, :level3_second => :value } } }
    data.rh_del(:level1, :level2, :level3)
    # => { :level1 => { :level2 => { } } }

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rh'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rh

## Usage

To use Recursive Hash, just add this require in your code:

require 'rh'

Hash and Array object are enhanced and provide those features to any Hash or Array. So, you just need to 
call wanted functions.

Ex: 

    data = Hash.new
    data.rh_set(:value, :key_lvl1)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. clone it ( https://review.forj.io/forj-oss/rh )
2. add an alias to push your code

    alias git-push='git push origin HEAD:refs/for/$(git branch -v|grep "^\*"|awk '\''{printf $2}'\'')'

  or install git-review

3. push your code
  * with git-push
  * with git-review. See http://www.mediawiki.org/wiki/Gerrit/git-review
   
