class ManifestosController < ApplicationController
  def toggle_manifesto
    cookies.permanent[:manifesto_tip] = true
  end
  
  def index
    @group = Group.find_by_token params[:group_token]
    @proposed_manifestos = Proposal.
      where(action: :update_manifesto).
      where(ratified: [nil, false])
    @proposed_manifestos = if @group.nil?
      @proposed_manifestos.where group_id: nil
    else
      @proposed_manifestos.where group_id: @group.id
    end
  end
end
