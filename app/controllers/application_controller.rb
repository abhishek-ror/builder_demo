class ApplicationController < ActionController::Base
  protect_from_forgery unless: -> { request.format.json? }

  def page_from_params
    @page = params[:page] = [params[:page].to_i, 1].max
    @per_page = params[:limit] = params[:limit].present? ? params[:limit].to_i : 25
  end

  def pagination(result)
    total_count = result.total_count rescue 0
    total_pages = result.total_pages rescue 1
    {current_page: params[:page], limit: params[:limit], record_count: total_count, total_pages: total_pages}
  end

  def total_pagination(result, result2)
    total_count = result.total_count + result2.total_count rescue 0
    total_pages = result.total_pages rescue 1
    limit = params[:limit] rescue 2
    {current_page: params[:page], limit: limit, record_count: total_count, total_pages: total_pages}
  end

  def current_user
      @account = AccountBlock::Account.find(@token.id)
  end

end