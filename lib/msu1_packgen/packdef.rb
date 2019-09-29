class Msu1Packgen::Packdef
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
