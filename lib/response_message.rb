# -*- encoding : utf-8 -*-
class ResponseMessage
  class IndividualMessage
    def initialize(id, message)
      @id = id
      @message = message
    end
  end

  def initialize
    @messages = []
  end

  def add_message(id, message)
    @messages.push(IndividualMessage.new(id, message))
  end
end
