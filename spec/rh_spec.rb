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

#  require 'byebug'
require 'rubygems'
#  require 'ruby-debug' ; Debugger.start

$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')

require 'subhash'

describe 'Recursive Hash/Array extension,' do
  context "With { :test => {:test2 => 'value1', :test3 => 'value2'},"\
          ":test4 => 'value3'}" do
    before(:all) do
      @hdata = { :test => { :test2 => 'value1', :test3 => 'value2' },
                 :test4 => 'value3' }
    end

    it 'rh_lexist?(:test) '"\n    => "' 1' do
      expect(@hdata.rh_lexist?(:test)).to eq(1)
    end

    it 'rh_lexist?(:test5) '"\n    => "' 0' do
      expect(@hdata.rh_lexist?(:test5)).to eq(0)
    end

    it 'rh_lexist?(:test, :test2) '"\n    => "' 2' do
      expect(@hdata.rh_lexist?(:test, :test2)).to eq(2)
    end

    it 'rh_lexist?(:test, :test2, :test5) '"\n    => "' 2' do
      expect(@hdata.rh_lexist?(:test, :test2, :test5)).to eq(2)
    end

    it 'rh_lexist?(:test, :test5 ) '"\n    => "' 1' do
      expect(@hdata.rh_lexist?(:test, :test5)).to eq(1)
    end

    it 'rh_lexist? '"\n    => "' 0' do
      expect(@hdata.rh_lexist?).to eq(0)
    end
  end

  context "With { :test => [{ :test2 => 'value1', :test6 => 'value6'},"\
          " { :test3 => 'value2' },"\
          " { :test4 => { :test5 => 'value3' } }] }" do
    before(:all) do
      @hdata = { :test => [{ :test2 => 'value1', :test6 => 'value6' },
                           { :test3 => 'value2' },
                           { :test4 => { :test5 => 'value3' } }] }
    end

    it 'rh_lexist?(:test) '"\n    => "' 1' do
      expect(@hdata.rh_lexist?(:test)).to eq(1)
    end

    it 'rh_lexist?(:test5) '"\n    => "' 0' do
      expect(@hdata.rh_lexist?(:test5)).to eq(0)
    end

    it 'rh_lexist?(:test, :test2) '"\n    => "' 2' do
      expect(@hdata.rh_lexist?(:test, :test2)).to eq(2)
    end

    it 'rh_lexist?(:test, :test2, :test5) '"\n    => "' 2' do
      expect(@hdata.rh_lexist?(:test, :test2, :test5)).to eq(2)
    end

    it 'rh_lexist?(:test, :test4, :test5 ) '"\n    => "' 3' do
      expect(@hdata.rh_lexist?(:test, :test4, :test5)).to eq(3)
    end

    it 'rh_lexist?(:test, :test4, :test5, :test6 ) '"\n    => "' 3' do
      expect(@hdata.rh_lexist?(:test, :test4, :test5, :test6)).to eq(3)
    end

    it "rh_lexist?('{/:test/}', :test ) \n    =>  1" do
      expect(@hdata.rh_lexist?('{/:test/}', :test)).to eq(1)
    end

    it "rh_lexist?(:test, '{/:test5/}' ) \n    =>  1" do
      expect(@hdata.rh_lexist?(:test, '{/:test5/}')).to eq(1)
    end

    it "rh_lexist?(:test, '{/:test4/}', :test5 ) \n    =>  3" do
      expect(@hdata.rh_lexist?(:test, '{/:test4/}', :test5)).to eq(3)
    end

    it "rh_lexist?(:test, '[/:test4/]', :test5 ) \n    =>  3" do
      expect(@hdata.rh_lexist?(:test, '[/:test4/]', :test5)).to eq(3)
    end

    it 'rh_lexist?(:test, :test2, :test5, :test6 ) '"\n    => "' 2' do
      expect(@hdata.rh_lexist?(:test, :test2, :test5, :test6)).to eq(2)
    end

    it 'rh_lexist?(:test, 3 ) '"\n    => "' 1' do
      expect(@hdata.rh_lexist?(:test, 3)).to eq(1)
    end

    it 'rh_lexist?(:test, 0 ) '"\n    => "' 2' do
      expect(@hdata.rh_lexist?(:test, 0)).to eq(2)
    end

    it 'rh_lexist?(:test, 0, :test2) '"\n    => "' 3' do
      expect(@hdata.rh_lexist?(:test, 0, :test2)).to eq(3)
    end

    it 'rh_lexist?(:test, 2, :test4, :test5) '"\n    => "' 4' do
      expect(@hdata.rh_lexist?(:test, 2, :test4, :test5)).to eq(4)
    end

    it 'rh_lexist?(:test, 2, :test4, :test5) '"\n    => "' 4' do
      expect(@hdata.rh_lexist?(:test, 0..1, :test4, :test5)).to eq(2)
    end

    it 'rh_lexist?(:test, 2, :test4, :test5) '"\n    => "' 4' do
      expect(@hdata.rh_lexist?(:test, 0..2, :test4, :test5)).to eq(4)
    end

    it "rh_lexist?(//) \n    => 1" do
      expect(@hdata.rh_lexist?(//)).to eq(1)
    end

    it "rh_lexist?(:test, /test[23]/) \n    => 2" do
      expect(@hdata.rh_lexist?(:test, /test[23]/)).to eq(2)
    end

    it "rh_lexist?(:test, /test[23]/, :test5) \n    => 2" do
      expect(@hdata.rh_lexist?(:test, /test[23]/, :test5)).to eq(2)
    end

    it "rh_lexist?(:test, /test/, :test5) \n    => 3" do
      expect(@hdata.rh_lexist?(:test, /test/, :test5)).to eq(3)
    end

    it "rh_lexist?(:test, '<%= data[:test6] == \"value5\" %>|:test2') "\
       "\n    => 1" do
      expect(@hdata.rh_lexist?(:test, '<%= data[:test6] == "value5" %>|'\
                                      ':test2')).to eq(1)
    end

    it "rh_lexist?(:test, '<%= data[:test6] == \"value6\" %>|:test2') "\
       "\n    => 2" do
      expect(@hdata.rh_lexist?(:test, '<%= data[:test6] == "value6" %>|'\
                                      ':test2')).to eq(2)
    end

    it "with RhContext.context = ':test1', rh_lexist?(:test, '<%= context %>')"\
       "\n    => 1" do
      RhContext.context = ':test1'
      expect(@hdata.rh_lexist?(:test, '<%= context %>')).to eq(1)
    end

    it "with RhContext.context = ':test2', rh_lexist?(:test, '<%= context %>')"\
       "\n    => 2" do
      RhContext.context = ':test2'
      expect(@hdata.rh_lexist?(:test, '<%= context %>')).to eq(2)
    end

    it 'rh_lexist? '"\n    => "' 0' do
      expect(@hdata.rh_lexist?).to eq(0)
    end
  end

  context "With { :test => {:test2 => 'value1', :test3 => 'value2'},"\
                           ":test4 => 'value3',"\
                           ":test5 => [{ :test6 => 'value6',"\
                                        ":test7 => {:test9 => 'value7'} },"\
                                      "{ :test8 => 'value8' },"\
                                      "{ :test10 => 'value10' }] }" do
    before(:all) do
      @hdata = { :test => { :test2 => 'value1', :test3 => 'value2' },
                 :test4 => 'value3',
                 :test5 => [{ :test6 => 'value6',
                              :test7 => { :test9 => 'value7' } },
                            { :test8 => 'value8' },
                            { :test10 => 'value10' }] }
    end

    it 'rh_exist?(:test) '"\n    => "' true' do
      expect(@hdata.rh_exist?(:test)).to equal(true)
    end

    it 'rh_exist?(:test6) '"\n    => "' false' do
      expect(@hdata.rh_exist?(:test6)).to equal(false)
    end

    it 'rh_exist?(:test, :test2) '"\n    => "' true' do
      expect(@hdata.rh_exist?(:test, :test2)).to equal(true)
    end

    it 'rh_exist?(:test, :test2, :test5) '"\n    => "' false' do
      expect(@hdata.rh_exist?(:test, :test2, :test5)).to equal(false)
    end

    it 'rh_exist?(:test, :test5 ) '"\n    => "' false' do
      expect(@hdata.rh_exist?(:test, :test5)).to equal(false)
    end

    it "rh_exist?(:test5, 3 ) \n    =>  false" do
      expect(@hdata.rh_exist?(:test5, 3)).to equal(false)
    end

    it "rh_exist?(:test5, 0 ) \n    =>  true" do
      expect(@hdata.rh_exist?(:test5, 0)).to equal(true)
    end

    it "rh_exist?(:test5, 0, :test6) \n    =>  true" do
      expect(@hdata.rh_exist?(:test5, 0, :test6)).to equal(true)
    end

    it "rh_exist?(:test5, 1, :test7, :test9) \n    =>  false" do
      expect(@hdata.rh_exist?(:test5, 1, :test7, :test9)).to equal(false)
    end

    it "rh_exist?(:test5, 0, :test7, :test9) \n    =>  true" do
      expect(@hdata.rh_exist?(:test5, 0, :test7, :test9)).to equal(true)
    end

    it "rh_exist?(:test5, 0..1, :test7, :test9) \n    =>  false" do
      expect(@hdata.rh_exist?(:test5, 0..1, :test7, :test9)).to equal(true)
    end

    it "rh_exist?(:test5, 1..2, :test7, :test9) \n    =>  false" do
      expect(@hdata.rh_exist?(:test5, 1..2, :test7, :test9)).to equal(false)
    end

    it "rh_exist?(:test5, /test[6-8]/) \n    => true" do
      expect(@hdata.rh_exist?(:test5, /test[6-8]/)).to equal(true)
    end

    it "rh_exist?(:test5, /test[6-8]/, :test9) \n    => true" do
      expect(@hdata.rh_exist?(:test5, /test[6-8]/, :test9)).to equal(true)
    end

    it "rh_exist?(:test5, /test[68]/, :test9) \n    => false" do
      expect(@hdata.rh_exist?(:test5, /test[68]/, :test9)).to equal(false)
    end

    it "rh_exist?(:test5, /test/, :test9) \n    => true" do
      expect(@hdata.rh_exist?(:test5, /test/, :test9)).to equal(true)
    end

    it "rh_exist?(:test5, '<%= data[:test6] == \"value5\" %>|:test7') "\
       "\n    => false" do
      expect(@hdata.rh_exist?(:test5, '<%= data[:test6] == "value5" %>|'\
                                      ':test7')).to equal(false)
    end

    it "rh_exist?(:test5, '<%= data[:test6] == \"value6\" %>|:test7') "\
       "\n    => true" do
      expect(@hdata.rh_exist?(:test5, '<%= data[:test6] == "value6" %>|'\
                                      ':test7')).to equal(true)
    end

    it "with RhContext.context = ':test1', rh_exist?(:test5, '<%= context %>')"\
       "\n    => false" do
      RhContext.context = ':test1'
      expect(@hdata.rh_exist?(:test5, '<%= context %>')).to equal(false)
    end

    it "with RhContext.context = ':test6', rh_exist?(:test5, '<%= context %>')"\
       "\n    => true" do
      RhContext.context = ':test6'
      expect(@hdata.rh_exist?(:test5, '<%= context %>')).to equal(true)
    end

    it 'rh_exist? '"\n    => "' nil' do
      expect(@hdata.rh_exist?).to eq(nil)
    end
  end

  context "With { :test => {:test2 => 'value1', :test3 => 'value2'},"\
          ":test4 => 'value3', :test6 => {:test2 => 'value4'}}" do
    before(:all) do
      @hdata = { :test => { :test2 => 'value1',
                            :test3 => 'value2' },
                 :test4 => 'value3',
                 :test6 => { :test2 => 'value4' } }
    end
    it "rh_get(:test) \n    => {:test2 => 'value1', :test3 => 'value2'}" do
      expect(@hdata.rh_get(:test)).to eq(:test2 => 'value1',
                                         :test3 => 'value2')
    end

    it 'rh_get(:test5) '"\n    => "' nil' do
      expect(@hdata.rh_get(:test5)).to equal(nil)
    end

    it "rh_get(:test, :test2) \n    => 'value1'" do
      expect(@hdata.rh_get(:test, :test2)).to eq('value1')
    end

    it 'rh_get(:test, :test2, :test5) '"\n    => "' nil' do
      expect(@hdata.rh_get(:test, :test2, :test5)).to equal(nil)
    end

    it 'rh_get(:test, :test5) '"\n    => "' nil' do
      expect(@hdata.rh_get(:test, :test5)).to equal(nil)
    end

    it 'rh_get '"\n    => "' original data' do
      expect(@hdata.rh_get).to eq(@hdata)
    end

    it 'rh_get(:test, /^test/) '"\n    => "' nil' do
      expect(@hdata.rh_get(:test, /^test/)).to eq(nil)
    end

    it 'rh_get(:test, /test/) '"\n    => "' %w(value1 value2)' do
      expect(@hdata.rh_get(:test, /^:test/)).to eq(%w(value1 value2))
    end

    it 'rh_get(:test, /^test/) '"\n    => "' %w(value1 value2)' do
      expect(@hdata.rh_get(:test, /test/)).to eq(%w(value1 value2))
    end

    it 'rh_get(:test, "/:test/") '"\n    => "' %w(value1 value2)' do
      expect(@hdata.rh_get(:test, '/:test/')).to eq(%w(value1 value2))
    end

    it 'rh_get(:test, "{/test/}") '"\n    => "' %w(value1 value2)' do
      expect(@hdata.rh_get(:test, '{/test/}')).to eq(:test2 => 'value1',
                                                     :test3 => 'value2')
    end

    it 'rh_get(/test/, :test) '"\n    => "' nil' do
      expect(@hdata.rh_get(/test/, :test)).to eq(nil)
    end

    it 'rh_get(/test/, :test2) '"\n    => "' %w(value1 value4' do
      expect(@hdata.rh_get(/test/, :test2)).to eq(%w(value1 value4))
    end

    it 'rh_get("{/test/}", :test2) '"\n    => "' %w(value1 value4' do
      expect(@hdata.rh_get('{/test/}', :test2)).to eq(:test => 'value1',
                                                      :test6 => 'value4')
    end
  end

  context "With {
        :test => [{ :test2 => 'value1', :test3 => 'value2' },
                  { :test3 => 'value3' },
                  { :test4 => { :test5 => 'value4' } }],
        :test6 => ['value5'],
        :test7 => [ {:test8 => 'value6'}, 'value7'],
        :_test1  => 'value8',
        :_test10 => 'value9',
        :_test2  => 'value10' \n"\
        '}' do
    before(:all) do
      @hdata = { :test => [{ :test2 => 'value1', :test3 => 'value2' },
                           { :test4 => { :test5 => 'value4' } },
                           { :test3 => 'value3' }],
                 :test6 => ['value5'],
                 :test7 => [{ :test8 => 'value6' }, 'value7'],
                 :_test1 => 'value8',
                 :_test10 => 'value9',
                 :_test2 => 'value10'
               }
    end

    it 'rh_get(:test, :test) '"\n    => "' nil' do
      expect(@hdata.rh_get(:test, :test)).to eq(nil)
    end

    it 'rh_get(:test, :test) '"\n    => "' nil' do
      expect(@hdata.rh_get(:test, :test6)).to eq(nil)
    end

    it 'rh_get(:test, :test2) '"\n    => "' %w(value1)' do
      expect(@hdata.rh_get(:test, :test2)).to eq(%w(value1))
    end

    it 'rh_get(:test, :test3) '"\n    => "' %w(value2 value3)' do
      expect(@hdata.rh_get(:test, :test3)).to eq(%w(value2 value3))
    end

    it 'rh_get(/^:test/, :test3) '"\n    => "' [%w(value2 value3)]' do
      expect(@hdata.rh_get(/^:test/, :test3)).to eq([%w(value2 value3)])
    end

    it "rh_get('{/^:test/}', :test3) \n    =>  {:test=>%w(value2 value3)}" do
      expect(@hdata.rh_get('{/^:test/}', :test3)).to eq(:test => %w(value2
                                                                    value3))
    end

    it 'rh_get(:test, /test/) '"\n    => "' ["value1", "value2", "value3",'\
       '{ :test5 => "value4" }]' do
      expect(@hdata.rh_get(:test, /test/)).to eq(['value1', 'value2',
                                                  { :test5 => 'value4' },
                                                  'value3'])
    end

    it "rh_get(:test, '/test/e') \n    =>  ['value1', 'value2', 'value3',"\
       "{ :test5 => 'value4' }]" do
      expect(@hdata.rh_get(:test, '/test/e')).to eq(['value1', 'value2',
                                                     { :test5 => 'value4' },
                                                     'value3'])
    end

    it "rh_get(/:test/, '{/test/}') \n    =>  { :test2 => 'value1',"\
       " :test3 => 'value3', :test4 => { :test5 => 'value4' } } "\
       '- :test3 gets the latest value !!!' do
      expect(@hdata.rh_get(/:test/, '{/test/}')).to eq([
        { :test2 => 'value1', :test3 => 'value3',
          :test4 => { :test5 => 'value4' } },
        { :test8 => 'value6' }])
    end

    it "rh_get(/:test/, '{/test/e}') \n    => [{ :test2 => 'value1',"\
       " :test3 => 'value3', :test4 => { :test5 => 'value4' } }, "\
       "{}, { :test8 => 'value6' }] - :test3 gets the latest value !!!" do
      expect(@hdata.rh_get(/:test/, '{/test/e}')).to eq([
        { :test2 => 'value1', :test3 => 'value3',
          :test4 => { :test5 => 'value4' } },
        {},
        { :test8 => 'value6' }])
    end

    it "rh_get('{/:test/}', '{/test/e}') \n    => "\
       ":test => { :test2 => 'value1', :test3 => 'value3',"\
       " :test4 => { :test5 => 'value4' } },"\
       ':test6 => {}, '\
       ":test7 => { :test8 => 'value6' } - :test3 gets the latest value !!!" do
      expect(@hdata.rh_get('{/:test/}', '{/test/e}')).to eq(
        :test => { :test2 => 'value1', :test3 => 'value3',
                   :test4 => { :test5 => 'value4' } },
        :test6 => {},
        :test7 => { :test8 => 'value6' })
    end

    it "rh_get('/_test1/') \n    => "\
       ":_test1 => ['value8', 'value9']" do
      expect(@hdata.rh_get(/_test1/)).to eq(%w(value8 value9))
    end

    it "rh_get('/_test1/0') \n    => "\
       ":_test1 => ['value8', 'value9'] "\
       ': opt 0 - No change. 2 elements found.' do
      expect(@hdata.rh_get('/_test1/0')).to eq(%w(value8 value9))
    end

    it "rh_get('/_test2/') \n    => "\
       ":_test1 => ['value10']" do
      expect(@hdata.rh_get(/_test2/)).to eq(['value10'])
    end

    it "rh_get('/_test2/0') \n    => "\
       ":_test1 => 'value10'"\
       ': opt 0 - 1 element found. So, get value of element 0.' do
      expect(@hdata.rh_get('/_test2/0')).to eq('value10')
    end

    it "rh_get(:test, 3) \n    => nil" do
      expect(@hdata.rh_get(:test, 3)).to eq(nil)
    end

    it "rh_get(:test, 2) \n    => { :test3 => 'value3' }" do
      expect(@hdata.rh_get(:test, 2)).to eq(:test3 => 'value3')
    end

    it "rh_get(:test, 2, :test3) \n    => 'value3'" do
      expect(@hdata.rh_get(:test, 2, :test3)).to eq('value3')
    end

    it "rh_get(:test, 1, :test3) \n    => nil" do
      expect(@hdata.rh_get(:test, 1, :test3)).to eq(nil)
    end

    it "rh_get(:test, 1, :test4, :test5) \n    => 'value4' " do
      expect(@hdata.rh_get(:test, 1, :test4, :test5)).to eq('value4')
    end

    it "rh_get(:test, 1..2, :test3) \n    => ['value3']" do
      expect(@hdata.rh_get(:test, 1..2, :test3)).to eq(['value3'])
    end

    it "rh_get(:test, 0..1, :test3) \n    => ['value2']" do
      expect(@hdata.rh_get(:test, 0..1, :test3)).to eq(['value2'])
    end

    it "rh_get(:test, '=[0]', :test4, :test5) \n    => 'value4'" do
      expect(@hdata.rh_get(:test, '=[0]', :test4, :test5)).to eq('value4')
    end

    it "rh_get(:test, '=[1]', :test4, :test5) \n    => nil" do
      expect(@hdata.rh_get(:test, '=[1]', :test4, :test5)).to eq(nil)
    end

    it "rh_get(:test, '=[0..1]', :test3) \n    => %w(value2 value3)" do
      expect(@hdata.rh_get(:test, '=[0..1]', :test3)).to eq(%w(value2 value3))
    end

    it "rh_get(:test, '<%= data[:test2] == \"value1\" %>|:test3') \n"\
       "    => 'value6'" do
      expect(@hdata.rh_get(:test, '<%= data[:test2] == "value1" %>'\
                                   '|:test3')).to eq(['value2'])
    end

    it "rh_get(:test, '=[0]','<%= data[:test2] == \"value1\" %>|:test3') \n"\
       "    => 'value2'" do
      expect(@hdata.rh_get(:test, '=[0]', '<%= data[:test2] == "value1" %>'\
                                          '|:test3')).to eq('value2')
    end

    it "with RhContext.context = :test3, rh_get(:test, '=[0]',"\
       "'<%= data[:test2] == \"value1\" %>|"\
       "<%= context %>') \n    => 'value2'" do
      RhContext.context = ':test3'
      expect(@hdata.rh_get(:test, '=[0]', '<%= data[:test2] == "value1" %>'\
                                          '|<%= context %>')).to eq('value2')
    end
  end

  context 'With hdata = {}' do
    before(:all) do
      @hdata = {}
    end
    it 'rh_set(:test) '"\n    => "' nil, with no change to hdata.' do
      expect(@hdata.rh_set(:test)).to equal(nil)
      expect(@hdata).to eq({})
    end

    it 'rh_set(:test, :test2) add a new element :test2 => :test' do
      expect(@hdata.rh_set(:test, :test2)).to eq(:test)
      expect(@hdata).to eq(:test2 => :test)
    end

    it 'rh_set(:test, :test2, :test5) replace :test2 by :test5 => :test' do
      expect(@hdata.rh_set(:test, :test2, :test5)).to eq(:test)
      expect(@hdata).to eq(:test2 => { :test5 => :test })
    end

    it 'rh_set(:test, :test5 ) add :test5 => :test, colocated with :test2' do
      expect(@hdata.rh_set(:test, :test5)).to equal(:test)
      expect(@hdata).to eq(:test2 => { :test5 => :test },
                           :test5 => :test)
    end

    it "rh_set('blabla', :test2, 'text') add a 'test' => 'blabla' under"\
       ' :test2, colocated with ẗest5 ' do
      expect(@hdata.rh_set('blabla', :test2, 'text')).to eq('blabla')
      expect(@hdata).to eq(:test2 => { :test5 => :test,
                                       'text' => 'blabla' },
                           :test5 => :test)
    end

    it 'rh_set(nil, :test2) remove :test2 value' do
      expect(@hdata.rh_set(nil, :test2)).to equal(nil)
      expect(@hdata).to eq(:test2 => nil,
                           :test5 => :test)
    end
  end

  context 'With hdata = {:test2 => { :test5 => :test,'\
          "'text' => 'blabla' },"\
          ':test5 => :test}' do
    before(:all) do
      @hdata = { :test2 => { :test5 => :test,
                             'text' => 'blabla' },
                 :test5 => :test }
    end
    it 'rh_del(:test) '"\n    => "' nil, with no change to hdata.' do
      expect(@hdata.rh_del(:test)).to equal(nil)
      expect(@hdata).to eq(:test2 => { :test5 => :test,
                                       'text' => 'blabla' },
                           :test5 => :test)
    end

    it 'rh_del(:test, :test2) '"\n    => "' nil, with no change to hdata.' do
      expect(@hdata.rh_del(:test, :test2)).to eq(nil)
      expect(@hdata).to eq(:test2 => { :test5 => :test,
                                       'text' => 'blabla' },
                           :test5 => :test)
    end

    it 'rh_del(:test2, :test5) remove :test5 keys tree from :test2' do
      expect(@hdata.rh_del(:test2, :test5)).to eq(:test)
      expect(@hdata).to eq(:test2 => { 'text' => 'blabla' },
                           :test5 => :test)
    end

    it 'rh_del(:test5 ) remove :test5' do
      expect(@hdata.rh_del(:test5)).to equal(:test)
      expect(@hdata).to eq(:test2 => { 'text' => 'blabla' })
    end

    it 'rh_del(:test2) remove the :test2. hdata is now {}.'\
       ' :test2, colocated with ẗest5 ' do
      expect(@hdata.rh_del(:test2)).to eq('text' => 'blabla')
      expect(@hdata).to eq({})
    end
  end

  context "With hdata = { :test => { :test2 => { :test5 => :test,\n"\
          "                                        'text' => 'blabla' },\n"\
          "                            'test5' => 'test' },\n"\
          '                 :array => [{ :test => :value1 }, '\
          '2, { :test => :value3 }]}' do
    before(:all) do
      @hdata = { :test => { :test2 => { :test5 => :test,
                                        'text' => 'blabla' },
                            'test5' => 'test' },
                 :array => [{ :test => :value1 }, 2, { :test => :value3 }]
               }
    end
    it 'rh_clone is done without error' do
      expect { @hdata.rh_clone }.to_not raise_error
    end
    it 'hclone[:test] = "test" => hdata[:test] != hclone[:test]' do
      hclone = @hdata.rh_clone
      hclone[:test] = 'test'
      expect(@hdata[:test]).to eq(:test2 => { :test5 => :test,
                                              'text' => 'blabla' },
                                  'test5' => 'test')
    end
    it 'hclone[:array].pop => hdata[:array].length != hclone[:array].length' do
      hclone = @hdata.rh_clone
      hclone[:array].pop
      expect(@hdata[:array].length).not_to eq(hclone[:array].length)
    end

    it 'hclone[:array][0][:test] = "value2" '\
       '=> hdata[:array][0][:test] != hclone[:array][0][:test]' do
      hclone = @hdata.rh_clone
      hclone[:array][0][:test] = 'value2'
      expect(@hdata[:array][0][:test]).to eq(:value1)
    end
  end

  context 'with orig = {:data1 => {:prop1 => :val1}}' do
    before(:all) do
      @orig = { :data1 => { :prop1 => :val1 } }
    end

    it 'rh_merge(:data2 => {:prop1 => :val2}) '"\n    => "' '\
       '{:data1 => {:prop1 => :val1}, :data2 => {:prop1 => :val2}}' do
      expect(@orig.rh_merge(:data2 => { :prop1 => :val2 }
                           )).to eq(:data1 => { :prop1 => :val1 },
                                    :data2 => { :prop1 => :val2 })
    end

    it 'rh_merge(:data1 => {:prop1 => :val2}) '"\n    => "' '\
       '{:data1 => {:prop1 => :val2}}' do
      expect(@orig.rh_merge(:data1 => { :prop1 => :val2 }
                           )).to eq(:data1 => { :prop1 => :val2 })
    end

    it 'rh_merge(:data1 => {:prop1 => :unset}) '"\n    => "' '\
       '{:data1 => {}}' do
      expect(@orig.rh_merge(:data1 => { :prop1 => :unset }
                           )).to eq(:data1 => {})
    end

    it 'rh_merge(:data1 => {:__protected => [:prop1],'\
                           ':prop1 => :unset}) '"\n    => "' '\
       '{:data1 => {:__protected => [:prop1]}}' do
      expect(@orig.rh_merge(:data1 => { :__protected => [:prop1],
                                        :prop1 => :unset }
                           )).to eq(:data1 => { :__protected => [:prop1] })
    end

    it 'rh_merge(:data1 => :val2) '"\n    => "' '\
       '{:data1 => {:prop1 => :val1}}' do
      expect(@orig.rh_merge(:data1 => :val2
                           )).to eq(:data1 => { :prop1 => :val1 })
    end

    it 'rh_merge(:data1 => :unset) '"\n    => "' '\
       '{:data1 => {:prop1 => :val1}}' do
      expect(@orig.rh_merge(:data1 => :unset
                           )).to eq(:data1 => { :prop1 => :val1 })
    end

    it 'rh_merge(:data1 => {:prop1 => {}}) '"\n    => "' '\
        ':data1 => {:prop1 => :val1}}' do
      expect(@orig.rh_merge(:data1 => { :prop1 => {} }
                           )).to eq(:data1 => { :prop1 => :val1 })
    end
  end

  context 'with orig = [:data1, :data2, :data3]' do
    before(:all) do
      @orig = [:data1, :data2, :data3]
    end

    # Replace index 0
    it 'rh_merge([:data4])'\
       "\n    => "'[{:__control => true}, :data4, :data2, :data3]' do
      expect(@orig.rh_merge([:data4])
            ).to eq([{ :__control => true }, :data4, :data2, :data3])
      expect(@orig).to eq([:data1, :data2, :data3])
    end

    # add :data4 at the end
    it 'rh_merge([{:__add => [:data4]}])'"\n    => "'[{:__control => true},'\
                                            ':data1, :data2, :data3, :data4]' do
      expect(@orig.rh_merge([{ :__add => [:data4] }])
            ).to eq([{ :__control => true }, :data1, :data2, :data3, :data4])
    end

    # add :data4 at index 3
    it 'rh_merge([:kept, :kept, :kept, :data4])'\
       "\n    => "'[{:__control => true},'\
                                            ':data1, :data2, :data3, :data4]' do
      expect(@orig.rh_merge([{ :__add => [:data4] }])
            ).to eq([{ :__control => true }, :data1, :data2, :data3, :data4])
    end

    # add :data4 at index 3
    it 'rh_merge([{:__add_index => {3 => [:data4]}}]) '\
       ''"\n    => "'[{:__control => true}, :data1, :data2, :data3, :data4]' do
      expect(@orig.rh_merge([{ :__add_index => { 3 => [:data4] } }])
            ).to eq([{ :__control => true }, :data1, :data2, :data3, :data4])
    end

    # add :data4, :data5 at index 3
    it 'rh_merge([{:__add_index => {3 => [:data4, :data5]}}]) '\
       "\n    => [{:__control => true}, "\
                   ':data1, :data2, :data3, :data4, :data5]' do
      expect(@orig.rh_merge([{ :__add_index => { 3 => [:data4, :data5] } }])
            ).to eq([{ :__control => true },
                     :data1, :data2, :data3, :data4, :data5])
    end

    # add :data4, :data5 at index 3 or :data6 element => choose :data6
    it 'rh_merge([{:__add_index => {3 => [:data4, :data5]},'\
                  ':__add => [:data6]}]) '\
       ''"\n    => "'[{:__control => true}, :data1, :data2, :data3, :data6]' do
      expect(@orig.rh_merge([{ :__add_index => { 3 => [:data4, :data5] },
                               :__add => [:data6] }])
            ).to eq([{ :__control => true }, :data1, :data2, :data3, :data6])
    end

    # Remove index 1
    it 'rh_merge([{:__remove => [:data2]}])'\
       "\n    => "'[{:__control => true}, '\
       ':data1, :data3]' do
      expect(@orig.rh_merge([{ :__remove => [:data2] }])
            ).to eq([{ :__control => true }, :data1, :data3])
    end

    # replace index 0 and remove index 1
    it 'rh_merge([{:__remove => [:data2]}, :data4])'"\n    => "''\
       ' [{:__control => true}, :data4, :data3]' do
      expect(@orig.rh_merge([{ :__remove => [:data2] }, :data4])
            ).to eq([{ :__control => true }, :data4, :data3])
    end

    # remove index 0
    it 'rh_merge([{:__remove_index => [0]}])'"\n    => "''\
       ' [{:__control => true}, :data2, :data3]' do
      expect(@orig.rh_merge([{ :__remove_index => [0] }])
            ).to eq([{ :__control => true }, :data2, :data3])
    end

    # remove index 0
    it 'rh_merge([{:__remove_index => [0, 0]}])'"\n    => "''\
       ' [{:__control => true}, :data1, :data3]' do
      expect(@orig.rh_merge([{ :__remove_index => [0, 0] }])
            ).to eq([{ :__control => true }, :data2, :data3])
    end

    # remove index 1, 0
    it 'rh_merge([{:__remove_index => [1, 0]}])'\
       "\n    => "'[{:__control => true}, '\
                                                   ':data3]' do
      expect(@orig.rh_merge([{ :__remove_index => [1, 0] }])
            ).to eq([{ :__control => true }, :data3])
    end

    # remove index 0, 1
    it 'rh_merge([{:__remove_index => [0, 1]}])'\
       "\n    => "'[{:__control => true}, '\
                                                   ':data3]' do
      expect(@orig.rh_merge([{ :__remove_index => [0, 1] }])
            ).to eq([{ :__control => true }, :data3])
    end

    # remove element :data3, or index 0 => :data3
    it 'rh_merge([{:__remove_index => [0],'\
                  ':__remove => [:data3]}])'"\n    => "''\
       ' [{:__control => true}, :data1, :data2]' do
      expect(@orig.rh_merge([{ :__remove_index => [0],
                               :__remove => [:data3] }])
            ).to eq([{ :__control => true }, :data1, :data2])
    end

    # replace index 0 and 1. index 0: Refuse to change symbol to Hash
    it 'rh_merge([{:blabla => [:data2]}, :data4])'"\n    => "''\
       ' [{:__control => true}, :data1, :data4, :data3]' do
      expect(@orig.rh_merge([{ :blabla => [:data2] }, :data4])
            ).to eq([{ :__control => true }, :data1, :data4, :data3])
    end

    # replace index 0 and 1. index 0: Refuse to change symbol to Hash
    it 'rh_merge([{:__struct_changing => [0]}, '\
                 '{:blabla => [:data2]}, :data4])'"\n    => "''\
       ' [{:__control => true, :__struct_changing => [0]}, '\
         ':data1, :data4, :data3]' do
      expect(@orig.rh_merge([{ :__struct_changing => [0] },
                             { :blabla => [:data2] },
                             :data4])
            ).to eq([{ :__control => true, :__struct_changing => [0] },
                     :data1, :data4, :data3])
    end

    # update control on @config
    it 'rh_merge!([{:__struct_changing => [0]}])'"\n    => "''\
       ' [{:__control => true, :__struct_changing => [0]}, '\
         ':data1, :data2, :data3]' do
      expect(@orig.rh_merge!([{ :__struct_changing => [0] }])
            ).to eq([{ :__control => true, :__struct_changing => [0] },
                     :data1, :data2, :data3])

      expect(@orig).to eq([{ :__control => true, :__struct_changing => [0] },
                           :data1, :data2, :data3])
    end

    # See struct_changing working
    it 'rh_merge!([{:blabla => [:data2]}])'"\n    => "''\
       ' [{:__control => true, :__struct_changing => [0]}, '\
         '{:blabla => [:data2]}, :data2, :data3,  :data4]' do
      expect(@orig.rh_merge!([{ :blabla => [:data2] }])
            ).to eq([{ :__control => true, :__struct_changing => [0] },
                     { :blabla => [:data2] }, :data2, :data3])
    end

    # See recursivity in place.
    it 'rh_merge([{:blabla => [:data2]}])'"\n    => "''\
       ' [{:__control => true, :__struct_changing => [0]},
          {:blabla => [{:__control=>true}, :data1], '\
          ':test => :ok }, '\
         ':data2, :data3]' do
      expect(@orig.rh_merge([{ :blabla => [:data1], :test => :ok }])
            ).to eq([{ :__control => true, :__struct_changing => [0] },
                     { :blabla => [{ :__control => true },
                                   :data1],
                       :test => :ok },
                     :data2, :data3])
    end

    # Array Control Cleanup
    it "previous_result.merge_cleanup\n    => "\
         '[{ :blabla => [:data1], :test => :ok }, :data2, :data3]' do
      hash = @orig.rh_merge([{ :blabla => [:data1], :test => :ok }])

      expect(hash.merge_cleanup
            ).to eq([{ :blabla => [:data1], :test => :ok }, :data2, :data3])
      expect(hash.merge_cleanup).not_to eq(hash)
    end

    it "previous_result.merge_cleanup!\n    => "\
       'previous_result => [{ :blabla => [:data1], :test => :ok }, '\
       ':data2, :data3]' do
      hash = @orig.rh_merge([{ :blabla => [:data1], :test => :ok }])
      hash_result = hash.merge_cleanup
      expect(hash.merge_cleanup!).to eq(hash_result)
      expect(hash).to eq(hash_result)
    end
  end

  context 'with orig = {:__struct_changing => [:data1], '\
                  ':data1 => {:prop1 => :val1}}' do
    before(:all) do
      @orig = { :__struct_changing => [:data1], :data1 => { :prop1 => :val1 } }
    end

    it 'rh_merge(:data1 => :val2) '"\n    => "' '\
       '{:__struct_changing => [:data1], '\
        ':data1 => :val2}' do
      expect(@orig.rh_merge(:data1 => :val2
                           )).to eq(:__struct_changing => [:data1],
                                    :data1 => :val2)
    end

    it 'rh_merge(:data1 => {}) '"\n    => "' '\
       '{:__struct_changing => [:data1], '\
        ':data1 => { :prop1 => :val1 }}' do
      expect(@orig.rh_merge(:data1 => {}
                           )).to eq(:__struct_changing => [:data1],
                                    :data1 => { :prop1 => :val1 })
    end

    it 'rh_merge(:data1 => {:prop1 => :unset}) '"\n    => "' '\
       '{:__struct_changing => [:data1], '\
        ':data1 => {}}' do
      expect(@orig.rh_merge(:data1 => { :prop1 => :unset }
                           )).to eq(:__struct_changing => [:data1],
                                    :data1 => {})
    end

    it 'rh_merge(:data1 => :unset) '"\n    => "' '\
       '{:__struct_changing => [:data1]}' do
      expect(@orig.rh_merge(:data1 => :unset
                           )).to eq(:__struct_changing => [:data1])
    end

    it 'rh_merge(:data2 => {:prop1 => :val2}) '"\n    => "' '\
       '{:__struct_changing => [:data1], '\
        ':data1 => {:prop1 => :val1}, '\
        ':data2 => {:prop1 => :val2}}' do
      expect(@orig.rh_merge(:data2 => { :prop1 => :val2 }
                           )).to eq(:__struct_changing => [:data1],
                                    :data1 => { :prop1 => :val1 },
                                    :data2 => { :prop1 => :val2 })
    end

    it 'rh_merge(:__struct_changing => [{:__add => [:data2]}], '\
                     ':data2 => {:prop1 => :val2}) '"\n    => "' '\
       '{:__struct_changing => [:data1, :data2], '\
        ':data1 => {:prop1 => :val1}, '\
        ':data2 => {:prop1 => :val2}}' do
      expect(@orig.rh_merge(:__struct_changing => [{ :__add => [:data2] }],
                            :data2 => { :prop1 => :val2 }
                           )).to eq(:__struct_changing => [:data1, :data2],
                                    :data1 => { :prop1 => :val1 },
                                    :data2 => { :prop1 => :val2 })
    end

    it 'rh_merge(:__struct_changing => [{:__remove => [:data1]}, :data2], '\
                     ':data2 => {:prop1 => :val2}) '"\n    => "' '\
       '{:__struct_changing => [:data1, :data2], '\
        ':data1 => {:prop1 => :val1}, '\
        ':data2 => {:prop1 => :val2}}' do
      expect(@orig.rh_merge(:__struct_changing => [{ :__remove => [:data1] },
                                                   :data2],
                            :data2 => { :prop1 => :val2 })
            ).to eq(:__struct_changing => [:data2],
                    :data1 => { :prop1 => :val1 },
                    :data2 => { :prop1 => :val2 })
    end

    it 'rh_merge(:__struct_changing => [{:__remove => [:data1]}, :data2], '\
                     ':data1 => :unset,'\
                     ':data2 => {:prop1 => :val2}) '"\n    => "' '\
       '{:__struct_changing => [:data1, :data2], '\
        ':data2 => {:prop1 => :val2}}' do
      expect(@orig.rh_merge(:__struct_changing => [{ :__remove => [:data1] },
                                                   :data2],
                            :data1 => :unset,
                            :data2 => { :prop1 => :val2 }
                           )).to eq(:__struct_changing => [:data2],
                                    :data2 => { :prop1 => :val2 })
    end
  end

  context 'with orig = {:data1 => {:__protected => [:prop1], '\
          ':prop1 => :val1}}' do
    before(:all) do
      @orig = { :data1 => { :__protected => [:prop1], :prop1 => :val1 } }
    end

    it 'rh_merge(:data2 => {:prop1 => :val2}) '"\n    => "' '\
       '{:data1 => {:prop1 => :val1}, :data2 => {:prop1 => :val2}}' do
      expect(@orig.rh_merge(:data2 => { :prop1 => :val2 }
                           )).to eq(:data1 => { :__protected => [:prop1],
                                                :prop1 => :val1 },
                                    :data2 => { :prop1 => :val2 })
    end

    it 'rh_merge(:data1 => {:prop1 => :val2}) '"\n    => "' '\
       '{:data1 => {:prop1 => :val1}}' do
      expect(@orig.rh_merge(:data1 => { :prop1 => :val2 }
                           )).to eq(:data1 => { :__protected => [:prop1],
                                                :prop1 => :val1 })
    end

    it 'rh_merge(:data1 => {:prop1 => :unset}) '"\n    => "' '\
       '{:data1 => {:prop1 => :val1}}' do
      expect(@orig.rh_merge(:data1 => { :prop1 => :unset }
                           )).to eq(:data1 => { :__protected => [:prop1],
                                                :prop1 => :val1 })
    end
  end

  context 'With hdata = { :test => { :test2 => { :test5 => :test,'\
          "'text' => 'blabla' },"\
          "'test5' => 'test' }}" do
    before(:all) do
      @hdata = { :test => { :test2 => { :test5 => :test,
                                        'text' => 'blabla' },
                            'test5' => 'test' } }
    end
    it 'rh_key_to_symbol?(1) '"\n    => "' false' do
      expect(@hdata.rh_key_to_symbol?(1)).to equal(false)
    end
    it 'rh_key_to_symbol?(2) '"\n    => "' true' do
      expect(@hdata.rh_key_to_symbol?(2)).to equal(true)
    end
    it 'rh_key_to_symbol?(3) '"\n    => "' true' do
      expect(@hdata.rh_key_to_symbol?(3)).to equal(true)
    end
    it 'rh_key_to_symbol?(4) '"\n    => "' true' do
      expect(@hdata.rh_key_to_symbol?(4)).to equal(true)
    end

    it 'rh_key_to_symbol(1) '"\n    => "' no diff' do
      expect(@hdata.rh_key_to_symbol(1)
            ).to eq(:test => { :test2 => { :test5 => :test,
                                           'text' => 'blabla' },
                               'test5' => 'test' })
    end
    it 'rh_key_to_symbol(2) '"\n    => "' "test5" is replaced by :ẗest5' do
      expect(@hdata.rh_key_to_symbol(2)
            ).to eq(:test => { :test2 => { :test5 => :test,
                                           'text' => 'blabla' },
                               :test5 => 'test' })
    end
    it 'rh_key_to_symbol(3) '"\n    => "' "test5" replaced by :ẗest5, '\
       'and "text" to :text' do
      expect(@hdata.rh_key_to_symbol(3)
            ).to eq(:test => { :test2 => { :test5 => :test,
                                           :text => 'blabla' },
                               :test5 => 'test' })
    end
    it 'rh_key_to_symbol(4) same like rh_key_to_symbol(3)' do
      expect(@hdata.rh_key_to_symbol(4)).to eq(@hdata.rh_key_to_symbol(3))
    end
  end

  context "With {\n"\
          "         :_test3  => [{ :filter => 1, :test1 => 'value1' }],\n"\
          "         :_test34 => [{ :filter => 1, :test1 => 'value2' },\n"\
          "                      { :filter => 2, :test1 => 'value3' }] \n"\
          '} - Complex cases' do
    before(:all) do
      @hdata = { :_test3 =>  [{ :filter => 1, :test1 => 'value1' }],
                 :_test34 => [{ :filter => 1, :test1 => 'value2' },
                              { :filter => 2, :test1 => 'value3' },
                              { :filter => 1, :test1 => 'value4' }]
               }
    end

    it "rh_get('/_test3$/') \n    => "\
       "[[{ :filter => 1, :test1 => 'value1' }]]"\
       ' - Just getting content of matching keys in array.' do
      expect(@hdata.rh_get('/_test3$/')
            ).to eq([[{ :filter => 1, :test1 => 'value1' }]])
    end

    it "rh_get('/_test3$/0') \n    => "\
       " [{ :filter => 1, :test1 => 'value1' }]"\
       ' - Matching array, with only one element. So getting content of '\
       'that element 0' do
      expect(@hdata.rh_get('/_test3$/0')
            ).to eq([:filter => 1, :test1 => 'value1'])
    end

    it "rh_get('/_test3/') \n    => "\
       "[[{ :filter => 1, :test1 => 'value1' }],\n"\
       "       [{ :filter => 1, :test1 => 'value2' },\n"\
       "        { :filter => 2, :test1 => 'value3' },"\
       "        { :filter => 1, :test1 => 'value4' }]]"\
       ' - Just getting, for all matching keys, all elements content' do
      expect(@hdata.rh_get('/_test3/')
            ).to eq([[{ :filter => 1, :test1 => 'value1' }],
                     [{ :filter => 1, :test1 => 'value2' },
                      { :filter => 2, :test1 => 'value3' },
                      { :filter => 1, :test1 => 'value4' }]])
    end

    it "rh_get('/_test3/0') \n    => "\
       "[{ :filter => 1, :test1 => 'value1' },\n"\
       "       { :filter => 1, :test1 => 'value2' },\n"\
       "       { :filter => 2, :test1 => 'value3' },"\
       "       { :filter => 1, :test1 => 'value4' }]"\
       ' - Result is an Array of 3 elements. So, same result.' do
      expect(@hdata.rh_get('/_test3/0')
            ).to eq([[{ :filter => 1, :test1 => 'value1' }],
                     [{ :filter => 1, :test1 => 'value2' },
                      { :filter => 2, :test1 => 'value3' },
                      { :filter => 1, :test1 => 'value4' }]])
    end

    it "rh_get('{/_test3$/}') \n    => "\
       ":_test3 => [{ :filter => 1, :test1 => 'value1' }]"\
       ' - Just getting content of :_test3, in the key' do
      expect(@hdata.rh_get('{/_test3$/}')
            ).to eq(:_test3 => [{ :filter => 1, :test1 => 'value1' }])
    end

    it "rh_get('{/_test3$/0}') \n    => "\
       ":_test3 => { :filter => 1, :test1 => 'value1' }"\
       ' - the content of :_key3 is an array with 1 element. '\
       "Getting 'key => key element 0'" do
      expect(@hdata.rh_get('{/_test3$/0}')
            ).to eq(:_test3 => { :filter => 1, :test1 => 'value1' })
    end

    it "rh_get(:_test3, '<%= data[:filter] == 1 %>|:test1') \n    => "\
       "['value1']"\
       '- Get all match elements found in :_test3 => Array' do
      expect(@hdata.rh_get(:_test3,
                           '<%= data[:filter] == 1 %>|:test1')
            ).to eq(['value1'])
    end

    it "rh_get(:_test3, '<%= data[:filter] == 1 %>0|:test1') \n    => "\
       "'value1' "\
       '- get value of element 0 as only one element was found' do
      expect(@hdata.rh_get(:_test3,
                           '<%= data[:filter] == 1 %>0|:test1')
            ).to eq('value1')
    end

    it "rh_get('{/_test3/}', '<%= data[:filter] == 1 %>|:test1') \n    => "\
       ":_test3 => ['value1'], :_test34 => ['value2', 'value4']"\
       '- build matching key list with Array of data filtered.' do
      expect(@hdata.rh_get('{/_test3/}',
                           '<%= data[:filter] == 1 %>|:test1')
            ).to eq(:_test3 => ['value1'], :_test34 => %w(value2 value4))
    end

    it "rh_get('{/_test3/}', '<%= data[:filter] == 1 %>0|:test1') \n    => "\
       ":_test3 => 'value1', :_test34 => ['value2', 'value4']"\
       '- same, but if result filtered is array with 1 element, '\
       'get that element' do
      expect(@hdata.rh_get('{/_test3/}',
                           '<%= data[:filter] == 1 %>0|:test1')
            ).to eq(:_test3 => 'value1', :_test34 => %w(value2 value4))
    end

    it "rh_get('{/_test3/}', '<%= data[:filter] == 2 %>|:test1') \n    => "\
       ":_test34 => ['value3']"\
       ' - get only matching keys with found filtered values.' do
      expect(@hdata.rh_get('{/_test3/}',
                           '<%= data[:filter] == 2 %>|:test1')
            ).to eq(:_test34 => ['value3'])
    end

    it "rh_get('{/_test3/}', '<%= data[:filter] == 2 %>e|:test1') \n    => "\
       ":_test3 => [], :_test34 => ['value3']"\
       ' - get only matching keys with found filtered values.' do
      expect(@hdata.rh_get('{/_test3/}',
                           '<%= data[:filter] == 2 %>e|:test1')
            ).to eq(:_test3 => [], :_test34 => ['value3'])
    end

    it "rh_get('{/_test3/}', '<%= data[:filter] == 2 %>0|:test1') \n    => "\
       ":_test34 => 'value3'"\
       ' - same but array of one element found => get the content of '\
       'that element' do
      expect(@hdata.rh_get('{/_test3/}',
                           '<%= data[:filter] == 2 %>0|:test1')
            ).to eq(:_test34 => 'value3')
    end

    it "rh_get('{/_test3/}', '<%= data[:filter] == 2 %>e0|:test1') \n    => "\
       ":_test3 => [], :_test34 => 'value3'"\
       ' - and now get empty key matching as well.' do
      expect(@hdata.rh_get('{/_test3/}',
                           '<%= data[:filter] == 2 %>e0|:test1')
            ).to eq(:_test3 => [], :_test34 => 'value3')
    end
  end
end
