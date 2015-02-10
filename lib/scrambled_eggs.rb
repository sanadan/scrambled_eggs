require "scrambled_eggs/version"
require 'openssl'

# Easy data scrambler by OpenSSL.
class ScrambledEggs
  # Initialize
  #
  # _algorithm_ ::  Algorithm (ex. 'aes-256-cbc')
  # _salt_      ::  Salt (8 bytes)
  # _key_       ::  Crypt key
  #
  # return      ::  ScrambledEggs object
  def initialize( algorithm: 'aes-256-cbc', salt: nil, key: nil )
    @@algorithm = algorithm
    @@salt = salt != nil ? salt : OpenSSL::Random.random_bytes( 8 )
    if key
      @@key = key
    else
      @@key = File.open( '/etc/hostname' ).read
    end
  end

  # Scramble (encrypt) data
  #
  # _data_  ::  Data for scramble
  #
  # return  ::  Scrambled data
  def scramble( data )
    cipher = OpenSSL::Cipher::Cipher.new( @@algorithm )
    cipher.encrypt
    cipher.pkcs5_keyivgen( @@key, @@salt )
    @@salt + cipher.update( data ) + cipher.final
  end
  
  # Descramble (descrypt) data
  #
  # _scrambled_ ::  Data for descramble
  #
  # return      ::  descrambled data
  def descramble( scrambled )
    cipher = OpenSSL::Cipher::Cipher.new( @@algorithm )
    cipher.decrypt
    salt = scrambled[ 0, 8 ]
    data = scrambled[ 8, scrambled.size ]
    cipher.pkcs5_keyivgen( @@key, salt )
    cipher.update( data ) + cipher.final
  end
end

