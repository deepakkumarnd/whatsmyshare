class ExpensesController < ApplicationController
  before_action :set_expense, only: %i[edit update destroy]
  before_action :set_expense_group, only: %i[new edit create update destroy]
  # GET /expenses/new
  def new
    @expense = @expense_group.expenses.new
    @expense.payers.build
    @expense.debtors.build
  end

  # GET /expenses/1/edit
  def edit
  end

  # POST /expenses or /expenses.json
  def create
    @expense = @expense_group.expenses.new(create_expense_params)

    @expense.amount = @expense.payers.map(&:amount).reduce(:+)

    participants_count = @expense.payers.filter { |x| !x.exclude }.length + @expense.debtors.length

    amount_per_participant = @expense.amount / participants_count

    @expense.debtors.each do |debtor|
      debtor.amount = amount_per_participant
    end

    @expense.payers.each do |payer|
      if payer.amount < amount_per_participant
        diff = amount_per_participant - payer.amount
        @expense.debtors.build(name: payer.name, amount: diff)
      end
    end

    respond_to do |format|
      if @expense.save
        format.html { redirect_to group_path(@expense_group), notice: "Expense was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expenses/1 or /expenses/1.json
  def update
    respond_to do |format|
      if @expense.update(update_expense_params)
        format.html { redirect_to group_path(@expense_group), notice: "Expense was successfully updated." }
        format.json { render :show, status: :ok, location: @expense }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expenses/1 or /expenses/1.json
  def destroy
    @expense.destroy!

    respond_to do |format|
      format.html { redirect_to expenses_url, notice: "Expense was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = Expense.find(params[:id])
    end

    def set_expense_group
      @expense_group = ExpenseGroup.find(params[:group_id])
    end

    # Only allow a list of trusted parameters through.
    def create_expense_params
      params.require(:expense).permit(:description, payers_attributes: [:name , :amount, :exclude, :_destroy], debtors_attributes: [:name, :_destroy])
    end

  def update_expense_params
    params.require(:expense).permit(:description, payers_attributes: [:id, :name , :amount, :exclude, :_destroy], debtors_attributes: [:id, :name, :_destroy])
  end

end
