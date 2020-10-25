module StoreIndexCounter
  private
  def increment_counter
    if session[:store_counter].nil?
      session[:store_counter] = 1
    else
      session[:store_counter] += 1
    end
  end

  def reset_counter
    session[:store_counter] = 0
  end
end