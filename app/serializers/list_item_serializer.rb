class ListItemSerializer
  def initialize(list_item)
    @list_item = list_item
  end

  def as_json(*)
    {
      id: list_item.id,
      product_id: list_item.product_id,
      name: list_item.name_snapshot,
      brand: list_item.brand_snapshot,
      quantity: list_item.quantity.to_f,
      price: list_item.price.to_f,
      total_price: list_item.total_price.to_f,
      purchased: list_item.purchased
    }
  end

  private

  attr_reader :list_item
end
