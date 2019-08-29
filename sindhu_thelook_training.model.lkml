connection: "thelook"

# include all the views
include: "*.view"

datagroup: sindhu_thelook_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "4 hour"
}

persist_with: sindhu_thelook_default_datagroup



explore: etl_jobs {}

explore: events {
  join: users {
    type: inner
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}


explore: inventory_items {
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
  relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: order_items {
  always_filter: {
    filters: {
      field: id
      value: "123"
      }
      }
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one


  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
   relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: distribution_centers{
  join: order_items {
    view_label: "Order Info"
    sql_on: ${distribution_centers.id}.id} = ${order_items.id} ;;
    relationship: many_to_one
  }
}

explore: products {

  join: distribution_centers {
   sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    fields: [name]
    relationship: many_to_one
  }
}

explore: users {}
