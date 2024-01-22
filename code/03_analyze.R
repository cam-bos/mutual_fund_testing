source("code/00_dependencies.R")
source("code/01_functions.R")



# load data ---------------------------------------------------------------

data_file <- "data/mf_testing.xlsx"

data_tbl <- load_mf_holdings(data_file)



# data checks -------------------------------------------------------------

# how many holdings per portfolio
data_tbl |>
  count(portfolio_id)

# do weights sum to 100
data_tbl |>
  group_by(portfolio_id) |>
  summarize(
    weight = sum(weight)
  )


# should this be put into the load_mf_holdings function?
data_tbl <- data_tbl |>
  # set security_type caus sector to Cash
  mutate(
    sector_name = if_else(sec_type == "caus", "Cash", sector_name)
  )


# sector weights ----------------------------------------------------------

sector_tbl <- data_tbl |>
  group_by(portfolio_id, sector_name) |>
  summarize(
    weight = sum(weight)
  )

sector_tbl |>
  pivot_wider(
    names_from = portfolio_id,
    values_from = weight,
    values_fill = 0
  )


# test 01 - industry weights > 25 percent ---------------------------------

# run_industry_test(data_tbl, 20)
run_industry_test(data_tbl, threshold = 5)








