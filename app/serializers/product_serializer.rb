class ProductSerializer
  def initialize(product)
    @product = product
  end

  def as_json(*)
    {
      id: product.id,
      name: product.name,
      brand: product.brand,
      category: product.category,
      default_price: product.default_price&.to_f
    }
  end

  private

  attr_reader :product
end
