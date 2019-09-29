class Msu1Packgen::Trackdef
  def initialize(trackdef_path)
    @raw_data = YAML.load(IO.read(trackdef_path))
  end

  def track_name_to_number_mapping
    @raw_data
  end
end
