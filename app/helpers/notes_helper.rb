module NotesHelper
  def unseen_notes
    Note.unseen.where(receiver_token: security_token)
  end
end
