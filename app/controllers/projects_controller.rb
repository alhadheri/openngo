class ProjectsController < ApplicationController
  load_and_authorize_resource
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.page(params[:page]).per(12)
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @members = Member.where.not(id: @project.members.ids)   
    @activities = PublicActivity::Activity.all.order("created_at desc")
  end

  # GET /projects/new
  def new
    @project = Project.new
    @project.project_attachments.build
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
  
    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update

    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def add_member
    ProjectMember.create({project_id: params[:project_id], member_id: params[:member_id]})
    redirect_to project_path(params[:project_id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, :budget, :from, :to, :branch_id, :location_id, :goal, :description, :tag_names, :currency, :created_by, :updated_by, project_attachments_attributes: [ :id, :file], translations_attributes: [:id, :locale, :name, :description], members_attributes: [:id,:name])
    end
end
