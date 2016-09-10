# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  first_name             :string
#  last_name              :string
#  username               :string
#  role                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  advanced               :boolean          default(FALSE)
#  multi_rates            :boolean          default(FALSE)
#

class UsersController < ApplicationController
  def index
    @import  = User::Import.new
    @users = User.all
    respond_to do |format|
      format.html
      format.csv { send_data @users.distinct.to_csv, filename: "users-export-#{Time.current}.csv" }
    end 
  end
  
  def import
    @import  = User::Import.new(user_import_params)
    if @import.save
      redirect_to users_index_path, notice: "Imported #{@import_count} commissions."
    else
      flash[:alert] = "There were errors with your CSV file."
      render action: :index
    end
    
  end

  def profile
    @user = User.find(params[:id])
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to profile_path(@user), notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def user_import_params
      params.require(:user_import).permit(:file)
  end
  def user_params
      params.require(:user).permit(:first_name, :last_name, :username, :email, :role)
  end
end
