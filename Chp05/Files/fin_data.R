library(data.table)
library(scales)
library(ggplot2)

link <- "https://raw.githubusercontent.com/DavZim/Efficient_Frontier/master/data/fin_data.csv"
dt <- data.table(read.csv(link))
dt[, date := as.Date(date)]

# create indexed values
dt[, idx_price := price/price[1], by = ticker]
 
# plot the indexed values
ggplot(dt, aes(x = date, y = idx_price, color = ticker)) +
	geom_line() +
	theme_bw() + ggtitle("Price Developments") +
	xlab("Date") + ylab("Pricen(Indexed 2000 = 1)") +
	scale_color_discrete(name = "Company")
	
