module ProductsHelper
  def convertToJPY(price)
    "#{price.to_s(:delimited, delimiter: ',')}"
  end

  def stock_array_maker(stock)
    product = Product.find(params[:id])
    stock = product.stock_quantity
    array = []
    n = 0
    loop {
      n += 1
      array.push(n)
      break if n == stock
    }
    array
  end
end
