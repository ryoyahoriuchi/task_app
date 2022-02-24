class TasksController < ApplicationController
  before_action :set_task, only: %i( show edit update destroy )

  def index
    if params[:sort_expired]
      @task = Task.all.order('deadline DESC')
    else
      @task = Task.all.order('updated_at DESC')
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_path, notice: "タスクを作成しました"
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: "タスクを編集しました"
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: "タスクを削除しました"
  end

  private

  def task_params
    params.require(:task).permit(:name, :explanation, :deadline)
  end

  def set_task
    @task = Task.find(params[:id])
  end

end
