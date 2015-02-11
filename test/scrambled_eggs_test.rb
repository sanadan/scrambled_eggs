require File.dirname(__FILE__) + '/test_helper.rb'
require 'tempfile'
require 'pathname'

def generate_random_data( size = 4096 )
  random_size = OpenSSL::BN.rand_range( size ) + 1
  return OpenSSL::Random.random_bytes( random_size )
end

def generate_random_file( data )
  file = Tempfile.open( 'ScrambledEggs' )
  path = Pathname.new( file.path )
  path.binwrite( data )
  return path
end

class ScrambledEggsTest < Test::Unit::TestCase
  def test_scramble_text
    text = 'Test text'
    egg = ScrambledEggs.new
    scrambled = egg.scramble( text )
    assert_not_equal( scrambled, text )
    assert_equal( egg.descramble( scrambled ), text )
  end

  def test_scramble_binary
    data = generate_random_data
    egg = ScrambledEggs.new
    scrambled = egg.scramble( data )
    assert_not_equal( scrambled, data )
    assert_equal( egg.descramble( scrambled ), data )
  end

  def test_scramble_another_parameter
    text = 'Test text 2'
    egg = ScrambledEggs.new( algorithm: 'aes-128-cbc', salt: '01234567', key: 'Test key' )
    scrambled = egg.scramble( text )
#    puts scrambled.unpack( 'H*' )
    assert_equal( scrambled, [ '30313233343536374d34d042eecb111955e73b3630a399e5' ].pack( 'H*' ) )
    assert_equal( egg.descramble( scrambled ), text )
  end

  def test_another_eggs
    text = 'Test text 3'
    scrambled = ScrambledEggs.new.scramble( text )
    assert_equal( ScrambledEggs.new.descramble( scrambled ), text )
    assert_raise OpenSSL::Cipher::CipherError do
      ScrambledEggs.new( key: generate_random_data( 256 ) ).descramble( scrambled )
    end

    algorithm = 'aes-192-cbc'
    salt = '98765432'
    key = 'Test key 2'
    scrambled = ScrambledEggs.new( algorithm: algorithm, salt: salt, key: key ).scramble( text )
    assert_equal( ScrambledEggs.new( algorithm: algorithm, salt: salt, key: key ).descramble( scrambled ), text )
    assert_raise OpenSSL::Cipher::CipherError do
      ScrambledEggs.new( algorithm: algorithm, salt: salt, key: generate_random_data( 256 ) ).descramble( scrambled )
    end
  end

  def test_salt
    text = 'Test text 4'
    256.times do |i|
      salt = []
      8.times do
        salt << i
      end
      salt = salt.pack( 'C*' )
      scrambled = ''
      assert_nothing_raised do
        scrambled = ScrambledEggs.new( salt: salt ).scramble( text )
      end
      assert_nothing_raised do
        ScrambledEggs.new.descramble( scrambled )
      end
    end
  end

  def test_file
    data = generate_random_data
    path = generate_random_file( data )
    ScrambledEggs.new.scramble_file( path )
    assert_not_equal( path.binread, data )
    ScrambledEggs.new.descramble_file( path )
    assert_equal( path.binread, data )
    assert_raise OpenSSL::Cipher::CipherError do
      ScrambledEggs.new( key: generate_random_data( 256 ) ).descramble_file( path )
    end
  end

  def test_key_file
    text = 'Test text 5'
    key_path = generate_random_file( generate_random_data )
    scrambled = ScrambledEggs.new( key_file: key_path ).scramble( text )
    assert_not_equal( scrambled, text )
    assert_equal( ScrambledEggs.new( key_file: key_path ).descramble( scrambled ), text )
    key_path2 = generate_random_file( generate_random_data )
    assert_raise OpenSSL::Cipher::CipherError do
      ScrambledEggs.new( key_file: key_path2 ).descramble( scrambled )
    end
  end
end

