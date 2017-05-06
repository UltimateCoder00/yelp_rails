class ReviewsController < ApplicationController
before_action :authenticate_user!
  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.new
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = @restaurant.reviews.build_with_user(review_params, current_user)

    if @review.save
      redirect_to '/restaurants'
    else
      if @review.errors[:user]
        redirect_to restaurants_path, alert: "You have already reviewed this restaurant"
      else
        render :new
      end
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    flash[:notice] = "Review deleted successfully"
    redirect_to '/restaurants'
  end

  private

  def review_params
    params.require(:review).permit(:thoughts, :rating)
  end
end
