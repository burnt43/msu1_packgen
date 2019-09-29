class Msu1Packgen::ArgumentParser
  class << self
    def parse(argv)
      options = OpenStruct.new
      options.packdef = nil
      options.prefix = nil
      options.destdir = nil
      options.randomize_alternates = false

      options.packdef = argv[0]

      option_parser = OptionParser.new do |opts|
        opts.banner = "Usage: msu1_packgen.rb PACKDEF [options]"

        opts.on('-p', '--prefix=PREFIX', 'prefix for the pcm files') do |prefix|
          options.prefix = prefix
        end

        opts.on('-d', '--destdir=DESTDIR', 'directory to write files to') do |destdir|
          options.destdir = destdir
        end

        opts.on(
          '-r',
          '--randomize-alternates',
          'randomly choose the configured track or one of the alternates'
        ) do |randomize_alternates|
          options.randomize_alternates = randomize_alternates
        end

        opts.on_tail('-h', '--help', 'show this message') do
          puts opts
          exit
        end

      end

      option_parser.parse!(argv)

      validate_options(options)
      options
    end

    private

    def validate_options(options)
      unless options.packdef
        print_error("PACKDEF is required")
      end
    end

    def print_error(msg)
      puts "[\033[0;31mERROR\033[0;0m] - #{msg}"
      exit 1
    end
  end
end
