require "scrambled_eggs/version"
require 'bundler/setup'
Bundler.require

# Easy data scrambler by OpenSSL
class ScrambledEggs
  # Initialize
  #
  # _algorithm_ ::  Algorithm
  # _salt_      ::  Salt (8 bytes)
  # _key_       ::  Crypt key
  def initialize( algorithm: 'aes-256-cbc', salt: nil, key: nil )
    @@algorithm = algorithm
    @@salt = salt ? salt : OpenSSL::Random.random_bytes( 8 )
    if key
      @@key = key
    else
      @@key = File.open( '/etc/hostname' ).read
    end
  end

  # Encrypt data
  #
  # _data_  ::  Data for encrypt
  #
  # return  ::  Crypted data
  def scramble( data )
    cipher = OpenSSL::Cipher::Cipher.new( @@algorithm )
    cipher.encrypt
    cipher.pkcs5_keyivgen( @@key, @@salt )
    @@salt + cipher.update( data ) + cipher.final
  end
  
  # Descrypt data
  #
  # _scrambled_ ::  Data for decrypt
  #
  # return      ::  Decrypted data
  def descramble( scrambled )
    cipher = OpenSSL::Cipher::Cipher.new( @@algorithm )
    cipher.decrypt
    salt = scrambled[ 0, 8 ]
    data = scrambled[ 8, scrambled.size ]
    cipher.pkcs5_keyivgen( @@key, salt )
    cipher.update( data ) + cipher.final
  end
end

