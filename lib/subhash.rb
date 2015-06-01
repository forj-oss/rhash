#!/usr/bin/env ruby
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

require 'rubygems'
require 'yaml'
require 'rh'
require 'ihash'
require 'iarray'

# Adding rh_clone at object level. This be able to use a generic rh_clone
# redefined per object Hash and Array.
class Object
  alias_method :rh_clone, :clone
end

if RUBY_VERSION.match(/1\.8/)
  # Added missing <=> function in Symbol of ruby 1.8
  class Symbol
    def <=>(other)
      return to_s <=> other if other.is_a?(String)
      to_s <=> other.to_s
    end
  end
end
