class Msu1Packgen::Generator
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
    Pathname.new("./config/packdefs/#{packdef_name}.yaml")
  end

  def packdef
    @packdef ||= Msu1Packgen::Packdef.new(packdef_path)
  end

  def trackdef_name
    packdef.trackdef_name
  end

  def trackdef_path
    Pathname.new("./config/trackdefs/#{packdef.trackdef_name}.yaml")
  end

  def trackdef
    @trackdef ||= Msu1Packgen::Trackdef.new(trackdef_path)
  end
end
