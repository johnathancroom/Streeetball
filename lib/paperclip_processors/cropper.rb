module Paperclip  
  class Cropper < Thumbnail  
    def transformation_command  
      if crop_command
        original_command = super
        if original_command.include?('-crop')
          original_command.delete_at(super.index('-crop') + 1)
          original_command.delete_at(super.index('-crop'))
        end
        crop_command + original_command
      else  
        super  
      end  
    end  

    def crop_command  
      target = @attachment.instance  
      if target.cropping?
        ["-crop", "#{target.crop_w.to_i}x#{target.crop_h.to_i}+#{target.crop_x.to_i}+#{target.crop_y.to_i}"]
      end  
    end  
  end  
end