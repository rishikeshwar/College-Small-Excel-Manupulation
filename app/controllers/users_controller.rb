class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_action :authorize, only: [:new, :create, :index]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
    @journalsaccepted = Journal.where("status like ?", "%ccept%")
    @journalspublished = Journal.where("status like ?", "%ublish%")
    @journalsrejected = Journal.where("status like ?", "%eject%")
    @journalspresented = Journal.where("status like ?", "%resent%")
    @journalssubmitted = Journal.where("status like ?", "%ubmitte%")
    @user = User.find(session[:user_id])
    if @user.name != 'rishikeshwar'
      redirect_to login_url
    end
  end

  # GET /users/1
  # GET /users/1.json
    
  def loadstats
      
    @journalsaccepted = Journal.where("status like ?", "%ccept%")
    @journalspublished = Journal.where("status like ?", "%ublish%")
    @journalsrejected = Journal.where("status like ?", "%eject%")
    @journalspresented = Journal.where("status like ?", "%resent%")
    @journalssubmitted = Journal.where("status like ?", "%ubmitte%")
      
    require 'rubyXL'
      
    workbook = RubyXL::Parser.parse("/home/administrator/ri.xlsx")
    pos = 0
    start = 0
    0.upto(10000) do |i|
    	if workbook[0][i][0].value == 1
    		start = i
    		break
    	end
    end

    @ending = Journal.order('id DESC').first
    endo = 0
    
    start.upto(1000) do |i| 
    	if workbook[0][i][0].value == @ending['id']
            endo = i + 5
    		break
    	end
    end
      
    workbook[0].add_cell(endo + 0, 1, "Accepted").change_horizontal_alignment('center')
    workbook[0].add_cell(endo + 0, 2, "#{@journalsaccepted.length}").change_horizontal_alignment('center')
    workbook[0].add_cell(endo + 1, 1, "Published").change_horizontal_alignment('center')
    workbook[0].add_cell(endo + 1, 2, "#{@journalspublished.length}").change_horizontal_alignment('center')
    workbook[0].add_cell(endo + 2, 1, "Rejected").change_horizontal_alignment('center')
    workbook[0].add_cell(endo + 2, 2, "#{@journalsrejected.length}").change_horizontal_alignment('center')
    workbook[0].add_cell(endo + 3, 1, "Presented").change_horizontal_alignment('center')
    workbook[0].add_cell(endo + 3, 2, "#{@journalspresented.length}").change_horizontal_alignment('center')
    workbook[0].add_cell(endo + 4, 1, "Submitted").change_horizontal_alignment('center')
    workbook[0].add_cell(endo + 4, 2, "#{@journalssubmitted.length}").change_horizontal_alignment('center')
    
      
    workbook.write('/home/administrator/ri.xlsx')
    workbook = nil
    redirect_to users_path
  end

  def show
    curruser = User.find(session[:user_id])
    curruser = curruser.name.downcase
    @journals = Journal.where("author like ?", "%#{curruser}%")
  end

  def loaddata
    puts "yes being called"

    require 'rubyXL'
      
    workbook = RubyXL::Parser.parse("/home/administrator/ri.xlsx")
    workbook = workbook['Sheet1']
    puts "#{workbook[1][2].value}"
    6.upto(139) do |i|
        @datasave = Journal.new
        @datasave.id = workbook[i][0].value
        @datasave.title = workbook[i][1].value
        @datasave.author = workbook[i][2].value
        @datasave.status = workbook[i][3].value
        @datasave.JorC = workbook[i][4].value
        @datasave.scopus = workbook[i][5].value
        @datasave.affiliations = workbook[i][6].value
        @datasave.amritapapers = workbook[i][7].value
        @datasave.coauthor = workbook[i][9].value
        @datasave.communicated = workbook[i][9].value
        @datasave.paperbefore = workbook[i][10].value
        @datasave.save
    end
    redirect_to users_path
  end
    
  def loadfac
      workbook = RubyXL::Parser.parse("/home/administrator/fac.xlsx")
      1.upto(31) do |i|
          @datasave = Facid.new
          @datasave.colid = workbook[0][i][2].value
          @datasave.name = workbook[0][i][3].value
		  @datasave.save
      end
      redirect_to users_path
  end
    
  def newJournal 
      
  end
    
  def createJournal
    
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if User.find_by(name: user_params[:name]).present? == false and @user.save
        format.html { redirect_to login_url, alert: 'Account was successfully created. Log in' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { redirect_to new_user_url, alert: 'Something is missing or user already exists' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end

    require 'bigbertha'

    ref = Bigbertha::Ref.new( 'https://sample-project-a05a8.firebaseio.com' )

    data = {
      k: {
        a: 0,
        b: %s(Hello World),
        c: 10.5
      }
    }
    ref.push( data )
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation)
    end
end
