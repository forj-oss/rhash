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

# Recursive Hash context
module RhContext
  # Module attributes
  class << self
    attr_accessor :erb
  end

  # ERBConfig context for subhash selection, or filter
  class ERBConfig
    attr_accessor :data
    attr_accessor :context

    # Bind this limited class with ERB templates
    def get_binding # rubocop: disable AccessorMethodName
      binding
    end
  end

  module_function

  def get(str)
    return str if @erb.nil?
    ERB.new(str).result(@erb.get_binding)
  end

  def data=(data)
    @erb = ERBConfig.new if @erb.nil?

    @erb.data = data
  rescue
    return
  end

  def context=(data)
    @erb = ERBConfig.new if @erb.nil?

    @erb.context = data
  rescue
    return
  end
end

# Rh common module included in Hash and Array class.
module Rh
  public

  def merge_cleanup!
    _rh_remove_control(self)
  end

  def merge_cleanup
    _rh_remove_control(rh_clone)
  end

  def structured?
    true
  end

  private

  # Return the erb call return
  # true otherwise ie Selected by default.
  def _erb_select(key)
    found = _erb_select_found(key)
    return true, key unless found

    RhContext.data = self

    key = key.clone
    key[found[0]] = ''
    [RhContext.get(found[1]) == 'true', _convert_key(key)]
  end

  def _erb_select_found(key)
    return false unless key.is_a?(String) && key =~ /^<%=.*%>([0-9a-z]*)?\|/

    /^(<%=.*%>)([0-9a-z]*)?\|/.match(key)
  end

  def _erb_extract(key)
    return key unless key.is_a?(String) && key =~ /^<%=.*%>[^|]?/
    RhContext.data = self

    _convert_key(RhContext.get(key))
  end

  def _convert_key(key)
    return key unless key.is_a?(String)
    # Ruby 1.8   : 'ab'[1] => 98 and 'ab'[1, 1] => 'b'
    # Ruby 1.9+  : 'ab'[1] => 'b' and 'ab'[1, 1] => 'b'
    return key[1..-1].to_sym if key[0, 1] == ':'
    key
  end

  # Function which will parse arrays in hierarchie and will remove any control
  # element (index 0)
  def _rh_remove_control(result)
    return unless [Hash, Array].include?(result.class)

    if result.is_a?(Hash)
      result.each { |elem| _rh_remove_control(elem) }
    else
      result.delete_at(0) if result[0].is_a?(Hash) && result[0].key?(:__control)
      result.each_index { |index| _rh_remove_control(result[index]) }
    end
    result
  end

  # Internal function to determine if result and data key contains both Hash or
  # Array and if so, do the merge task on those sub Hash/Array
  #
  def _rh_merge_recursive(result, key, data)
    return false unless [Array, Hash].include?(data.class)

    value = data[key]
    return false unless [Array, Hash].include?(value.class) &&
                        value.class == result[key].class

    if object_id == result.object_id
      result[key].rh_merge!(value)
    else
      result[key] = result[key].rh_merge(value)
    end

    true
  end

  # Internal function to determine if changing from Hash/Array to anything else
  # is authorized or not.
  #
  # The structure is changing if `result` or `value` move from Hash/Array to any
  # other type.
  #
  # * *Args*:
  #   - result: Merged Hash or Array structure.
  #   - key   : Key in result and data.
  #   - data  : Hash or Array structure to merge.
  #
  # * *returns*:
  #   - +true+  : if :__struct_changing == true
  #   - +false+ : otherwise.
  def _rh_struct_changing_ok?(result, key, data)
    return true unless [Array, Hash].include?(data[key].class) ||
                       [Array, Hash].include?(result[key].class)

    # result or value are structure (Hash or Array)
    if result.is_a?(Hash)
      control = result[:__struct_changing]
    else
      control = result[0][:__struct_changing]
      key -= 1
    end
    return true if control.is_a?(Array) && control.include?(key)

    false
  end

  # Internal function to determine if a data merged can be updated by any
  # other object like Array, String, etc...
  #
  # The decision is given by a :__unset setting.
  #
  # * *Args*:
  #   - Hash/Array data to replace.
  #   - key: string or symbol.
  #
  # * *returns*:
  #   - +false+ : if key is found in :__protected Array.
  #   - +true+ : otherwise.
  def _rh_merge_ok?(result, key)
    if result.is_a?(Hash)
      control = result[:__protected]
    else
      control = result[0][:__protected]
      key -= 1
    end

    return false if control.is_a?(Array) && control.include?(key)

    true
  end

  def _rh_control_tags
    [:__remove, :__remove_index, :__add, :__add_index,
     :__protected, :__struct_changing, :__control]
  end
end

# Module to implement common function for Hash and Array class
module RhGet
  def _regexp(key)
    return [key, [], nil] if key.is_a?(Regexp)
    return [nil, nil, nil] unless key.is_a?(String)

    regs = []
    regs << [%r{^/(.*)/([e0])*$},     []]
    regs << [%r{^\[/(.*)/([e0])*\]$}, []]
    regs << [%r{^\{/(.*)/([e0])*\}$}, {}]

    _loop_on_regs(regs, key)
  end

  def _key_options(opts)
    empty = false
    empty = opts.include?('e') if opts
    one = false
    one = opts.include?('0') if opts
    [empty, one]
  end

  def _loop_on_regs(regs, key)
    regs.each do |r|
      init = r[1]
      reg = r[0].match(key)
      return [Regexp.new(reg[1]), init, reg[2]] if reg && reg[1]
    end
    [nil, nil, nil]
  end

  def _key_to_s(k)
    return ':' + k.to_s if k.is_a?(Symbol)
    k
  end

  def _update_res(res, k, v, one)
    res << v   if res.is_a?(Array)
    return unless res.is_a?(Hash)
    if one && v.is_a?(Array) && v.length == 1
      res[k] = v[0]
    else
      res[k] = v
    end
  end
end

# By default all object are considered as unstructured, ie not Hash or Array.
class Object
  def structured?
    false
  end
end
