class PapersController < ApplicationController
  before_action :set_paper, only: [ :destroy]

  # GET /papers
  # GET /papers.json
  def index
    @papers = Paper.all
  end

  # GET /papers/1
  # GET /papers/1.json
  def show

  end

  
  # GET /papers/new
  def new
    @paper = Paper.new
  end

  # GET /papers/1/edit
  def edit
    @paper = Paper.new
  end

  def upload_edit
    @paper = Paper.new
  end

  def finish_edit(paper_params)
    puts "in finish edit"
    if current_user.paper.status=='downloaded'
      edited = Paper.new(paper_params)
      paper=current_user.paper
      paper.status = "edited"
      paper.user = nil
      paper.save
      current_user.paper=nil
      current_user.save
      edited.author=paper.author
      edited.filename='Edited_'<<paper.filename
      edited.save
      edited.status="edit"
      edited.save
      Notifier.sample_email(edited).deliver
      flash[:notice]="Edit succesfully uploaded"
      redirect_to root_path
    else
     flash[:notice]="Something went wrong"
     current_user.paper.status='downloaded'
     paper=current_user.paper
     paper.user=nil
     paper.save
     current_user.paper=nil
     current_user.save
     redirect_to root_path
   end
 end
  # POST /papers
  # POST /papers.json
  def create
    if current_user.paper.present? and current_user.paper.status=='downloaded'
      self.finish_edit(paper_params)
    else
      if current_user.credits < 1
        flash[:notice]="Insuficient credits"
        redirect_to root_path
      else
        paper = Paper.new(paper_params)
        paper.author=current_user.email
        respond_to do |format|
          if paper.save
            current_user.credits-=1
            current_user.save
            format.html { redirect_to root_path, notice: 'Paper was successfully created.' }
          else
            format.html { render :new }
          end
        end
      end
    end
  end



  def download
    if current_user.paper.present?  
      if current_user.paper.status == "downloaded"
        flash[:notice]="Outstanding Edits Due"
      else
        if current_user.paper.status == "created" or current_user.paper.status == "edited"
          paper=current_user.paper
          current_user.paper = nil
          paper.user=nil
          paper.save
          current_user.save
          flash[:notice]="Something went wrong. Try again"
        end
      end
    end
    download=nil
    papers=Paper.order(created_at: :desc)

    papers.each do |paper|
      puts paper.status
      if paper.status == 'created'
        puts "we got one!"
        download=paper
      end
      if download.present?
        send_data download.file_contents, type: download.content_type, filename: download.filename
        paper.user=current_user
        paper.status='downloaded'
        paper.updated_at=Time.current
        paper.save
        break
      end
    end
    if not download.present?
      flash[:notice]="No papers available to download"
    end
  end

  # PATCH/PUT /papers/1
  # PATCH/PUT /papers/1.json
  def update

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
      params.require(:paper).permit(:file,:type)
    end
  end
