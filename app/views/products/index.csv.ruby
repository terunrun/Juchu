require 'csv'

CSV.generate do |csv|
  csv_column_names = ["商品名","受注数","説明","発注者","受注日"]
  csv << csv_column_names
  @products.each do |product|
    csv_column_values = [
      product.name,
      product.number,
      product.description,
      Customer.find(product.customer_id).name,
      product.created_at,
    ]
    csv << csv_column_values
  end
end
