# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Settings.company_name = ""
Settings.company_address = ""
Settings.company_vat_id = ""
Settings.company_phone = ""
Settings.email_subject = ""
Settings.email_body = ""
Settings.company_email = ""
Settings.company_url = ""
Settings.company_logo = ""
Settings.legal_terms = ""
Settings.currency = "usd"

invoice_template = <<HEREDOC
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Invoice</title>

  <style type="text/css">
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    html {
      font-size: 16px;
    }

    body {
      margin: 2cm 2cm 0;
      color: #3d3f3e;
    }

    h1 {
      text-transform: uppercase;
      font-weight: normal;
      font-size: 1.2rem;
    }

    .row + h1 {
      margin: -1rem 0 1rem;
    }

    p {
      margin-bottom: .5rem;
    }

    .text-right {
      text-align: right;
    }

    .text-muted {
      color: #6f7371;
    }

    .invoice {
      font-size: 100%;
      font-family: Helvetica, Arial, sans-serif;
      color: #3d3f3e;
    }

    .logo {
      max-height: 50px;
      width: auto;
    }

    .row {
      clear: both;
      margin-bottom: 2rem;
    }
    .row::after {
      content: "";
      display: table;
      clear: both;
    }

    .section, .section-sm, .section-lg {
      min-height: 1px;
      width: 50%;
      float: left;
      list-style: none;
    }

    .section-sm {
      width: 40%;
    }

    .section-lg {
      width: 60%;
    }

    .page-break {
      display:block;
      clear:both;
      page-break-after:always;
    }

    .company {
      list-style: none;
      font-size: 90%;
      line-height: 1.2;
    }
    .company .company__name {
      margin-bottom: .5rem;
    }
    .company .company__name + .company__id {
      margin-top: -.5rem;
      margin-bottom: .5rem;
    }
    .company .company__address {
      margin-bottom: .5rem;
    }

    .customer .company__name {
      font-size: 1.2rem;
    }

    .status {
      color: white;
      float: right;
      border: 1px solid #cbcbc0;
      border-left: none;
      padding: 1.623rem;
      margin-top: -1rem;
    }

    .failed {
      background-color: rgb(55, 58, 60);
    }

    .past_due {
      background-color: #d9534f;
    }

    .draft {
      background-color: #ddd;
    }

    .paid {
      background-color: #5cb85c;
    }

    .pending {
      background-color: #D8B256;
    }

    .amount {
      font-size: 2rem;
      font-weight: bold;
      text-align: center;
      border: 1px solid #cbcbc0;
      padding: 1rem;
      float: right;
      margin-top: -1rem;
    }

    .amount__currency {
      font-size: 1.125rem;
      color: #cbcbc0;
    }

    table {
      border-collapse: collapse;
    }
    table thead th {
      border-bottom: 1px solid #cbcbc0;
      background-color: #e7e7e2;
    }
    table td, table th {
      text-align: left;
      padding: .625rem;
    }
    table .total {
      text-align: right;
      white-space: nowrap;
      width: 10rem;
    }
    table.info {
      float: right;
      font-size: 90%;
      margin-bottom: 1rem;
    }
    table.info td, table.info th {
      padding: .5rem;
    }
    table.info tr:nth-child(even) {
      background-color: #f2f2ef;
    }
    table.items {
      width: 100%;
      margin-bottom: 2rem;
      border: 1px solid #cbcbc0;
    }
    table.items tr:nth-child(even) {
      background-color: #f2f2ef;
    }
    table.totals {
      float: right;
    }
    table.totals td, table.totals th {
      text-align: right;
    }
    table.totals .grand-total {
      font-size: 1.5rem;
      font-weight: bold;
    }

    .notes {
      font-size: 90%;
    }
    .notes .notes__title {
      font-size: 1rem;
      font-weight: bold;
    }

    @media print {
      body {
        margin: 0;
        width: 100%;
      }

      .section, .section-sm, .section-lg {
        page-break-inside: avoid;
      }
    }
  </style>
</head>
<body class="invoice">

  <div class="row">
    <% if settings.company_logo != "" %>
    <div class="section-lg">
      <img class="logo" src="<%= settings.company_logo %>" alt="<%= settings.company_name %>" />
    </div>
    <% end %>
    <div>
      <ul class="company text-right">
        <li class="company__name"><%= settings.company_name %></li>
        <li class="company__id"><%= settings.company_vat_id %></li>
        <li class="company__address"><%= format_address settings.company_address %></li>
        <li><%= settings.company_email %></li>
        <li><%= settings.company_url %></li>
      </ul>
    </div>
  </div>

  <h1>Invoice</h1>

  <div class="row">
    <div class="section-sm">
      <p class="text-muted">Billed to:</p>
      <ul class="company customer">
        <% if invoice.name? %>
          <li class="company__name"><%= invoice.name %></li>
        <% end %>
        <% if invoice.identification? %>
          <li class="company__id"><%= invoice.identification %></li>
        <% end %>
        <% if invoice.invoicing_address? || invoice.contact_person? %>
          <li class="company__address">
            <% if invoice.contact_person? %>
              <%= invoice.contact_person %><br>
            <% end %>
            <% if invoice.invoicing_address? %>
              <%= format_address invoice.invoicing_address %>
            <% end %>
          </li>
        <% end %>
        <% if invoice.email? %>
          <li><%= invoice.email %></li>
        <% end %>
      </ul>
    </div>
    <div class="section-lg">
      <table cellspacing="0" class="info">
        <tbody>
          <tr>
            <th>Invoice Number:</th>
            <td class="total"><%= invoice %></td>
          </tr>
          <tr>
            <th>Billed:</th>
            <td class="total"><%= invoice.issue_date %></td>
          </tr>
          <tr>
            <th>Due on:</th>
            <td class="total"><%= invoice.due_date %></td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>

  <div class="row">
    <div class="status <%= invoice.get_status %>">
      <%= invoice.get_status.upcase %>
    </div>
    <div class="amount">
      <%= display_money invoice.gross_amount %>
      <span class="amount__currency"><%= settings.currency.upcase %></span>
    </div>
  </div>

  <table class="items" cellspacing="0">
    <thead>
      <tr>
        <th>Description</th>
        <th class="total">Total</th>
      </tr>
    </thead>
    <tbody>
      <% @invoice.items.each do |item| %>
        <tr>
          <td><%= item.description %></td>
          <td class="total"><%= display_money item.base_amount %></td>
        </tr>
      <% end %>
    </tbody>
  </table>

  <div class="row">
    <div class="section">
      <% if invoice.terms? %>
        <div class="notes">
          <p class="notes__title">Terms &amp; Conditions</p>
          <div class="notes__content">
            <%= invoice.terms %>
          </div>
        </div>
      <% end %>
    </div>
    <div class="section">
      <table class="totals" cellspacing="0">
        <tbody>
          <% if invoice.discount_amount != 0 %>
            <tr>
              <th>Discount</th>
              <td class="total"><%= display_money invoice.discount_amount %></td>
            </tr>
          <% end %>
          <tr>
            <th>Subtotal</th>
            <td class="total"><%= display_money invoice.net_amount %></td>
          </tr>
          <% invoice.taxes.each do |tax, value| %>
            <tr>
              <th><%= tax %></th>
              <td class="total"><%= display_money value %></td>
            </tr>
          <% end %>
          <tr class="grand-total">
            <th>Total</th>
            <td class="total"><%= display_money invoice.gross_amount %></td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
<div class="page-break"></div>
</body>
</html>
HEREDOC

Template.create(name: "Print Default", template: invoice_template.strip(), print_default: true)
