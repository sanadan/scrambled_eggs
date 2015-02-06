=begin
require "tmpdir"
require "pathname"

class Pathname
	@@tempname_number = 0
	def self.tempname(base=$0, dir=Dir.tmpdir)
		@@tempname_number += 1
		path = new(dir) + "#{File.basename(base)}.#{$$}.#{@@tempname_number}"
		at_exit do
			path.rmtree if path.exist?
		end
		path
	end
end
=end

require File.dirname(__FILE__) + '/test_helper.rb'

class ScrambledEggsTest < Test::Unit::TestCase
  def test_scramble_text
    text = 'Test text'
    egg = ScrambledEggs.new
    scrambled = egg.scramble( text )
    assert_equal( egg.descramble( scrambled ), text )
  end
  def test_scramble_binary
    size = OpenSSL::BN.rand_range( 4096 ) + 1
    data = OpenSSL::Random.random_bytes( size )
    egg = ScrambledEggs.new
    scrambled = egg.scramble( data )
    assert_equal( egg.descramble( scrambled ), data )
  end
  def test_scramble
    text = 'Test texti 2'
    egg = ScrambledEggs.new( algorithm: 'aes-128-cbc', salt: '01234567', key: 'Test key' )
    scrambled = egg.scramble( text )
#    puts scrambled.unpack( 'H*' )
    assert_equal( scrambled, [ '30313233343536371c24bce6e1bc9562162f4625602fb608' ].pack( 'H*' ) )
    assert_equal( egg.descramble( scrambled ), text )
  end
  def test_another_eggs
    text = 'Test text 3'
    scrambled = ScrambledEggs.new.scramble( text )
    assert_equal( ScrambledEggs.new.descramble( scrambled ), text )
  end
end

