class ProductService
  def initialize(params = {})
    @params = params
  end

  def delete
    if product.blank?
      return {:message => 'INVALID ID: Product doesnt exists in database for given id', :status => 400 }
    end

    delete_all_product_sizes
    delete_all_product_inventories
    delete_status = product.update_attribute("status", 4)

    if !delete_status
      {:message => 'Unable to delete, validations failed', :status => 400 }
    else
      {:message => 'Product deleted successfully', :status => 200 , :meta => {:id => product_id}}
    end
  end

  def create_product
    validate = product_validation
    if !validate[:status]
      return {:message => validate[:message], :status => 400 }
    end

    new_product = Product.new
    add_product_data(new_product)
    params[:product_sizes].each do |size|
      size.each do |size_id, inventory_data|
        product_size = ProductSize.new
        add_item_sizes(new_product, product_size, size_id)

        inventory_data.each do |data|
          product_inventory = ProductInventory.new
          create_inventory_data(product_size, data, product_inventory)
        end
      end
    end
    return {:message => 'Item created successfully', :status => 200, :meta => {:id => new_product.id, :name => new_product.name}}
  end

  def fetch_product
    if product.blank?
      return {:data => nil, :message => 'INVALID ID: Product doesnt exist in database for provided parameter', :status => 400 }
    end

    return {:data => product_hash, :message => 'Product fetched successfully', :status => 200 }
  end

  def search_products
    return {:data => nil, :message => 'Search parameter is empty', :status => 400 } if name.blank?
    products = Product.where("name LIKE ? AND status = ?", "%#{params[:name]}%", 2).all.entries
    message = 'No products are available for the given search' if products.blank?
    message = 'Returning products corresponding to search' if !products.blank?
    return {:data => products, :message => message, :status => 200 , :meta => {:count => products.count}}
  end

  def update_product
    if product.blank?
      return {:message => 'INVALID ID: Product doesnt exist in database for provided parameter', :status => 400 }
    end

    validate = product_validation
    if !validate[:status]
      return {:message => validate[:message], :status => 400 }
    end

    add_product_data(product)
    original_size_ids = product.product_sizes.where(:status => 2).map {|size| size.id}
    new_size_ids = []
    new_property_ids = []
    params[:product_sizes].each do |size|
      size.each do |size_id, inventory_data|
        new_size_ids.push(size_id.to_i)
        if original_size_ids.include? size_id.to_i
          product_size = ProductSize.where(product_id: product.id, size_list_id: size_id.to_i, status: 2).first
          product_size_id = product_size.id if product_size.present?
          original_property_ids = product_size.product_inventories.where(:status => 2).map {|x| x.property_id.to_i}
          inventory_data.each do |data|
            new_property_ids.push(data[:property_id].to_i)
            if original_property_ids.include? data[:property_id].to_i
              product_inventory = ProductInventory.where(:product_size_id => product_size_id, :property_id => data[:property_id].to_i, :status => 2).first
              create_inventory_data(product_size, data, product_inventory)
            else
              product_inventory = ProductInventory.new
              create_inventory_data(product_size, data, product_inventory)
            end
          end
          original_property_ids  = original_property_ids.uniq
          new_property_ids = new_property_ids.uniq
          delete_item_inventories(original_property_ids - new_property_ids) if (original_property_ids - new_property_ids).length > 0
        else
          product_size = ProductSize.new
          add_item_sizes(product, product_size, size_id)
          inventory_data.each do |data|
            product_inventory = ProductInventory.new
            create_inventory_data(product_size, data, product_inventory)
          end
        end
      end
    end
    original_size_ids = original_size_ids.uniq
    new_size_ids = new_size_ids.uniq
    delete_item_sizes(original_size_ids - new_size_ids) if (original_size_ids - new_size_ids).length > 0
    return {:message => 'Item updated successfully', :status => 200 }
  end

  private

  attr_reader :params

  def product_id
    params[:id].to_i
  end

  def name
    params[:name]
  end

  def brand_id
    params[:brand_id].to_i
  end

  def category_id
    params[:category_id].to_i
  end

  def product
    Product.where(id: product_id, :status => 2).first
  end

  def product_sizes
    product.product_sizes
  end

  def product_inventories
    product_sizes
  end

  def delete_item_inventories ids
    ProductInventory.where(:id => ids, :status => 2).update_all(:status => 4)
  end

  def delete_item_sizes ids
    ProductSize.where(:id => ids, :status => 2).update_all(:status => 4)
  end


  def delete_all_product_sizes
    product_sizes.update_all(:status => 4)
  end

  def delete_all_product_inventories
    product_sizes.each do |product_size|
      product_size.product_inventories.update_all(:status => 4)
    end
  end

  def sizes_validation
    invalid_size_ids = []
    params[:product_sizes].each do |size|
      size.each do |size_id, data|
        size_id = SizeList.find(size_id.to_i) rescue nil
        invalid_size_ids.push(size_id.to_i) if size_id.nil?
      end
    end

    return {:status => false, :size_ids => invalid_size_ids} if invalid_size_ids.present?

    {:status => true}
  end

  def add_product_data product
    product.name = name.upcase
    product.status = 2
    product.brand_id = brand_id
    product.category_id = category_id
    product.description = params[:description] if params[:description].present?
    product.save
  end

  def add_item_sizes (product, product_size, size_id)
    product_size.product_id = product.id
    product_size.size_list_id = size_id
    product_size.status = 2
    product_size.save
  end

  def create_inventory_data (product_size, inventory_data, product_inventory)
    product_inventory.product_size_id = product_size.id
    product_inventory.cost_price = inventory_data[:cost_price].to_i
    product_inventory.selling_price = inventory_data[:selling_price].to_i
    product_inventory.quantity = inventory_data[:quantity].to_i
    product_inventory.property_id = inventory_data[:property_id].to_i
    product_inventory.status = 2
    product_inventory.save
  end

  def inventory_data_validation
    error_message = ""
    params[:product_sizes].each do |size|
      size.each do |size_id, inventory_data|
        inventory_data.each do |data|
          property = Property.find(data[:property_id]) rescue nil
          error_message << "Property_id for size_id = #{size_id} is invalid" if property.nil?
          error_message << "Cost Price for size_id = #{size_id} and property_id = #{data[:property_id]} is empty" if data[:cost_price].blank?
          error_message << "Selling Price for size_id = #{size_id} and property_id = #{data[:property_id]} is empty" if data[:selling_price].blank?
          error_message << "Quantity for size_id = #{size_id} and property_id = #{data[:property_id]} is empty" if data[:quantity].blank?
        end
      end
    end
    return {:status => false, :message => error_message} if error_message.present?
    return {:status => true}
  end

  def product_hash
    product_hash = {}
    product_hash['id'] = product.id
    product_hash['name'] = product.name
    product_hash['created_at'] = product.created_at
    product_hash['updated_at'] = product.updated_at
    product_hash['brand'] = brand_hash
    product_hash['category'] = category_hash
    product_hash['description'] = product.description
    product_hash['product_sizes'] = product_sizes_hash
    product_hash
  end

  def brand_hash
    Brand.where(:id => product.brand_id).first
  end

  def category_hash
    Category.where(:id => product.category_id).first
  end

  def product_sizes_hash
    product_sizes = []
    product.product_sizes.where(:status => 2).each do |size|
      hash = {}
      hash['size_id'] = size.size_list_id
      hash['size_name'] = SizeList.find(size.size_list_id).name
      hash['properties'] = product_inventories_hash(size)
      product_sizes.push(hash)
    end
    product_sizes
  end

  def product_inventories_hash size
    product_inventories = []
    size.product_inventories.where(:status => 2).each do |inventory|
      hash = {}
      property = Property.find(inventory.property_id.to_i)
      hash['property_id'] = inventory.property_id
      hash['property_name'] = property.name
      hash['property_type'] = PropertyType.find(property.property_type_id)
      hash['cost_price'] = inventory.cost_price
      hash['selling_price'] = inventory.selling_price
      hash['quantity'] = inventory.quantity
      product_inventories.push(hash)
    end
    product_inventories
  end

  def product_validation
    if name.blank?
      return {:message => 'Product name cannot be empty', :status => false }
    end

    brand = Brand.find(brand_id) rescue nil
    if brand.nil?
      return {:message => 'Product brand is invalid, please select valid brand', :status => false }
    end

    category = Category.find(category_id) rescue nil
    if category.nil?
      return {:message => 'Product Category is invalid, please select valid category', :status => false }
    end

    if params[:product_sizes].blank?
      return { :message => 'Product specifications need to be entered', :status => false }
    end

    validate_size_data = sizes_validation

    if !validate_size_data[:status]
      return { :message => "INVALID SIZE-IDS : #{validate_size_data[:size_ids]}", :status => false }
    end

    validate_inventory_data = inventory_data_validation

    if !validate_inventory_data[:status]
      return { :message => "#{validate_inventory_data[:message]}", :status => false }
    end

    { :status => true }
  end
end


