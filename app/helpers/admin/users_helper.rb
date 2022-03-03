module Admin::UsersHelper
  def choose_new_or_edit
    if action_name == 'new'
      admin_users_path
    elsif action_name == 'edit'
      admin_user_path(@user.id)
    end
  end

  def admin_user
    unless current_user.admin
      flash[:danger] = "管理者以外はアクセス出来ないアドレスです"
      redirect_to tasks_path
    end
  end
end
