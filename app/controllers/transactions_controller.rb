class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]
  before_action :set_budget

  def index
    @transactions = Transaction.category_order
  end

  def new
    @transaction = Transaction.new
  end

  def edit
  end

  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.budget_id = @budget.id
    set_category

    if @transaction.save
      flash[:success] = 'Transaction was successfully created.'
      redirect_to budget_transactions_path
    else
      flash[:danger] = 'Unable to create new transaction.'
      render :new
    end
  end

  def update
    set_category

    if @transaction.update(transaction_params)
      flash[:success] = 'Transaction was successfully updated.'
      redirect_to budget_transactions_path
    else
      flash[:danger] = 'Unable to update transaction.'
      render :edit
    end
  end

  def destroy
    @transaction.destroy
    flash[:success] = 'Transaction was successfully destroyed.'
    redirect_to budget_transactions_path
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_transaction
    @transaction = Transaction.find(params[:id])
    set_budget
  end

  def set_budget
    @budget = Budget.find(params[:budget_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def transaction_params
    params.require(:transaction).permit(:payee, :notes, :txn_type, :occurs, :amount)
  end

  def set_category
    category_title = params[:transaction_category]
    category_title = 'Uncategorised' if category_title.blank?

    category = @budget.categories.where(title: category_title).first
    if category.nil?
      category = @budget.categories.create!(title: category_title)
    end

    @transaction.category = category
  end
end
