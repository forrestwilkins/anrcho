class NotesController < ApplicationController
  def index
    @notes = Note.unseen.where(receiver_token: security_token)
  end
end


