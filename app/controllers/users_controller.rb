class UsersController < InheritedResources::Base


  # this class should be co-operating with active admin, should be possible to delete if the new
  # admin function is stable
  private

    def user_params
      params.require(:user).permit()
    end
end
