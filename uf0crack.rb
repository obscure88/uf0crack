$VERBOSE = nil

require 'colorize'
require 'digest'
require 'optparse'
require 'parallel'

def banner_bunjo
  banner_text = <<-'BANNER'

░█░█░█▀▀░▄▀▄░█▀▀░█▀▄░█▀█░█▀▀░█░█
░█░█░█▀▀░█/█░█░░░█▀▄░█▀█░█░░░█▀▄
░▀▀▀░▀░░░░▀░░▀▀▀░▀░▀░▀░▀░▀▀▀░▀░▀
  ---------------------------- Author: Bunjo -------------------------------------
  BANNER

  puts banner_text.red
end

$options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: ruby uf0crack.rb [options] <hash_to_crack>"

  opts.on("-w", "--wordlist PATH", "Wordlist path") do |path|
    $options[:wordlist] = path
  end

  opts.on("-h", "--hash HASH", "Hash to crack") do |hash|
    $options[:hash] = hash
  end

  opts.on("-a", "--algorithm ALGORITHM", "Hash algorithm") do |algorithm|
    $options[:algorithm] = algorithm
  end
end.parse!

def encode_lines(lines, algorithm)
  case algorithm.downcase
  when "md5"
    lines.map { |line| Digest::MD5.hexdigest(line) }
  when "sha1"
    lines.map { |line| Digest::SHA1.hexdigest(line) }
  when "sha2"
    lines.map { |line| Digest::SHA2.hexdigest(line) }
  when "sha256"
    lines.map { |line| Digest::SHA256.hexdigest(line) }
  when "sha384"
    lines.map { |line| Digest::SHA384.hexdigest(line) }
  when "sha512"
    lines.map { |line| Digest::SHA512.hexdigest(line) }
  when "ripemd160"
    lines.map { |line| Digest::RMD160.hexdigest(line) }
  when "whirlpool"
    lines.map { |line| Digest::Whirlpool.hexdigest(line) }
  when "sha3"
    lines.map { |line| Digest::SHA3.hexdigest(line) }
  else
    raise "Invalid algorithm: #{algorithm}"
  end
end

def print_usage
  usage_text =  <<~USAGE
    Usage: ruby uf0crack.rb [options] <hash_to_crack>

    Options:
      -w, --wordlist PATH : Wordlist path
      -h, --hash HASH     : Hash to crack
      -a, --algorithm ALGORITHM : Hash algorithm
  USAGE

  puts usage_text
end

def crack(options)
  if $options[:wordlist].nil? || options[:hash].nil? || options[:algorithm].nil?
    banner_bunjo
    puts "Error: The required arguments are missing.".red
    print_usage
  else
    banner_bunjo
    $wordlist_path = options[:wordlist]
    $hash_to_crack = options[:hash]
    $algorithm = options[:algorithm]

    def process_chunk(chunk)
      found_password = false
      hashed_lines = encode_lines(chunk, $algorithm)

      chunk.each_with_index do |line, index|
        if hashed_lines[index] == $hash_to_crack
          puts "Cracked: #{$hash_to_crack}:#{line}".green
          puts "Finished at: #{Time.now}"
          found_password = true
          Thread.current.kill
        end
      end

      if found_password
        Thread.list.each do |t|
          next if t == Thread.current
          t.kill
        end
      end
    end

    wordlist = File.readlines($wordlist_path).map(&:chomp)

    chunk_size = wordlist.length / Parallel.processor_count
    chunks = wordlist.each_slice(chunk_size).to_a

    def started_page
      puts "uf0crack started at: #{Time.now}"
      puts "Hash: #{$hash_to_crack.magenta}"
      puts "Algorithm: #{$algorithm.red}"
      puts "Wordlist: #{$wordlist_path.blue}"
    end

    started_page
    password_found = false

    begin
      Parallel.map(chunks, in_processes: Parallel.processor_count) do |chunk|
        process_chunk(chunk)
      end
    rescue Parallel::DeadWorker => e
      # Hata olursa ekrana bir şey yazma
    end
  end
end


crack($options)
