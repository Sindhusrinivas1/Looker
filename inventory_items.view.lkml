view: inventory_items {
  sql_table_name: PUBLIC.INVENTORY_ITEMS ;;


    parameter: date_granularity {
    type: string
    allowed_value: { label: "By Weekly" value: "Weekly" }
    allowed_value: { label: "By Monthly" value: "Monthly" }
  }

  dimension: date {
    sql:
    {% if date_granularity._parameter_value == 'Weekly' %}
      ${created_week}
    {% elsif date_granularity._parameter_value == 'Monthly' %}
      ${created_month}
    {% else %}
      ${created_date}
    {% endif %};;
  }



  dimension: date_check {
    type: yesno
    sql: (case when {% parameter date_granularity %} = 'Monthly'
    then ${created_date} > CURRENT_DATE() + INTERVAL '- 6 months'
      when {% parameter date_granularity %} = 'Weekly'
      then ${created_date} > CURRENT_DATE() + INTERVAL '- 12 weeks' end)  ;;
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}."COST" ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      month_name,
      week_of_year,
      year
    ]
    sql: ${TABLE}."CREATED_AT" ;;
  }



  dimension: product_brand {
    type: string
    sql: ${TABLE}."PRODUCT_BRAND" ;;
  }

  dimension: product_category {
    type: string
    sql: ${TABLE}."PRODUCT_CATEGORY" ;;
  }

  dimension: product_department {
    type: string
    sql: ${TABLE}."PRODUCT_DEPARTMENT" ;;
  }


  dimension: product_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."PRODUCT_ID" ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}."PRODUCT_NAME" ;;
  }



  dimension: product_sku {
    type: string
    sql: ${TABLE}."PRODUCT_SKU" ;;
  }

  dimension_group: sold {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."SOLD_AT" ;;
  }



  measure: product_retail_price {
    type: sum
    sql: ${TABLE}."PRODUCT_RETAIL_PRICE" ;;
    filters: {
      field: date_check
      value: "yes"
    }
  }

  measure: count {
    type: count
    drill_fields: [id, product_name, products.id, products.name, order_items.count]
  }
  }
