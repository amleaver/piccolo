class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]
  before_action :set_budget

  def index
    @transactions = Transaction.all
  end

  def show
  end

  def new
    @transaction = Transaction.new
  end

  def edit
  end

  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.budget_id = @budget.id

    if @transaction.save
      flash[:success] = 'Transaction was successfully created.'
      redirect_to budget_transactions_path
    else
      flash[:danger] = 'Unable to create new transaction.'
      render :new
    end
  end

  def update
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
end
