class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]
  before_action :set_budget

  # GET /transactions
  # GET /transactions.json
  def index
    @transactions = Transaction.all
    @total_debit = BigDecimal.new(0)
    @total_credit = BigDecimal.new(0)

    @transactions.each do |transaction|
      if transaction.txn_type == 'Credit'
        @total_credit += transaction.monthly_amount
      else
        @total_debit += transaction.monthly_amount
      end
    end
  end

  # GET /transactions/1
  # GET /transactions/1.json
  def show
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
  end

  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions
  # POST /transactions.json
  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.budget_id = @budget.id

    respond_to do |format|
      if @transaction.save
        flash[:success] = 'Transaction was successfully created.'
        format.html { redirect_to budget_transactions_path(budget: @budget) }
        format.json { render :show, status: :created, location: @transaction }
      else
        format.html { render :new }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transactions/1
  # PATCH/PUT /transactions/1.json
  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        flash[:success] = 'Transaction was successfully updated.'
        format.html { redirect_to budget_transactions_path(budget: @budget) }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1
  # DELETE /transactions/1.json
  def destroy
    @transaction.destroy
    respond_to do |format|
      flash[:success] = 'Transaction was successfully destroyed.'
      format.html { redirect_to budget_transactions_path(budget: @budget) }
      format.json { head :no_content }
    end
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
