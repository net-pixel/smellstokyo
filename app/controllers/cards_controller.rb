class CardsController < ApplicationController
  before_action :set_card, only: [:new, :show, :destroy]
  before_action :set_payjpSecretKey, except: :new
  before_action :set_cart
  before_action :set_user

  require "payjp"

  def new
    redirect_to action: :show, id: current_user.id if @card.present?
    @card = Card.new 
    gon.payjpPublicKey = Rails.application.credentials[:payjp][:PAYJP_PUBLIC_KEY]
  end

  def create
    render action: :new if params['payjpToken'].blank?
    customer = Payjp::Customer.create(
      card: params['payjpToken']
    )
    @card = Card.new(
      card_id: customer.default_card,
      user_id: current_user.id,
      customer_id: customer.id
    )
    if @card.save
      flash[:notice] = 'クレジットカードの登録が完了しました'
      redirect_to action: :show, id: current_user.id
    else
      flash[:alert] = 'クレジットカード登録に失敗しました'
      redirect_to action: :new
    end
  end

   def show
    redirect_to action: :new if @card.blank?
    customer = Payjp::Customer.retrieve(@card.customer_id)
    default_card_information = customer.cards.retrieve(@card.card_id)
    @card_info = customer.cards.retrieve(@card.card_id)
    @exp_month = default_card_information.exp_month.to_s
    @exp_year = default_card_information.exp_year.to_s.slice(2,3)
    customer_card = customer.cards.retrieve(@card.card_id)
    @card_brand = customer_card.brand
    case @card_brand
    when "Visa"
      @card_src = "icon_visa.png"
    when "JCB"
      @card_src = "icon_jcb.png"
    when "MasterCard"
      @card_src = "icon_mastercard.png"
    when "American Express"
      @card_src = "icon_amex.png"
    when "Diners Club"
      @card_src = "icon_diners.png"
    when "Discover"
      @card_src = "icon_discover.png"
    end
  end

  def destroy
    customer = Payjp::Customer.retrieve(@card.customer_id)
    @card.destroy
    customer.delete
    flash[:notice] = 'クレジットカードが削除されました'
    redirect_to controller: :users, action: :show, id: current_user.id
  end

  private
  def set_card
    @card = Card.where(user_id: current_user.id).first
  end

  def set_payjpSecretKey
    Payjp.api_key = Rails.application.credentials[:payjp][:PAYJP_SECRET_KEY]
  end

  def set_cart
    @cart = current_cart
  end

  def set_user
    @user = current_user
  end
end
