class ExpenseGroupsController < ApplicationController
  before_action :set_expense_group, only: %i[ show edit update settle destroy ]

  # GET /expense_groups or /expense_groups.json
  def index
    @expense_groups = ExpenseGroup.all
  end

  # GET /expense_groups/1 or /expense_groups/1.json
  def show
    service = ExpenseService.instance
    @summary = service.build_summary(@expense_group)
    @action_graph = service.build_action_graph(@summary)
  end

  # GET /expense_groups/new
  def new
    @expense_group = ExpenseGroup.new
  end

  # GET /expense_groups/1/edit
  def edit
  end

  # POST /expense_groups or /expense_groups.json
  def create
    @expense_group = ExpenseGroup.new(expense_group_params)

    respond_to do |format|
      if @expense_group.save
        format.html { redirect_to group_url(@expense_group), notice: "Expense group was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expense_groups/1 or /expense_groups/1.json
  def update
    respond_to do |format|
      if @expense_group.update(expense_group_params)
        format.html { redirect_to group_path(@expense_group), notice: "Expense group was successfully updated." }
        format.json { render :show, status: :ok, location: @expense_group }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @expense_group.errors, status: :unprocessable_entity }
      end
    end
  end

  def settle
    respond_to do |format|
      if @expense_group.update(is_settled: true)
        format.html { redirect_to group_path(@expense_group), notice: "Expense has been marked as settled." }
        format.json { render :show, status: :ok, location: @expense_group }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @expense_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expense_groups/1 or /expense_groups/1.json
  def destroy
    @expense_group.destroy!

    respond_to do |format|
      format.html { redirect_to group_index_path, notice: "Expense group was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense_group
      @expense_group = ExpenseGroup.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def expense_group_params
      params.require(:expense_group).permit(:description)
    end
end
