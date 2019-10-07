require "openssl"
require "openssl/hmac"

class OpenSSL::HMAC
  @ctx : LibCrypto::HMAC_CTX

  # Returns an HMAC calculator using the secret *key*.
  #
  # *algorithm* specifies which `OpenSSL::Algorithm` is to be used.
  def initialize(algorithm : OpenSSL::Algorithm, key)
    evp = algorithm.to_evp
    key_slice = key.to_slice
    @ctx = LibCrypto::HMAC_CTX.malloc
    LibCrypto.hmac_ctx_init(@ctx)
    if LibCrypto.hmac_init_ex(@ctx, key_slice, key_slice.size, evp, nil) < 1
      raise("Could not initialize hmac")
    end
    @finalized = false
  end

  # Updates the HMAC state with *data*
  def update(data)
    if @finalized
      raise("HMAC has already been finalized")
    end
    data_slice = data.to_slice
    if LibCrypto.hmac_update(@ctx, data_slice, data_slice.size) < 1
      raise("Could not update hmac")
    end
  end

  # Alias for `#update`
  def <<(data)
    update(data)
  end

  # Returns the calculated HMAC digest
  #
  # It may contain non-ASCII bytes, including NUL bytes.
  #
  def digest
    buffer = Bytes.new(128)
    if LibCrypto.hmac_final(@ctx, buffer, out buffer_len) < 1
      raise("Could not finalize hmac")
    end
    LibCrypto.hmac_ctx_cleanup(@ctx)
    @finalized = true
    buffer[0, buffer_len]
  end

  # Returns the calculated HMAC digest formatted as
  # a hexadecimal string. This is necessary to safely transfer
  # the digest where binary messages are not allowed.
  #
  # See also `#digest`.
  def hexdigest
    digest.hexstring
  end

  # Returns the HMAC digest of *data* using the secret *key*.
  #
  # It may contain non-ASCII bytes, including NUL bytes.
  #
  # *algorithm* specifies which `OpenSSL::Algorithm` is to be used.
  # *path* is a Path to a valid file
  def self.digest(algorithm : OpenSSL::Algorithm, key, path : Path) : Bytes
    hmac = HMAC.new(algorithm, key)
    File.open(path, "r") do |io|
      data_slice = Bytes.new(8192)
      loop do
        read = io.read(data_slice)
        break if read < 1
        hmac << data_slice[0, read]
      end
    end
    hmac.digest
  end

  # Returns the HMAC digest of *data* using the secret *key*,
  # formatted as a hexadecimal string. This is necessary to safely transfer
  # the digest where binary messages are not allowed.
  #
  # See also `#digest`.
  def self.hexdigest(algorithm : OpenSSL::Algorithm, key, path : Path) : String
    digest(algorithm, key, path).hexstring
  end
end
