# Recursive Hash of Hashes/Arrays

SubHash is a set of tools which facilitate data structured as tree of Hash or Array to be
set and get.

Imagine you have a yaml file to load. If your yaml file is well structured, it will be stored 
in memory as Hash of Hashes, or even Arrays or any kind of type recognized by ruby.

So, if you want to access a data in a strong tree of hash, how do you write this?

    puts data[key_l1][key_l2][key_l3][mykey]
    => myvalue

What's happen if key\_l1 doesn't exist? or exist but contains a nil or any other value instead of a Hash?
An exception is generated. So, you need to add exception to avoid this.

But your code may become a little complex if you need to check if those layers exists or not...

So, imagine that instead of that, you do:

    puts data.rh_get(key_l1, key_l2, key_l3, mykey)

Interesting, right?

Imagine the set, now:

    data.rh_set(MyNewValue, key_l1, key_l2, key_l3, mykey)

Seems easier, right?

And you can check if keys exists, as well as until which level of Hash, I found the path to my key:

    data.rh_exist?(key_l1, key_l2, key_l3, mykey)
    => true/false

    data.rh_lexist?(key_l1, key_l2, key_l3, mykey)
    => can be 0, 1, 2 ,3 or 4, depending on the path existence to access mykey...

If you think this can help you, subhash provides the following functions to the Ruby Hash/Array object:

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
gem 'subhash'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install subhash

## Usage

To use Recursive Hash, just add this require in your code:

require 'subhash'

Hash and Array object are enhanced and provide those features to any Hash or Array. So, you just need to 
call wanted functions.

Ex: 

    data = Hash.new
    data.rh_set(:value, :key_lvl1)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. clone it ( https://review.forj.io/forj-oss/rhash ) 
2. add an alias to push your code

    alias git-push='git push origin HEAD:refs/for/$(git branch -v|grep "^\*"|awk '\''{printf $2}'\'')'

  or install git-review

3. push your code
  * with git-push
  * with git-review. See http://www.mediawiki.org/wiki/Gerrit/git-review
  

Enjoy!!! 
