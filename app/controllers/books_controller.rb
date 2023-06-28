class BooksController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]
  def index
    @books = Book.all
    @user_info = Book.new
  end

  def create
    @user_info = Book.new(book_params)
    @user_info.user_id = current_user.id
    if @user_info.save
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@user_info.id)
    else
      @books = Book.all
      render :index
    end
  end

  def show
    @user_info = Book.new
    @book = Book.find(params[:id])
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = "You have update book successfully."
      redirect_to book_path(@book.id)
    else
      render :edit
    end
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def is_matching_login_user
    user = User.find(params[:id])
    unless user.id == current_user.id
      redirect_to books_path
    end
  end

end