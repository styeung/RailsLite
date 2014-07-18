require 'active_support/core_ext'
require 'webrick'
require_relative '../lib/rails_lite'

server = WEBrick::HTTPServer.new(:Port => 3000)
trap('INT') { server.shutdown }

class MyController < ControllerBase
  def go
    if @req.path == "/cats"
      render_content("hello cats!", "text/html")
    else
      redirect_to("/cats")
    end

    # after you have template rendering, uncomment:
    # render :show

    # after you have sessions going, uncomment:
    # session["count"] ||= 0
    # session["count"] += 1
    # render :counting_show
  end
end

server.mount_proc '/' do |req, res|
  MyController.new(req, res).go
end

server.start
