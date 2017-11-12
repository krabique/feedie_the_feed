module StringHelper
  # This method is used to validate the behaviour of the truncate method
  def validates?(initial_string, truncate_at, changed_string)
    return true if initial_string.length <= truncate_at ||
                   # https://github.com/rails/rails/issues/30600
                   truncate_at == 1 || truncate_at == 2

    if changed_string.length <= truncate_at &&
       changed_string =~ /.*\.\.\.\z/
      true
    else
      false
    end
  end
end
