load_mf_holdings <- function(file) {

  read_xlsx(
    path = file,
    sheet = 1,
    skip = 6,
    col_names = c(
      "portfolio_id",
      "symbol",
      "date",
      "cusip",
      "sec_type",
      "name",
      "weight",
      "price",
      "quantity",
      "sector_code",
      "sector_name",
      "industry_group_code",
      "industry_group_name"
    )
  ) |>
    mutate(
      date = as.Date(date)
    ) |>
    mutate(
      sector_code = factor(sector_code),
      industry_group_code = factor(industry_group_code)
    )

}


run_industry_test <- function(tbl, threshold = 25) {

  industry_tbl <- tbl |>
    group_by(portfolio_id, industry_group_name) |>
    summarize(
      weight = sum(weight)
    )

  industry_violations <- industry_tbl |>
    filter(weight > threshold)

  industry_violations |>
    count(portfolio_id)

}
