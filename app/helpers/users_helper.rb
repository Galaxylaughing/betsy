module UsersHelper  
  def mask_cc(cc_num)
    return "[unknown]" unless cc_num
    # from https://stackoverflow.com/questions/1904573/string-operation-in-ruby-for-credit-card-number
    masked = cc_num.gsub(/.(?=....)/, '*')
    return masked
  end
end
