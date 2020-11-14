module CategoriaHelper

  def self.create_imagen(categoria, data)
    cloudinary_response = Cloudinary::Uploader.upload(File.open(data))
    cloudinary_response.to_json
    asset = AssetCategoria.create! url_imagen: cloudinary_response['url'], public_id: cloudinary_response['public_id']
    categoria.asset_categorias << asset
    categoria.save!
  end

  def self.create_video(categoria, data)
    asset = AssetCategoria.create! url_video:data
    categoria.asset_categorias << asset
    categoria.save!
  end

  def self.remove_asset(categoria, asset)
    if asset.url_imagen
      Cloudinary::Uploader.destroy(asset.public_id)
    end
    categoria.asset_categorias.delete(asset)
    categoria.save!
  end

  def self.update_imagen(asset, data)
    if asset.public_id
      Cloudinary::Uploader.destroy(asset.public_id)
    end
    cloudinary_response = Cloudinary::Uploader.upload(File.open(data))
    cloudinary_response.to_json
    asset.public_id = cloudinary_response['public_id']
    asset.url_imagen = cloudinary_response['url']
    asset.save!
  end

  def self.update_video(asset, data)
    asset.url_video = data
    asset.save!
  end

end
