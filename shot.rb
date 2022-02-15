class Shot
  def initialize(count)
    @count = count
  end

  def count
    if @count == "X"
      10
    elsif @count.nil?
      nil
    else
      @count.to_i
    end
  end
end
