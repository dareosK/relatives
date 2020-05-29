class FamilyMembersController < ApplicationController
  # skip_before_action :authenticate_user!, only: [:index]

  def index
    if params[:query].present?
      @family_members = FamilyMember.search_by_city(params[:query]).search_by_kinship(params[:kinship])
    else
      @family_members = FamilyMember.order(created_at: :desc).search_by_kinship(params[:kinship])
    end
  end

  def new
    @family_member = FamilyMember.new
    # authorize @family_member
  end

  def create
    @family_member = FamilyMember.new(family_member_params)
    # authorize @family_member
    @family_member.user = current_user
    if @family_member.save!
      redirect_to root_path
    else
      render "new"
    end
  end

  def edit
    @family_member = FamilyMember.find(params[:id])
  end

  def update
    @family_member = FamilyMember.find(params[:id])

    if @family_member.update(family_member_params)
      redirect_to @family_member
    else
      render 'edit'
    end
  end

  def destroy
    @family_member = FamilyMember.find(params[:id])
    @family_member.destroy

    redirect_to root_path
  end

  def show
    @family_member = FamilyMember.find(params[:id])
    @booking = Booking.new
    # authorize @booking
  end

  private

  def family_member_params
    params.require(:family_member).permit(:name, :age, :kinship, :description, :image)
  end
end
