require "administrate/field/base"

class UnlimitedHasManyField < Administrate::Field::HasMany
  def resources
    data
  end
end
