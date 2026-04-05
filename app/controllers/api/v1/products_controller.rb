module Api
  module V1
    class ProductsController < BaseController
      before_action :set_product, only: %i[update destroy]

      def index
        products = current_user.products.alphabetical
        render json: { products: products.map { |product| ProductSerializer.new(product).as_json } }
      end

      def search
        products = current_user.products.search_by_name(params[:q])
          .left_joins(:list_items)
          .group("products.id")
          .order(Arel.sql("COUNT(list_items.id) DESC"), Arel.sql("LOWER(products.name) ASC"))
          .limit(12)

        render json: { products: products.map { |product| ProductSerializer.new(product).as_json } }
      end

      def create
        product = current_user.products.new(product_params)

        if product.save
          render json: { product: ProductSerializer.new(product).as_json }, status: :created
        else
          render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @product.update(product_params)
          render json: { product: ProductSerializer.new(@product).as_json }
        else
          render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @product.destroy
        head :no_content
      end

      private

      def set_product
        @product = current_user.products.find(params[:id])
      end

      def product_params
        params.require(:product).permit(:name, :brand, :category, :default_price)
      end
    end
  end
end
