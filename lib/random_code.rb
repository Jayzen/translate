module RandomCode
  class << self
    def generate_utoken len = 8
      a = lambda { rand(36).to_s(36) }
      token = ""
      len.times { |t| token << a.call.to_s }
      token
    end

    def generate_name_uuid
      Date.today.to_s.split('-')[1..-1].join() << generate_utoken(6).upcase
    end
  end
end
