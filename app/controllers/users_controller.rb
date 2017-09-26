class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_action :authorize, only: [:new, :create, :index]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
    @user = User.find(session[:user_id])
    if @user.name != 'rishikeshwar'
      redirect_to login_url
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    curruser = User.find(session[:user_id])
    curruser = curruser.name.downcase
    @journals = Journal.where("author like ?", "%#{curruser}%")
  end

  def loaddata
    puts "yes being called"

    require 'rubyXL'
      
    workbook = RubyXL::Parser.parse("/home/rishikeshwar/ri.xlsx")
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
