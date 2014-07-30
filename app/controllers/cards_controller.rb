class CardsController < ApplicationController
  before_action :set_card, only: [:show, :edit, :update, :destroy]

  # GET /cards
  # GET /cards.json
  def index
    @cards = Card.all
  end

  # GET /cards/1
  # GET /cards/1.json
  def show
  end

  # GET /cards/new
  def new
    # binding.pry
    @card = Card.new
  end

  # GET /cards/1/edit
  def edit
  end

  # POST /cards
  # POST /cards.json
  def create
    @card = Card.new
    @card.sender_email = params[:card][:sender_email]
    @card.recipient_email = params[:card][:recipient_email]
    @card.sender_name = params[:card][:sender_name]
    @card.recipient_name = params[:card][:recipient_name]

    # raise params.inspect
    uploaded_io = params[:card][:photo]
    # uploaded_filename = (Time.now.to_f * 1000).to_i.to_s + uploaded_io.original_filename

    # File.open(Rails.root.join('public', 'images',uploaded_filename), 'wb') do |file|
    #   file.write(uploaded_io.read)
    # end

    s3= AWS::S3.new
    bucket_name = 'FlatironPostcard'
    key = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
    s3.buckets[bucket_name].objects[key].write(:file => uploaded_io)
    s3.buckets[bucket_name].objects[key].acl = :public_read

    @card.path = "https://s3.amazonaws.com/FlatironPostcard/#{key}"

    m = Mandrill::API.new
    message = {  
     :subject=> "You've received a postcard from FlatironPostcard",  
     :from_name=> @card.sender_name,
     :text=>"You've received a postcard from FlatironPostcard, but you have HTML emails disabled. Sorry!",  
     :to=>[  
       {  
         :email=> @card.recipient_email,  
         :name=> @card.recipient_name 
       }  
     ],  
     :html=>render_to_string('user_mailer/welcome_email', :layout => false),  
     :from_email=> @card.sender_email  
    }  
    sending = m.messages.send message 
    # raise sending.inspect

    respond_to do |format|
      if @card.save
        # Tell the UserMailer to send a welcome email after save
        # UserMailer.welcome_email(@card).deliver

        format.html { redirect_to @card, notice: 'Card was successfully created.' }
        format.json { render :show, status: :created, location: @card }
      else
        format.html { render :new }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cards/1
  # PATCH/PUT /cards/1.json
  def update
    respond_to do |format|
      if @card.update(card_params)
        format.html { redirect_to @card, notice: 'Card was successfully updated.' }
        format.json { render :show, status: :ok, location: @card }
      else
        format.html { render :edit }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cards/1
  # DELETE /cards/1.json
  def destroy
    @card.destroy
    respond_to do |format|
      format.html { redirect_to cards_url, notice: 'Card was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_card
      @card = Card.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def card_params
      params.require(:card).permit(:sender_email, :recipient_email, :sender_name, :recipient_name)
    end
end
