class FakeCollectionProxy < Array
  def find(*args)
    super(*args) || raise(ActiveRecord::RecordNotFound.new)
  end
end
