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

# Defines rh_clone for Array
class Array
  # Recursive Hash deep level found counter
  # See details from #Hash.rh_lexist?
  def rh_lexist?(*p)
    p = p.flatten

    return 0 if p.length == 0

    key = p[0]
    sp = p.drop(1)

    return _lexist_array(sp, key) if key.is_a?(Fixnum)

    _loop_lexist_array(sp, key)
  end

  # Recursive Hash deep level existence
  # See details at #Hash.rh_exist?
  def rh_exist?(*p)
    p = p.flatten

    return nil if p.length == 0

    count = p.length
    (rh_lexist?(*p) == count)
  end

  # Recursive Hash Get
  # Please look to #Hash::rh_get for details about this function.
  def rh_get(*p)
    p = p.flatten
    return self if p.length == 0

    key = p[0]
    sp = p.drop(1)

    re, res, opts = _regexp(key)
    return _keys_match(re, res, sp, opts) unless re.nil?

    return _get_array(sp, key) if key.is_a?(Fixnum)

    _loop_get_array(sp, key)
  end

  # return an exact clone of the recursive Array and Hash contents.
  #
  # * *Args*    :
  #
  # * *Returns* :
  #   - Recursive Array/Hash cloned.
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
    result = []
    each do |value|
      begin
        result << value.rh_clone
      rescue
        result << value
      end
    end
    result
  end

  # This function is part of the rh_merge functionnality adapted for Array.
  #
  # To provide Array recursivity, we uses the element index.
  #
  # **Warning!** If the Array order has changed (sort/random) the index changed
  # and can generate unwanted result.
  #
  # To implement recursivity, and some specific Array management (add/remove)
  # you have to create an Hash and insert it at position 0 in the 'self' Array.
  #
  # **Warning!** If you create an Array, where index 0 contains a Hash, this
  # Hash will be considered as the Array control element.
  # If the first index of your Array is not a Hash, an empty Hash will be
  # inserted at position 0.
  #
  # 'data' has the same restriction then 'self' about the first element.
  # 'data' can influence the rh_merge Array behavior, by updating the first
  # element.
  #
  # The first Hash element has the following attributes:
  #
  # - :__struct_changing: Array of index which accepts to move from a structured
  #   data (Hash/Array) to another structure or type.
  #
  #   Ex: Hash => Array, Array => Integer
  #
  # - :__protected: Array of index which protects against update from 'data'
  #
  # - :__remove: Array of elements to remove. each element are remove with
  #   Array.delete function. See Array delete function for details.
  #
  # - :__remove_index: Array of indexes to remove.
  #   Each element are removed with Array.delete_at function.
  #   It starts from the highest index until the lowest.
  #   See Array delete function for details.
  #
  # **NOTE**: __remove and __remove_index cannot be used together.
  #   if both are set, __remove is choosen
  #
  # **NOTE** : __remove* is executed before __add*
  #
  # - :__add: Array of elements to add. Those elements are systematically added
  #   at the end of the Array. See Array.<< for details.
  #
  # - :__add_index: Hash of index(key) + Array of data(value) to add.
  #   The index listed refer to merged 'self' Array. several elements with same
  #   index are grouply inserted in the index.
  #   ex:
  #     [:data3].rh_merge({:__add_index => [0 => [:data1, :data2]]})
  #     => [{}, :data1, :data2, :data3]
  #
  # **NOTE**: __add and __add_index cannot be used together.
  #   if both are set, __add is choosen
  #
  # How merge is executed:
  #
  # Starting at index 0, each index of 'data' and 'self' are used to compare
  # indexed data.
  # - If 'data' index 0 has not an Hash, the 'self' index 0 is just skipped.
  # - If 'data' index 0 has the 'control' Hash, the array will be updated
  #   according to :__add and :__remove arrays.
  #   when done, those attributes are removed
  #
  # - For all next index (1 => 'data'.length), data are compared
  #
  #   - If the 'data' length is >  than 'self' length
  #     addtionnal indexed data are added to 'self'
  #
  #   - If index element exist in both 'data' and 'self',
  #     'self' indexed data is updated/merged according to control.
  #     'data' indexed data can use :unset to remove the data at this index
  #     nil is also supported. But the index won't be removed. data will just
  #     be set to nil
  #
  # when all Arrays elements are merged, rh_merge will:
  # - remove 'self' elements containing ':unset'
  #
  # - merge 'self' data at index 0 with 'data' found index 0
  #
  def rh_merge(data)
    _rh_merge(clone, data)
  end

  def rh_merge!(data)
    _rh_merge(self, data)
  end
end

# Defines structure feature for Array object.
class Array
  private

  # Loop in array
  def _loop_get_array(sp, key)
    ret = []
    each do |e|
      next unless e.is_a?(Hash)
      next unless e.key?(key)

      if sp.length == 0
        ret << e[key]
      else
        ret << e[key].rh_get(sp) if [Array, Hash].include?(e[key].class)
      end
    end
    return ret if ret.length > 0
    nil
  end

  # Index provided. return the value of the index.
  def _get_array(sp, key)
    return self[key] if sp.length == 0

    self[key].rh_get(sp) if [Array, Hash].include?(self[key].class)
  end

  def _lexist_array(sp, key)
    return 0 unless key >= 0 && key < length
    return 1 if sp.length == 0

    1 + self[key].rh_lexist?(sp) if [Array, Hash].include?(self[key].class)
  end

  def _loop_lexist_array(sp, key)
    ret = []
    each do |e|
      next unless e.is_a?(Hash)
      next unless e.key?(key)

      if sp.length == 0
        ret << 1
      else
        res = 1
        res += e[key].rh_lexist?(sp) if [Array, Hash].include?(e[key].class)
        ret << res
      end
    end
    ret.length > 0 ? ret.max : 0
  end

  def _keys_match(re, res, sp, opts)
    empty = false
    empty = opts.include?('e') if opts

    each do |e|
      next unless e.is_a?(Hash)

      _keys_match_hash(re, res, sp, e)
    end
    return res if empty || res.length > 0
    nil
  end

  def _keys_match_hash(re, res, sp, e)
    e.keys.sort.each do |k|
      k_re = _key_to_s(k)
      next unless re.match(k_re)

      if sp.length == 0
        _update_res(res, k, e[k])
      else
        v = e[k].rh_get(sp) if [Array, Hash].include?(e[k].class)

        _update_res(res, k, v) unless v.nil?
      end
    end
    res
  end

  def _rh_merge(result, data)
    data = data.clone
    data_control = _rh_merge_control(data)
    result_control = _rh_merge_control(result)

    _rh_do_control_merge(result_control, result, data_control, data)

    (1..(data.length - 1)).each do |index|
      _rh_do_array_merge(result, index, data)
    end

    (-(result.length - 1)..-1).each do |index|
      result.delete_at(index.abs) if result[index.abs] == :unset
    end

    _rh_do_array_merge(result, 0, [data_control])
    # Remove all control elements in tree of arrays
    _rh_remove_control(result[0])

    result
  end

  def _rh_do_array_merge(result, index, data)
    return if _rh_merge_recursive(result, index, data)

    return unless _rh_struct_changing_ok?(result, index, data)

    return unless _rh_merge_ok?(result, index)

    result[index] = data[index] unless data[index] == :kept
  end

  #  Get the control element. or create it if missing.
  def _rh_merge_control(array)
    unless array[0].is_a?(Hash)
      array.insert(0, :__control => true)
      return array[0]
    end

    _rh_control_tags.each do |prop|
      if array[0].key?(prop)
        array[0][:__control] = true
        return array[0]
      end
    end

    array.insert(0, :__control => true)

    array[0]
  end

  # Do the merge according to :__add and :__remove
  def _rh_do_control_merge(_result_control, result, data_control, _data)
    if data_control[:__remove].is_a?(Array)
      _rh_do_control_remove(result, data_control[:__remove])
    elsif data_control[:__remove_index].is_a?(Array)
      index_to_remove = data_control[:__remove_index].uniq.sort.reverse
      _rh_do_control_remove_index(result, index_to_remove)
    end

    data_control.delete(:__remove)
    data_control.delete(:__remove_index)

    if data_control[:__add].is_a?(Array)
      data_control[:__add].each { |element| result << element }
    elsif data_control[:__add_index].is_a?(Hash)
      _rh_do_control_add_index(result, data_control[:__add_index].sort)
    end

    data_control.delete(:__add)
    data_control.delete(:__add_index)
  end

  def _rh_do_control_add_index(result, add_index)
    add_index.reverse_each do |elements_to_insert|
      next unless elements_to_insert.is_a?(Array) &&
                  elements_to_insert[0].is_a?(Fixnum) &&
                  elements_to_insert[1].is_a?(Array)

      index = elements_to_insert[0] + 1
      elements = elements_to_insert[1]

      elements.reverse_each { |element| result.insert(index, element) }
    end
  end

  # do the element removal.
  def _rh_do_control_remove(result, remove)
    remove.each { |element| result.delete(element) }
  end

  def _rh_do_control_remove_index(result, index_to_remove)
    index_to_remove.each { |index| result.delete_at(index + 1) }
  end

  include Rh
  include RhGet
end
