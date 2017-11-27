$(document).ready(function(){
    var dept1 = [];
    var dept2 = [];
    var dept3 = [];
    var dept4 = [];
    var dept5 = [];


    $(".item:contains(Department1)").each(function(){
        dept1.push($(this).html())
        $(this).remove()
    })

    $(".item:contains(Department2)").each(function(){
        dept2.push($(this).html())
        $(this).remove()
    })

    $(".item:contains(Department3)").each(function(){
        dept3.push($(this).html())
        $(this).remove()
    })

    $(".item:contains(Department4)").each(function(){
        dept4.push($(this).html())
        $(this).remove()
    })

    $(".item:contains(Department5)").each(function(){
        dept5.push($(this).html())
        $(this).remove()
    })
    
    $('<div class="title">Department1</div>').appendTo("#dept1")

    for(var i = 0; i < dept1.length; i++){
        $("#dept1").append(dept1[i])
    }

    $('<div id="dept2" class="row"></div>').insertAfter("#dept1")

    $('<div class="title">Department2</div>').appendTo("#dept2")

    for(var i = 0; i < dept2.length; i++){
        $("#dept2").append(dept2[i])
    }

    $('<div id="dept3" class="row"></div>').insertAfter("#dept2")

    $('<div class="title">Department3</div>').appendTo("#dept3")

    for(var i = 0; i < dept3.length; i++){
        $("#dept3").append(dept3[i])
    }

    $('<div id="dept4" class="row"></div>').insertAfter("#dept3")

    $('<div class="title">Department4</div>').appendTo("#dept4")

    for(var i = 0; i < dept4.length; i++){
        $("#dept4").append(dept4[i])
    }

    $('<div id="dept5" class="row"></div>').insertAfter("#dept4")

    $('<div class="title">Department5</div>').appendTo("#dept5")

    for(var i = 0; i < dept5.length; i++){
        $("#dept5").append(dept5[i])
    }



    var upcount = [];
    $(".status:contains(UP)").each(function(){
        upcount.push($(this).html());
    })

    $(".header").append("TOTAL UP: " + upcount.length.toString())

    var downcount = [];
    $(".status:contains(DOWN)").each(function(){
        downcount.push($(this).html());
    })

    $(".header").append(" // TOTAL DOWN: " + downcount.length.toString())

    var total = $.merge($.merge([], upcount), downcount);
    for(var i = 1; i <= total.length; i++){
        var station = {
            group: $('#'+i).html()
        }
        //console.log(station)
    }
    

    $(".header").append(" // TOTAL: " + total.length.toString())

    var status = $(".status").text();
    //alert(status);
    
    $(".status:contains(UP)").css(
        "color", "greenyellow"
    );

    $(".status:contains(UP)").append("&#9650;");

    
    $(".status:contains(DOWN)").css(
        "color", "red"
    );
    $(".status:contains(DOWN)").append("&#9660;")
})



