class TasksController < ApplicationController
  before_action :set_task, only: %i( show edit update destroy )

  def index
    tasks = Task.update_sorted
    tasks = Task.deadline_sorted if params[:sort_expired]
    tasks = Task.priority_sorted if params[:sort_priority]

    if params[:progress].present? || params[:task].present?
      tasks = tasks.progress_search(params[:progress][:name]) if params[:progress][:name].present? #length != 0
      tasks = tasks.name_search(params[:task][:search]) if params[:task].present?
    end
    
    @tasks = tasks.user_sorted(current_user.id).page(params[:page]).per(10)
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)
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
    params.require(:task).permit(:name, :explanation, :deadline, :progress, :priority)
  end

  def set_task
    @task = Task.find(params[:id])
  end

end
