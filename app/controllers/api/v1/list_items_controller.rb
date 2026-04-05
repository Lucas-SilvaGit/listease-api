module Api
  module V1
    class ListItemsController < BaseController
      before_action :set_list
      before_action :set_item, only: %i[update destroy toggle_purchased update_price update_quantity]

      def index
        items = @list.list_items.includes(:product)
        items = apply_filter(items)
        items = apply_sort(items)

        render json: {
          list: ListSerializer.new(@list.reload).as_json,
          items: items.map { |item| ListItemSerializer.new(item).as_json }
        }
      end

      def create
        item = @list.list_items.new(item_params)

        if item.save
          render json: response_payload(item), status: :created
        else
          render json: { errors: item.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @item.update(item_params)
          render json: response_payload(@item)
        else
          render json: { errors: @item.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @item.destroy
        head :no_content
      end

      def toggle_purchased
        @item.update!(purchased: !@item.purchased)
        render json: response_payload(@item.reload)
      end

      def update_price
        @item.update!(price: params.require(:price))
        render json: response_payload(@item.reload)
      end

      def update_quantity
        @item.update!(quantity: params.require(:quantity))
        render json: response_payload(@item.reload)
      end

      def remove_purchased
        @list.list_items.purchased.destroy_all
        render json: { list: ListSerializer.new(@list.reload).as_json }
      end

      private

      def set_list
        @list = current_user.lists.find(params[:list_id])
      end

      def set_item
        @item = @list.list_items.find(params[:id])
      end

      def item_params
        params.require(:item).permit(:product_id, :name_snapshot, :brand_snapshot, :quantity, :price, :purchased)
      end

      def response_payload(item)
        {
          list: ListSerializer.new(@list.reload).as_json,
          item: ListItemSerializer.new(item).as_json
        }
      end

      def apply_filter(items)
        case params[:filter]
        when "purchased"
          items.purchased
        when "pending"
          items.pending
        else
          items
        end
      end

      def apply_sort(items)
        case params[:sort]
        when "name"
          items.order(Arel.sql("LOWER(name_snapshot) ASC"))
        when "category"
          items.left_joins(:product).order(Arel.sql("LOWER(COALESCE(products.category, 'zzzz')) ASC"), Arel.sql("LOWER(name_snapshot) ASC"))
        when "highest_price"
          items.order(price: :desc)
        when "lowest_price"
          items.order(price: :asc)
        else
          items.order(created_at: :asc)
        end
      end
    end
  end
end

