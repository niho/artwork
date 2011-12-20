require File.expand_path('lib/artwork')
require 'sinatra'
require 'open-uri'

module Artwork
  class Server < Sinatra::Base

    helpers do
      def time_for(value)
        case value
        when :tomorrow  then Time.now + 24*60*60
        when :next_week then Time.now + 7*24*60*60
        else super
        end
      end

      def original_image_url(image_id)
        File.join(ENV['IMAGE_ORIGIN_URL'], image_id)
      end

      def process(image_id)
        image = MiniMagick::Image.open(original_image_url(image_id))
        image = yield(image)
        image.format 'jpg'
        image.quality 90
        expires :tomorrow, :public, :must_revalidate
        content_type 'image/jpeg'
        image.to_blob
      end

      def resize_to_fill(image_id, width, height, gravity = 'Center')
        process(image_id) do |img|
          cols, rows = img[:dimensions]
          img.combine_options do |cmd|
            if width != cols || height != rows
              scale = [width/cols.to_f, height/rows.to_f].max
              cols = (scale * (cols + 0.5)).round
              rows = (scale * (rows + 0.5)).round
              cmd.resize "#{cols}x#{rows}"
            end
            cmd.gravity gravity
            cmd.extent "#{width}x#{height}" if cols != width || rows != height
          end
          img = yield(img) if block_given?
          img
        end
      end

      def resize_to_fit(image_id, width, height)
        process(image_id) do |img|
          img.resize "#{width}x#{height}"
          img = yield(img) if block_given?
          img
        end
      end
    end

    not_found do
      'Not found'
    end

    error OpenURI::HTTPError do
      not_found
    end

    get '/*_small.jpg' do
      resize_to_fill(params[:splat].join('/'), 125, 125)
    end

    get '/*_medium.jpg' do
      resize_to_fill(params[:splat].join('/'), 240, 240)
    end

    get '/*_large.jpg' do
      resize_to_fit(params[:splat].join('/'), 500, 500)
    end

    get '/*_*.jpg' do |path, format|
      width, height = format.split('x').map {|x| x.to_i }
      resize_to_fit(path, width, height)
    end

  end
end
