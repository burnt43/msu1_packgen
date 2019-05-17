require 'pathname'
require 'yaml'
 
require 'optparse'
require 'ostruct'
class ArgumentParser
  def self.parse(argv)
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

  def self.validate_options(options)
    unless options.packdef
      print_error("PACKDEF is required")
    end
  end

  def self.print_error(msg)
    puts "[\033[0;31mERROR\033[0;0m] - #{msg}"
    exit 1
  end
end

class Msu1Packgen
  def initialize(options)
    @options = options
  end

  def run!
    trackdef.track_name_to_number_mapping.each do |track_name, track_number|
      puts packdef.path_for_track_name(track_name, randomize_alternates: randomize_alternates?)
      puts dest_file_path(track_number)

      # TODO: write cp command here
    end
  end

  private

  def destdir_path
    @destdir_path ||=
      if @options.destdir
        Pathname.new(@options.destdir)
      else
        Pathname.new('./')
      end
  end

  def dest_file_path(track_number)
    destdir_path.join("#{prefix}-#{track_number}.pcm")
  end

  def prefix
    @options.prefix || trackdef_name
  end

  def randomize_alternates?
    @options.randomize_alternates
  end

  def packdef_name
    @options.packdef
  end

  def packdef_path
    Pathname.new("./packdefs/#{packdef_name}.yaml")
  end

  def packdef
    @packdef ||= Packdef.new(packdef_path)
  end

  def trackdef_name
    packdef.trackdef_name
  end

  def trackdef_path
    Pathname.new("./trackdefs/#{packdef.trackdef_name}.yaml")
  end

  def trackdef
    @trackdef ||= Trackdef.new(trackdef_path)
  end

  class Packdef
    def initialize(packdef_path)
      @raw_data = YAML.load(IO.read(packdef_path))
    end

    def trackdef_name
      @raw_data['track_def']
    end

    def dir_path
      @dir_path ||= Pathname.new(@raw_data['directory'])
    end

    def path_for_track_name(track_name, randomize_alternates: false)
      configured_filename = @raw_data.dig('map', track_name)

      partial_filename =
        if randomize_alternates
          possible_names = [configured_filename]
          possible_names.concat(@raw_data.dig('alternates', track_name) || [])

          possible_names[Random.rand(possible_names.size)]
        else
          configured_filename
        end

      dir_path.join("#{partial_filename}.pcm")
    end
  end

  class Trackdef
    def initialize(trackdef_path)
      @raw_data = YAML.load(IO.read(trackdef_path))
    end

    def track_name_to_number_mapping
      @raw_data
    end
  end
end

options = ArgumentParser.parse(ARGV)
Msu1Packgen.new(options).run!
