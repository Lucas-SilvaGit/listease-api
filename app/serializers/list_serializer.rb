class ListSerializer
  def initialize(list)
    @list = list
  end

  def as_json(*)
    {
      id: list.id,
      name: list.name,
      kind: list.kind,
      month: list.month,
      year: list.year,
      items_count: list.items_count,
      purchased_count: list.purchased_count,
      total_amount: list.total_amount.to_f,
      progress: progress
    }
  end

  private

  attr_reader :list

  def progress
    return 0 if list.items_count.zero?

    (list.purchased_count.to_f / list.items_count).round(2)
  end
end
