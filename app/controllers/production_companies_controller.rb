class ProductionCompaniesController < ApplicationController
  def index
    # @production_companies = ProductionCompany.all
    # @production_companies = ProductionCompany.select("production_companies.*")
    #                                           .select("COUNT(production_companies.id) as movie_count")
    #                                           .left_joins(:movies)
    #                                           .group("production_companies.id")
    #                                           .order("movie_count DESC")
    @production_companies = ProductionCompany.orderd_by_movies
  end

  def show
    @production_company = ProductionCompany.find(params[:id])
  end
end

