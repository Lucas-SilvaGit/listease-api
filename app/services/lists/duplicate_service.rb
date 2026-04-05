module Lists
  class DuplicateService
    def initialize(source_list:)
      @source_list = source_list
    end

    def call
      duplicated_list = source_list.user.lists.create!(
        name: "#{source_list.name} (copy)",
        kind: source_list.kind,
        month: source_list.month,
        year: source_list.year
      )

      source_list.list_items.find_each do |item|
        duplicated_list.list_items.create!(
          product: item.product,
          name_snapshot: item.name_snapshot,
          brand_snapshot: item.brand_snapshot,
          quantity: item.quantity,
          price: item.price,
          purchased: false
        )
      end

      duplicated_list
    end

  private

  attr_reader :source_list
  end
end
