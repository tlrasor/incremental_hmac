require "benchmark"

require "../src/incremental_hmac"

SMALL_TEST_DATA = Path[__FILE__].parent.parent.join("spec", "jekyll_hyde.txt")
KEY             = "6ed117753cb1f2684a8a9b4b090ba368d3bb69b6847cb7aa42b695808a8ac9f4"

def run_string(data)
  OpenSSL::HMAC.hexdigest(OpenSSL::Algorithm::SHA256, KEY, data)
end

def run_path(data : Path)
  OpenSSL::HMAC.hexdigest(OpenSSL::Algorithm::SHA256, KEY, data)
end

puts "starting benchmarks"
Benchmark.bm do |bm|
  # tot = 0
  bm.report("small test files") do
    run_string(File.read(SMALL_TEST_DATA))
    # tot += 1
  end

  bm.report("small test files2") do
    run_path(SMALL_TEST_DATA)
  end
end

puts "starting ips tests"

Benchmark.ips do |bm|
  # tot = 0
  bm.report("small test files") do
    run_string(File.read(SMALL_TEST_DATA))
    # tot += 1
  end

  bm.report("small test files2") do
    run_path(SMALL_TEST_DATA)
  end
end
