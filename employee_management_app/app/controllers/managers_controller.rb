class ManagersController < ApplicationController
  before_action :set_manager, only: %i[edit update destroy]

  def index
    @managers = Manager.includes(:employees).alphabetical
  end

  def new
    @manager = Manager.new
  end

  def create
    @manager = Manager.new(manager_params)
    if @manager.save
      redirect_to departments_path, notice: "Manager was created. Add a department before creating employees."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @manager.update(manager_params)
      redirect_to managers_path, notice: "Manager was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @manager.destroy
    redirect_to managers_path, notice: "Manager was deleted. Their employees are now unassigned.", status: :see_other
  end

  private

  def set_manager
    @manager = Manager.find(params[:id])
  end

  def manager_params
    params.require(:manager).permit(:first_name, :last_name, :email, :phone)
  end
end
