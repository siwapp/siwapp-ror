# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Property.create(key: 'company_name')
Property.create(key: 'company_address')
Property.create(key: 'company_phone')
Property.create(key: 'company_email')
Property.create(key: 'company_url')
Property.create(key: 'company_logo')
Property.create(key: 'currency')
Property.create(key: 'legal_terms')

Template.create(name: 'Default', template: '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <title></title>

  <style type="text/css">
    body {
      margin:4em;
      font-family:helvetica,sans-serif;
      font-size:9pt;
      line-height:1.6em;
      color:black;
    }

    #logo { height:75px; }

    ul {
      list-style-type: none;
      padding-left: 0em;
    }

    h2 {
      font-size:18pt;
      margin-top:0;
      margin-bottom:0;
    }

    h3 {
      font-size:14pt;
      margin-top:1em;
    }

    table {
      width:98%;
      table-layout:auto;
    }
    table.items {
      line-height:1em;
    }

    td, th { vertical-align:top; }

    .strong      { font-weight:bold;  }
    .em          { font-style:italic; }
    .text-right  { text-align:right;  }

    .customer-data p { margin:0; }
    .payment-data table td,
    .payment-data table th          { padding:0.65em 0px 0px; }
    .payment-data table th          { font-weight:bold; }
    .payment-data table .item       { padding-right:1em; }
    .payment-data table .text-right { white-space:nowrap; padding-left:1em; }

  </style>

  <style type="text/css">
    @media print {
      body, { margin:auto; width:auto; }
      .section       { page-break-inside:avoid; }
      div#sfWebDebug { display:none; }
    }
  </style>
</head>
<body>


  <div class="section">
    <table>
      <tr>
        <td id="logo" colspan="2" align="right">
          <img src="<%= settings.company_logo %>" alt="<%= settings.company_name %>" />
        </td>
      </tr>
      <tr>
        <td>
          <ul class="customer-data">
            <li><%= invoice.name %></li>
            <li>VAT ID: <%= invoice.identification %></li>
            <li><%= invoice.contact_person %></li>
            <li><%= invoice.invoicing_address %></li>
          </ul>
        </td>
        <td align="right">
          <ul class="invoicer-data">
            <li class="strong"><%= settings.company_name %></li>
            <li><%= simple_format settings.company_address %></li>
            <li>VAT ID: ESB-85996932</li>
            <li><%= settings.company_url %></li>
          </ul>
        </td>
      </tr>
    </table>
  </div>

  <div class="payment-data section">
    <h2>INVOICE</h2>

    <ul>
      <li>BILLED ON:  <%= invoice.issue_date %></li>
      <li>NUMBER: <%= invoice %></li>
    </ul>

    <table class="items">
      <% @invoice.items.each do |item| %>
      <tr>
        <td class="item" colspan="2"><%= item.description %></td>
        <td width="5%" class="text-right"><%= item.net_amount %></td>
      </tr>
      <% end %>
      <% if invoice.discount_amount != 0 %>
      <tr>
        <td></td>
        <th class="text-right">DISCOUNT</th>
        <td class="text-right"><%= invoice.discount_amount %></td>
      </tr>
      <% end %>
      <tr>
        <td rowspan="3"></td>
        <th class="text-right">SUBTOTAL</th>
        <td class="text-right"><%= invoice.net_amount %></td>
      </tr>
      <tr>
        <th class="text-right">VAT %</th>
        <td class="text-right"><%= invoice.tax_amount %></td>
      </tr>
      <tr>
        <th class="text-right">TOTAL</th>
        <td class="text-right"><%= invoice.gross_amount %></td>
      </tr>
    </table>
  </div>

  <div class="section">
    <div class="terms">
      <%= invoice.terms %>
    </div>
  </div>

  <div class="section">
    <p><small></small></p>
  </div>

</body>
</html>')
