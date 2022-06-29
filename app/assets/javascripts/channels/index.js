const channels = require.context('.', true, /_channels\.js$/)
channels.keys().forEach(channels)

jQuery(function($){
    $(".deleteAction").click(function(){
        const current_item = $(this).parent('tr')
        if(confirm("Вы уверены?")){
            $.ajax({
                url: '/items/' + $(current_item).attr('data-item_id'),
                type: 'POST',
                data: {_method: 'DELETE'},
                success: function(){
                    $(current_item).fadeOut("slow")

                }
            })
        }
    })

})