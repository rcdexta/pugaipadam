class ConsultantsController < ApplicationController

  before_action :authenticate_consultant!, only: [:edit, :update]
  before_action :authorize_consultant!, only: [:edit]

  def index
    consultants = Rails.cache.fetch('consultants', expires_in: 1.hour) do
      Consultant.includes(:persona, :project).all.inject({}) { |r, con|  r[con.employee_id] = map_for(con); r }
    end
    render json: consultants
  end

  def edit
    @consultant = Consultant.find_by employee_id: params[:id]
    @consultant.build_persona if @consultant.persona.nil?
  end

  def update
    @consultant = Consultant.find_by employee_id: params[:consultant][:employee_id]
    @consultant.image_data = consultant_params.delete(:image_data)
    if @consultant.update_attributes consultant_params
      flash.keep[:alert] = 'Your profile has been updated!'
      Rails.cache.delete 'consultants'
    end
    render :edit
  end

  def show
    @consultant = Consultant.includes([:project, :persona]).find_by employee_id: params[:id]
    render :show, layout: false
  end

  private

  def authorize_consultant!
    if current_consultant.employee_id.to_s != params[:id]
      render template: 'devise/sessions/authorized'
    end
  end

  def consultant_params
    params[:consultant].permit(:photo, :employee_id, :name, :nickname, :mobile, :image_data, :password, :password_confirmation,
                               persona_attributes: [:twitter, :github, :stackoverflow, :blog, :good_reads])
  end

  def map_for(con)
    {
        name: con.name,
        mobile: con.mobile,
        email: con.email,
        role: con.role,
        grade: con.grade,
        exp: con.experience,
        twexp: con.tw_experience,
        skills: '',
        currentproject: con.project.try(:account_name),
        photo: con.photo.url(:thumb),
        profile_photo: con.photo.url(:profile)
    }
  end
end
