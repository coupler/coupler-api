Sequel.migration do
  up do
    from(:datasets).where(pending: nil).update(pending: false)
  end
end
