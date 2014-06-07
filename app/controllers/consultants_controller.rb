class ConsultantsController < ApplicationController

  def index
    results = {}
    Consultant.includes(:persona, :project).all.each do |con|
      results[con.employee_id] = map_for(con)
    end
    render json: results
  end

  def edit
    @consultant = Consultant.find_by employee_id: params[:id]
    @consultant.build_persona if @consultant.persona.nil?
  end

  def update
    @consultant = Consultant.find_by employee_id: params[:consultant][:employee_id]
    if @consultant.update_attributes! consultant_params
      flash.keep[:notice] = "Your profile has been updated!"
      redirect_to root_path
    else
      render :edit
    end
  end

  def show
    @consultant = Consultant.includes([:project, :persona]).find_by employee_id: params[:id]
    render :show, layout: false
  end

  private

  def consultant_params
    params[:consultant].permit(:photo, :employee_id, :name, :nickname, :mobile, :image_data,
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
        skills: "",
        currentproject: con.project.try(:account_name),
        photo: con.photo.url(:thumb)
    }
  end
end
