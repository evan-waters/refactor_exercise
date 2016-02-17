class People < ActionController::Base

  # ... Other REST actions

  def create
    @person = Person.new(person_params.merge(admin: false))

    if @person.save
      redirect_to @person, :notice => "Account added!"
    else
      render :new
    end
  end

  def validateEmail
    @user = Person.find_by_slug(params[:slug])
    if @user.present?
      @user.validate_email
      @user.send_welcome_email
    end
  end

  private

  def person_params
    params.require(:person).permit(:first_name, :last_name, :email)
  end

end