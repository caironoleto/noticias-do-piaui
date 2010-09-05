class DomainsController < ApplicationController
  def show
    @domain = Domain.find_by_slug(params[:slug])
    @articles = @domain.articles.paginate(:per_page => 30, :page => params.fetch(:page, 1).to_i)
  end
end
