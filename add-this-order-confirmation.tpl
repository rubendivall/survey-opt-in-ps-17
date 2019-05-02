{* Integrate the survey opt-in module Google Merchant Center for Prestashop 1.7
* 
* STEP 1
* Add this code in your tpl file in themes/YOUR_THEME/templates/checkout/order-confirmation.tpl inside the block page_content_container -> {block name='page_content_container'}
* 
* STEP 2
* Define your google Merchant ID in  {assign var="merchant_id" value="YOUR_ID"}
* Define how many days your order will be deliveried {assign var="estimated_delivery_days" value="NUMBER_OF_DAYS"}
*
*
* by Ruben Divall @rubendivall http://www.rubendivall.com 
* https://support.google.com/merchants/answer/7106244?hl=en&ref_topic=7105160
*}
{block name='conversion_pixel'}
  {assign var="estimated_delivery_days" value="NUMBER_OF_DAYS"}
  {assign var="merchant_id" value="YOUR_ID"}
  <!-- BEGIN GCR Opt-in Module Code -->
  {if !empty($merchant_id) && !empty($order.details.id) && !empty(Country::getIsoById($order.addresses.delivery.id_country))}
    <script src="https://apis.google.com/js/platform.js?onload=renderOptIn" async defer></script>
    <script>
      window.renderOptIn = function() { 
        window.gapi.load('surveyoptin', function() {
          window.gapi.surveyoptin.render(
            {
              // REQUIRED
              "merchant_id": {$merchant_id},
              "order_id": "{$order.details.id}",
              "email": "{$customer.email}",
              "delivery_country": "{Country::getIsoById($order.addresses.delivery.id_country)|upper}",
              "estimated_delivery_date": "{"+$estimated_delivery_days days"|date_format:"%Y-%m-%d"}",
              "opt_in_style": "CENTER_DIALOG",
              // OPTIONAL FIELDS
              "products": [
                {foreach $order.products as $item_product}{ "gtin": "{if !empty({$item_product.product_ean13})}{$item_product.product_ean13}{elseif !empty({$item_product.product_upc})}{$item_product.product_upc}{else}{$item_product.product_id}:{$item_product.product_attribute_id}{/if}" } {if !$item_product@last},{/if}{/foreach}]

            }); 
         });
      }
    </script>
    <script>
      window.___gcfg = {
        lang: "{$language.iso_code|lower}"
      };
    </script>
  {/if}
{/block}
