# encoding: UTF-8

# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

# Recursive Hash added to the Hash class
class Hash
  # Recursive Hash deep level found counter
  # This function will returns the count of deep level of recursive hash.
  # * *Args* :
  #   - +p+    : Array of string or symbols. keys tree to follow and check
  #              existence in yVal.
  #
  # * *Returns* :
  #   - +integer+ : Represents how many deep level was found in the recursive
  #                 hash
  #
  # * *Raises* :
  #   No exceptions
  #
  # Example: (implemented in spec)
  #
  #    yVal = { :test => {:test2 => 'value1', :test3 => 'value2'},
  #             :test4 => 'value3'}
  #
  # yVal can be represented like:
  #
  #   yVal:
  #     test:
  #       test2 = 'value1'
  #       test3 = 'value2'
  #     test4 = 'value3'
  #
  # so:
  #   # test is found
  #   yVal.rh_lexist?(:test) => 1
  #
  #   # no test5
  #   yVal.rh_lexist?(:test5) => 0
  #
  #   # :test/:test2 tree is found
  #   yVal.rh_lexist?(:test, :test2) => 2
  #
  #   # :test/:test2 is found (value = 2), but :test5 was not found in this tree
  #   yVal.rh_lexist?(:test, :test2, :test5) => 2
  #
  #   # :test/:test2 is found (value = 2), and 'value1' was found in this tree,
  #   # but not as a Hash
  #   yVal.rh_lexist?(:test, :test2, 'value1') => 2
  #
  #   # :test was found. but :test/:test5 tree was not found. so level 1, ok.
  #   yVal.rh_lexist?(:test, :test5 ) => 1
  #
  #   # it is like searching for nothing...
  #   yVal.rh_lexist? => 0
  #
  # New features 0.1.3
  #
  def rh_lexist?(*p)
    p = p.flatten

    return 0 if p.length == 0

    key = p[0]
    sp = p.drop(1)

    selected, key = _erb_select(key)
    return 0 unless selected

    key = _erb_extract(key)

    re, _, opts = _regexp(key)
    return _keys_match_lexist(re, [], sp, opts) unless re.nil?

    return 0 unless self.key?(key)

    return 1 if p.length == 1

    ret = 0
    ret = self[key].rh_lexist?(*sp) if self[key].structured?
    1 + ret
  end

  # Recursive Hash deep level existence
  #
  # * *Args* :
  #   - +p+    : Array of string or symbols. keys tree to follow and check
  #              existence in yVal.
  #
  # * *Returns* :
  #   - +boolean+ : Returns True if the deep level of recursive hash is found.
  #                 false otherwise
  #
  # * *Raises* :
  #   No exceptions
  #
  # Example:(implemented in spec)
  #
  #    yVal = { :test => {:test2 => 'value1', :test3 => 'value2'},
  #             :test4 => 'value3'}
  #
  # yVal can be represented like:
  #
  #   yVal:
  #     test:
  #       test2 = 'value1'
  #       test3 = 'value2'
  #     test4 = 'value3'
  #
  # so:
  #   # test is found
  #   yVal.rh_exist?(:test) => True
  #
  #   # no test5
  #   yVal.rh_exist?(:test5) => False
  #
  #   # :test/:test2 tree is found
  #   yVal.rh_exist?(:test, :test2) => True
  #
  #   # :test/:test2 is found (value = 2), but :test5 was not found in this tree
  #   yVal.rh_exist?(:test, :test2, :test5) => False
  #
  #   # :test was found. but :test/:test5 tree was not found. so level 1, ok.
  #   yVal.rh_exist?(:test, :test5 ) => False
  #
  #   # it is like searching for nothing...
  #   yVal.rh_exist? => nil
  def rh_exist?(*p)
    p = p.flatten

    return nil if p.length == 0

    count = p.length
    (rh_lexist?(*p) == count)
  end

  # Recursive Hash/Array Get
  # This function will returns the level of recursive subhash structure found.
  # Thanks to Regexp support in keys or string interpretation, rh_get can
  # extract data found in the tree matching and build a simplified structure as
  # result.
  #
  # * *Args* :
  #   - +p+    : Array of String/Symbol or Regexp. It contains the list of keys
  #     tree to follow and check existence in self.
  #
  #     In the subhash structure, each hierachie tree level is a Hash or an
  #     Array.
  #
  #     At a given level the top key will be interpreted as follow and used as
  #     data selection if the object is:
  #     - Hash:
  #       You can define key matching with Regexp or with a structured string:
  #       - Regexp or '/<Regexp>/' or '[<Regexp>]' :
  #         For each key in self tree, matching <Regexp>, the value associated
  #         to the key will be added as a new item in an array.
  #
  #       - '{<regexp>}' :
  #         For each key in self tree, matching <Regexp>, the value and the key
  #         will be added as a new item (key => value) in a Hash
  #
  #     - Array:
  #       If the top key type is:
  #       - Fixnum : The key is considered as the Array index.
  #         it will get in self[p[0]]
  #
  #       - String/Symbol : loop in array to find in Hash, the key to get value
  #         and go on in the tree if possible. it must return an array of result
  #         In case of symbol matching, the symbol is converted in string with a
  #         ':' at pos 0 in the string, then start match process.
  #
  # * *Returns* :
  #   - +value+ : Represents the data found in the tree. Can be of any type.
  #
  # * *Raises* :
  #   No exceptions
  #
  # Example:(implemented in spec)
  #
  #    data =
  #    :test:
  #      :test2 = 'value1'
  #      :test3 => 'value2'
  #    :test4 = 'value3'
  #    :arr1: [ 4, 'value4']
  #    :arr2:
  #    - :test5 = 'value5'
  #      :test6 = 'value6'
  #    - :test7 = 'value7'
  #      :test8
  #      :test5 = 'value8'
  #
  # so:
  #   data.rh_get(:test) => {:test2 => 'value1', :test3 => 'value2'}
  #   data.rh_get(:test5) => nil
  #   data.rh_get(:test, :test2) => 'value1'
  #   data.rh_get(:test, :test2, :test5) => nil
  #   data.rh_get(:test, :test5 ) => nil
  #   data.rh_get => { :test => {:test2 => 'value1', :test3 => 'value2'},
  #                    :test4 => 'value3'}
  #
  # New features: 0.1.2
  #   data.rh_get(:test, /^test/)       # => []
  #   data.rh_get(:test, /^:test/)      # => ['value1', 'value2']
  #   data.rh_get(:test, /^:test.*/)    # => ['value1', 'value2']
  #   data.rh_get(:test, '/:test.*/')   # => ['value1', 'value2']
  #   data.rh_get(:test, '/:test.*/')   # => ['value1', 'value2']
  #   data.rh_get(:test, '[/:test.*/]') # => ['value1', 'value2']
  #   data.rh_get(:test, '{/:test2/}')  # => {:test2 => 'value1'}
  #   data.rh_get(:test, '{/test/}')
  #     # => {:test2 => 'value1', :test3 => 'value2'}
  #   data.rh_get(:test, '{:test2}')    # => {:test2 => 'value1'}
  #   data.rh_get(:test, '{:test2}')    # => {:test2 => 'value1'}
  #
  #   data.rh_get(:arr2, :test6)        # => ['value6']
  #   data.rh_get(:arr2, :test8)        # => nil
  #   data.rh_get(:arr2, :test5)        # => ['value5', 'value8']
  #   data.rh_get(/arr/, :test5)        # => [['value5', 'value8']]
  #   data.rh_get('{/arr/}', :test5)    # => { :arr2 => ['value5', 'value8']}
  #   data.rh_get('{/arr/}', '{:test5}')
  #     # => { :arr2 => {:test5 => ['value5', 'value8']}}
  #
  #   data.rh_get(:arr2, 2)             # => nil
  #   data.rh_get(:arr2, 0)             # => { :test5 = 'value5',
  #                                     #      :test6 = 'value6'}
  #   data.rh_get(:arr2, 1)             # => { :test7 = 'value7',
  #                                     #      :test8
  #                                     #      :test5 = 'value8' }
  #   data.rh_get(:arr2, 1, :test7)     # => 'value7'
  #   data.rh_get(:arr2, 0, :test7)     # => nil
  #
  # New features: 0.1.3
  #
  #   Introduce ERB context rh_get/exist?/lexist? functions:
  #     ERB can be used to select a subhash or extract a key.
  #
  #     - ERB Selection
  #       The ERB selection is detected by a string containing
  #       '<%= ... %>|something'
  #       The ERB code must return a boolean or 'true' to consider the current
  #       data context as queriable with a key.
  #       'something' can be any key (string, symbol or even an ERB extraction)
  #     - ERB Extraction
  #       The ERB selection is detected by a string containing simply
  #       '<%= ... %>'
  #       The result of that ERB call should return a string which will become a
  #       key to extract data from the current data context.
  #
  #       NOTE! ERB convert any symbol using to_s. If you need to get a key as a
  #       symbol, you will to add : in front of the context string:
  #
  #       Ex:
  #         RhContext.context = :test
  #         data.rh_get('<%= context =>') # is equivalent to data.rh_get('test')
  #
  #         RhContext.context = ':test'
  #         data.rh_get('<%= context =>') # is equivalent to data.rh_get(:test)
  #
  #     The ERB context by default contains:
  #     - at least a 'data' attribute. It contains the current Hash/Array
  #       level data in the data structure hierarchy.
  #     - optionally a 'context' attribute. Contains any kind of data.
  #       This is typically set before any call to rh_* functions.
  #
  #     you can introduce more data in the context, by creating a derived class
  #     from RhContext.ERBConfig. This will ensure attribute data/context exist
  #     in the context.
  #     Ex:
  #
  #         class MyContext < RhContext::ERBConfig
  #           attr_accessor :config # Added config in context
  #         end
  #
  #         RhContext.erb = MyContext.new
  #         RhContext.erb.config = my_config
  #         data.rh_get(...)
  #
  #     data = YAML.parse("---
  #     :test:
  #       :test2: value1
  #       :test3: value2
  #     :test4: value3
  #     :arr1: [ 4, value4]
  #     :arr2:
  #     - :test5: value5
  #       :test6: value6
  #     - :test7: value7
  #       :test8
  #       :test5: value8
  #     - :test5: value9")
  #
  #     # Default context:
  #     RhContext.erb = nil
  #     # Filtering using |
  #     data.rh_get(:arr2, '<%= data.key?(:test8) %>|:test5')
  #       # => ['value8']
  #     RhContext.context = :test6
  #     data.rh_get(:arr2, '<%= context %>')
  #       # => ['value6']
  #
  #   Introduce Array extraction (Fixnum and Range)
  #   When a data at a current level is an Array, get/exist?/lexist? interpret
  #   - the string '=[<Fixnum|Range>]' where
  #     - Fixnum : From found result, return the content of result[<Fixnum>]
  #       => subhash data found. It can return nil
  #     - Range : From found result, return the Range context of result[<Range>]
  #       => Array of (subhash data found)
  #    - the Range. complete the Array index selection.
  #      ex: [:test1, {:test2 => :value1}].rh_get(0..1, :test2)
  #
  #     # data extraction. By default:
  #     # data.rh_get(:arr2, :test5) return ['value5', 'value8', 'value9']
  #     # then
  #     data.rh_get(:arr2, '=[0]', :test5)    # => 'value5'
  #     data.rh_get(:arr2, '=[0..1]', :test5) # => ['value5', 'value8']
  #     data.rh_get(:arr2, '=[0..3]', :test5) # => ['value5', 'value8','value9']
  #
  #     # Data selection:
  #     data.rh_get(:arr2, 0..1, :test5)      # => ['value5', 'value8']
  #     data.rh_get(:arr2, 1..2, :test5)      # => ['value8', 'value9']
  def rh_get(*p)
    p = p.flatten
    return self if p.length == 0

    key = p[0]
    sp = p.drop(1)

    selected, key = _erb_select(key)
    return nil unless selected

    key = _erb_extract(key)

    re, res, opts = _regexp(key)
    return _keys_match(re, res, sp, opts) unless re.nil?

    if sp.length == 0
      return self[key] if self.key?(key)
      return nil
    end

    return self[key].rh_get(*sp) if [Array, Hash].include?(self[key].class)
    nil
  end

  # Recursive Hash Set
  # This function will build a recursive hash according to the '*p' key tree.
  # if yVal is not nil, it will be updated.
  #
  # * *Args* :
  #   - +p+    : Array of string or symbols. keys tree to follow and check
  #              existence in yVal.
  #
  # * *Returns* :
  #   - +value+ : the value set.
  #
  # * *Raises* :
  #   No exceptions
  #
  # Example:(implemented in spec)
  #
  #   data = {}.rh_set(:test)            # => {}
  #
  #   data.rh_set(:test, :test2)         # => {:test2 => :test}
  #
  #   data.rh_set(:test, :test2, :test5) # => {:test2 => {:test5 => :test} }
  #
  #   data.rh_set(:test, :test5 )        # => {:test2 => {:test5 => :test},
  #                                      #     :test5 => :test }
  #
  #   data.rh_set('blabla', :test2, 'text')
  #                                      # => {:test2 => {:test5 => :test,
  #                                      #                'text' => 'blabla'},
  #                                      #     :test5 => :test }
  def rh_set(value, *p)
    p = p.flatten
    return nil if p.length == 0

    if p.length == 1
      self[p[0]] = value
      return value
    end

    self[p[0]] = {} unless self[p[0]].is_a?(Hash)
    self[p[0]].rh_set(value, p.drop(1))
  end

  # Recursive Hash delete
  # This function will remove the last key defined by the key tree
  #
  # * *Args* :
  #   - +p+    : Array of string or symbols. keys tree to follow and check
  #              existence in self.
  #
  # * *Returns* :
  #   - +value+ : The Hash updated.
  #
  # * *Raises* :
  #   No exceptions
  #
  # Example:(implemented in spec)
  #
  #   data = {{:test2 => { :test5 => :test,
  #                        'text' => 'blabla' },
  #            :test5 => :test}}
  #
  #   data.rh_del(:test)          # => nil
  #                               # data = no change
  #
  #   data.rh_del(:test, :test2)  # => nil
  #                               # data = no change
  #
  #   data.rh_del(:test2, :test5) # => {:test5 => :test}
  #                               # data = { :test2 => { 'text' => 'blabla' },
  #                               #          :test5 => :test} }
  #
  #   data.rh_del(:test2, 'text') # => { 'text' => 'blabla' }
  #                               # data = { :test2 => {},
  #                               #          :test5 => :test} }
  #
  #   data.rh_del(:test5)         # => {:test5 => :test}
  #                               # data = { :test2 => {} }
  #
  def rh_del(*p)
    p = p.flatten

    return nil if p.length == 0

    return delete(p[0]) if p.length == 1

    return nil if self[p[0]].nil?
    self[p[0]].rh_del(p.drop(1))
  end

  # Move levels (default level 1) of tree keys to become symbol.
  #
  # * *Args*    :
  #   - +levels+: level of key tree to update.
  # * *Returns* :
  #   - a new hash of hashes updated. Original Hash is not updated anymore.
  #
  # examples:
  #   With hdata = { :test => { :test2 => { :test5 => :test,
  #                                         'text' => 'blabla' },
  #                             'test5' => 'test' }}
  #
  #  hdata.rh_key_to_symbol(1) return no diff
  #  hdata.rh_key_to_symbol(2) return "test5" is replaced by :test5
  #  # hdata = { :test => { :test2 => { :test5 => :test,
  #  #                                  'text' => 'blabla' },
  #  #                      :test5 => 'test' }}
  #  rh_key_to_symbol(3) return "test5" replaced by :test5, and "text" to :text
  #  # hdata = { :test => { :test2 => { :test5 => :test,
  #  #                                  :text => 'blabla' },
  #  #                      :test5 => 'test' }}
  #  rh_key_to_symbol(4) same like rh_key_to_symbol(3)

  def rh_key_to_symbol(levels = 1)
    result = {}
    each do |key, value|
      new_key = key
      new_key = key.to_sym if key.is_a?(String)
      if value.is_a?(Hash) && levels > 1
        value = value.rh_key_to_symbol(levels - 1)
      end
      result[new_key] = value
    end
    result
  end

  # Check if levels of tree keys are all symbols.
  #
  # * *Args*    :
  #   - +levels+: level of key tree to update.
  # * *Returns* :
  #   - true  : one key path is not symbol.
  #   - false : all key path are symbols.
  # * *Raises* :
  #   Nothing
  #
  # examples:
  #   With hdata = { :test => { :test2 => { :test5 => :test,
  #                                         'text' => 'blabla' },
  #                             'test5' => 'test' }}
  #
  #  hdata.rh_key_to_symbol?(1) return false
  #  hdata.rh_key_to_symbol?(2) return true
  #  hdata.rh_key_to_symbol?(3) return true
  #  hdata.rh_key_to_symbol?(4) return true
  def rh_key_to_symbol?(levels = 1)
    each do |key, value|
      return true if key.is_a?(String)

      res = false
      if levels > 1 && value.is_a?(Hash)
        res = value.rh_key_to_symbol?(levels - 1)
      end
      return true if res
    end
    false
  end

  # return an exact clone of the recursive Array and Hash contents.
  #
  # * *Args*    :
  #
  # * *Returns* :
  #   - Recursive Array/Hash cloned. Other kind of objects are kept referenced.
  # * *Raises* :
  #   Nothing
  #
  # examples:
  #  hdata = { :test => { :test2 => { :test5 => :test,
  #                                   'text' => 'blabla' },
  #                       'test5' => 'test' },
  #            :array => [{ :test => :value1 }, 2, { :test => :value3 }]}
  #
  #  hclone = hdata.rh_clone
  #  hclone[:test] = "test"
  #  hdata[:test] == { :test2 => { :test5 => :test,'text' => 'blabla' }
  #  # => true
  #  hclone[:array].pop
  #  hdata[:array].length != hclone[:array].length
  #  # => true
  #  hclone[:array][0][:test] = "value2"
  #  hdata[:array][0][:test] != hclone[:array][0][:test]
  #  # => true
  def rh_clone
    result = {}
    each do |key, value|
      if [Array, Hash].include?(value.class)
        result[key] = value.rh_clone
      else
        result[key] = value
      end
    end
    result
  end

  # Merge the current Hash object (self) cloned with a Hash/Array tree contents
  # (data).
  #
  # 'self' is used as original data to merge to.
  # 'data' is used as data to merged to clone of 'self'. If you want to update
  # 'self', use rh_merge!
  #
  # if 'self' or 'data' contains a Hash tree, the merge will be executed
  # recursively.
  #
  # The current function will execute the merge of the 'self' keys with the top
  # keys in 'data'
  #
  # The merge can be controlled by an additionnal Hash key '__*' in each
  # 'self' key.
  # If both a <key> exist in 'self' and 'data', the following decision is made:
  # - if both 'self' and 'data' key contains an Hash or and Array, a recursive
  #   merge if Hash or update if Array, is started.
  #
  # - if 'self' <key> contains an Hash or an Array, but not 'data' <key>, then
  #   'self' <key> will be set to the 'data' <key> except if 'self' <Key> has
  #   :__struct_changing: true
  #   data <key> value can set :unset value
  #
  # - if 'self' <key> is :unset and 'data' <key> is any value
  #   'self' <key> value is set with 'data' <key> value.
  #   'data' <key> value can contains a Hash with :__no_unset: true to
  #     protect this key against the next merge. (next config layer merge)
  #
  # - if 'data' <key> exist but not in 'self', 'data' <key> is just added.
  #
  # - if 'data' & 'self' <key> exist, 'self'<key> is updated except if key is in
  #   :__protected array list.
  #
  # * *Args*    :
  #   - hash : Hash data to merge.
  #
  # * *Returns* :
  #   - Recursive Array/Hash merged.
  #
  # * *Raises* :
  #   Nothing
  #
  # examples:
  #
  def rh_merge(data)
    _rh_merge(clone, data)
  end

  # Merge the current Hash object (self) with a Hash/Array tree contents (data).
  #
  # For details on this functions, see #rh_merge
  #
  def rh_merge!(data)
    _rh_merge(self, data)
  end
end

# Recursive Hash added to the Hash class
class Hash
  private

  def _keys_match_lexist(re, res, sp, _opts)
    _keys_match_loop_lexist(re, res, sp)

    return res.max if res.length > 0
    0
  end

  def _keys_match_loop_lexist(re, res, sp)
    keys.sort.each do |k|
      k_re = _key_to_s(k)
      next unless re.match(k_re)

      if sp.length == 0
        res << 1
      else
        if [Array, Hash].include?(self[k].class)
          res << 1 + self[k].rh_lexist?(sp)
        end
      end
    end
  end

  def _keys_match(re, res, sp, opts)
    empty = false
    empty = opts.include?('e') if opts

    _keys_match_loop(re, res, sp)

    return res if empty || res.length > 0
    nil
  end

  def _keys_match_loop(re, res, sp)
    keys.sort.each do |k|
      k_re = _key_to_s(k)
      next unless re.match(k_re)

      if sp.length == 0
        _update_res(res, k, self[k])
      else
        v = self[k].rh_get(sp) if [Array, Hash].include?(self[k].class)

        _update_res(res, k, v) unless v.nil?
      end
    end
  end

  # Internal function which do the real merge task by #rh_merge and #rh_merge!
  #
  # See #rh_merge for details
  #
  def _rh_merge(result, data)
    return _rh_merge_choose_data(result, data) unless data.is_a?(Hash)

    data.each do |key, _value|
      next if [:__struct_changing, :__protected].include?(key)

      _do_rh_merge(result, key, data)
    end
    [:__struct_changing, :__protected].each do |key|
      # Refuse merge by default if key data type are different.
      # This assume that the first layer merge has set
      # :__unset as a Hash, and :__protected as an Array.

      _do_rh_merge(result, key, data, true) if data.key?(key)

      # Remove all control element in arrays
      _rh_remove_control(result[key]) if result.key?(key)
    end

    result
  end

  def _rh_merge_choose_data(result, data)
    # return result as first one impose the type between Hash/Array.
    return result if [Hash, Array].include?(result.class) ||
                     [Hash, Array].include?(data.class)

    data
  end
  # Internal function to execute the merge on one key provided by #_rh_merge
  #
  # if refuse_discordance is true, then result[key] can't be updated if
  # stricly not of same type.
  def _do_rh_merge(result, key, data, refuse_discordance = false)
    value = data[key]

    return if _rh_merge_do_add_key(result, key, value)

    return if _rh_merge_recursive(result, key, data)

    return if refuse_discordance

    return unless _rh_struct_changing_ok?(result, key, data)

    return unless _rh_merge_ok?(result, key)

    _rh_merge_do_upd_key(result, key, value)
  end

  def _rh_merge_do_add_key(result, key, value)
    unless result.key?(key) || value == :unset
      result[key] = value # New key added
      return true
    end
    false
  end

  def _rh_merge_do_upd_key(result, key, value)
    if value == :unset
      result.delete(key) if result.key?(key)
      return
    end

    result[key] = value # Key updated
  end

  include Rh
  include RhGet
end
