require 'bundler'
Bundler.require(:default)

class Image
  attr_accessor :image

  def initialize(img)
	self.image = Magick::Image::read(img).first
  end

  def to_grayscale
	self.image = self.image.quantize(12)
  end

  def to_ascii
	chars = %w(;; $$ @@ ,, ^^ __ %% ** (* *) ==)
	chars[11] = "  "
  	p = []
	scaled = self.image.scale(0.4).quantize(12)
	scaled.each_pixel { |pixel| p << pixel }
	p = p.uniq.sort.map(&:intensity)
	ascii = []
	#binding.pry
	scaled.each_pixel do |pixel, c, r|
		print chars[p.index(pixel.intensity)]
		puts if c == scaled.columns - 1
		ascii << chars[p.index(pixel.intensity)]
		ascii << "\n" if c == scaled.columns - 1
	end
  	ascii
  end
end

image = Image.new('image.png')
File.open('output.txt', 'w') do |f|
  f.print(image.to_ascii.join)
end

