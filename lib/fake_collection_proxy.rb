class FakeCollectionProxy < Array
  def find(*args)
    super(*args) || -> { raise ActiveRecord::RecordNotFound }.call
  end
end
