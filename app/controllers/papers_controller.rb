class PapersController < ApplicationController
  before_action :set_paper, only: [:show, :edit, :update, :destroy]

  # GET /papers
  # GET /papers.json
  def index
    @papers = Paper.all
  end

  # GET /papers/1
  # GET /papers/1.json
  def show
    papers=Paper.order(created_at: :desc)
    papers.each do |paper|
      if paper.status==0
        @paper=paper
        break
      end
    end
    current_user.credits+=1
    current_user.save
    if !@paper.present?
      redirect_to user_path
    end
    @paper.status=1
    send_data @paper.file_contents, type: @paper.content_type, filename: 'foo.docx'
  end

  


  # GET /papers/new
  def new
    @paper = Paper.new
  end

  # GET /papers/1/edit
  def edit
  end

  # POST /papers
  # POST /papers.json
  def create
    if current_user.credits <=0
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'Insuficient credits.' }
      end
  else
    @paper = Paper.new(paper_params)
    @paper.author=current_user.email
    respond_to do |format|
      if @paper.save
        @user=current_user
        current_user.credits-=1
        current_user.save
        format.html { redirect_to users_path, notice: 'Paper was successfully created.' }
        format.json { render :show, status: :created, location: @paper }
      else
        format.html { render :new }
        format.json { render json: @paper.errors, status: :unprocessable_entity }
      end
    end
  end
  end

  # PATCH/PUT /papers/1
  # PATCH/PUT /papers/1.json
  def update
    respond_to do |format|
      if @paper.update(paper_params)
        format.html { redirect_to @paper, notice: 'Paper was successfully updated.' }
        format.json { render :show, status: :ok, location: @paper }
      else
        format.html { render :edit }
        format.json { render json: @paper.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /papers/1
  # DELETE /papers/1.json
  def destroy
    @paper.destroy
    respond_to do |format|
      format.html { redirect_to papers_url, notice: 'Paper was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_paper
      @paper = Paper.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def paper_params
      params.require(:paper).permit(:file)
    end
end
