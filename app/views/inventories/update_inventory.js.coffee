$("#invoice_items_attributes_<%= @select_id %>_inventory_id").empty().append("<%= escape_javascript(render(:partial => @inventories)) %>")
