module Api
  module V1
    class ListsController < BaseController
      before_action :set_list, only: %i[show update destroy duplicate]

      def index
        lists = current_user.lists.includes(:list_items).recent_first
        render json: { lists: lists.map { |list| ListSerializer.new(list).as_json } }
      end

      def create
        list = current_user.lists.new(list_params)

        if list.save
          render json: { list: ListSerializer.new(list).as_json }, status: :created
        else
          render json: { errors: list.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def show
        render json: { list: ListSerializer.new(@list).as_json }
      end

      def update
        if @list.update(list_params)
          render json: { list: ListSerializer.new(@list).as_json }
        else
          render json: { errors: @list.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @list.destroy
        head :no_content
      end

      def duplicate
        duplicated = Lists::DuplicateService.new(source_list: @list).call
        render json: { list: ListSerializer.new(duplicated).as_json }, status: :created
      end

      private

      def set_list
        @list = current_user.lists.find(params[:id])
      end

      def list_params
        params.require(:list).permit(:name, :kind, :month, :year)
      end
    end
  end
end
