// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function show_image(pid, install_dir_name){
    $('large-image').innerHTML = "Loading image ...";
    var ajax = new Ajax.Updater('large-image', 
        install_dir_name + '/go/large_image/?pid='+ pid, 
        {asynchronous:true});
    
}


function show_cart(){
    if ($('cart-area').style.display == "none"){
        Effect.Appear('cart-area');
        $('show-hide-link').innerHTML = '<a href="#show.cart#" onclick="show_cart();">Hide Cart</a>'
    }else{
    Effect.Fade('cart-area');
    $('show-hide-link').innerHTML = '<a href="#show.cart#" onclick="show_cart();">View My Shopping Cart</a>'
}

}


