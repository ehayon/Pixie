require 'bundler'
Bundler.require(:default)

class Image
  attr_accessor :image

  def initialize(img)
	self.image = Magick::Image::read(img).first
  end

  def to_ascii
	#chars = (0..11).map { rand(33..126).chr } # playing around with a random ascii character set
	chars = %w( % H m A v @ y < # $ > % ^ o * : ' ` .)
	p = []
	scaled = self.image.scale(0.2).quantize(chars.length)
	scaled.each_pixel { |pixel| p << pixel.intensity }
	p = p.uniq.sort
	chars[p.length-1] = " "
	ascii = []
	# binding.pry
	scaled.each_pixel do |pixel, c, r|
	  # binding.pry
	  print chars[p.index(pixel.intensity)] + " "
	  puts if c == scaled.columns - 1
	  ascii << chars[p.index(pixel.intensity)] + " "
	  ascii << "\n" if c == scaled.columns - 1
	end
	  ascii
	end
	end
image = Image.new('image.png')
File.open('output.txt', 'w') do |f|
  f.print(image.to_ascii.join)
end

