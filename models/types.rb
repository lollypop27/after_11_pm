require './models/class_names'

include ClassName

module Types
  def numerical?(object)
    object.is_a?(integer) || object.is_a?(float) || object.is_a?(rational)
  end
end
