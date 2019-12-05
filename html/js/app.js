var IsInMainMenu = false
$(".character-box").hover(
    function() {
        $(this).css({
            "transition": "200ms",
        });
    }, function() {
        $(this).css({
            "transition": "200ms",          
        });
    }
);

$(".character-box").click(function () {
    $(".character-box").removeClass('active-char');
    $(this).addClass('active-char');
    $(".character-buttons").css({"display":"block"});
    if ($(this).attr("data-ischar") === "true") {
        $("#delete").css({"display":"block"});
		$("#play-char").css({"display":"block"});
		$("#menu1").css({"display":"none"});
    } else {
        $("#delete").css({"display":"none"});
		$("#play-char").css({"display":"block"});
		$("#menu1").css({"display":"none"});
    }
});

$("#play-char").click(function () {
    $.post("http://esx_kashacters/CharacterChosen", JSON.stringify({
        charid: $('.active-char').attr("data-charid"),
        ischar: $('.active-char').attr("data-ischar"),
    }));
    Kashacter.CloseUI();
});

$("#deletechar").click(function () {
    $.post("http://esx_kashacters/DeleteCharacter", JSON.stringify({
        charid: $('.active-char').attr("data-charid"),
    }));
    Kashacter.CloseUI();
});

(() => {
    Kashacter = {};

    Kashacter.ShowUI = function(data) {
		setTimeout(function(){
			$('#loading').css({"display":"none"});	
			$('.main-container').css({"display":"block"});
			$('.bg').css({"display":"block"});
			if(data.characters !== null) {
				$.each(data.characters, function (index, char) {
					if (char.charid !== 0) {
						var charid = char.identifier.charAt(4);
						$('[data-charid=' + charid + ']').html('<h3 class="character-fullname">'+  char.firstname +'  '+ char.lastname +'</h3><div class="character-info"><p class="character-info-work"><strong> Job: </strong><span>'+ char.job.toUpperCase() +'</span></p><p class="character-info-money"><strong> Cash: </strong><span>'+ char.money +'</span></p><p class="character-info-bank"><strong> Bank: </strong><span>'+ char.bank +'</span></p> <p class="character-info-dateofbirth"><strong> Date of birth: </strong><span>'+ char.dateofbirth +'</span></p> <p class="character-info-gender"><strong> Gender: </strong><span>'+ char.sex +'</span></p><p class="character-info-phone-number"><strong> Phone Number: </strong><span>'+ char.phone_number   +'</span></p></div>').attr("data-ischar", "true");
					}
				});
			}
		}, 1000);
    };

    Kashacter.CloseUI = function() {
        $('.main-container').css({"display":"none"});
        $('.BG').css({"display":"none"});
        $(".character-box").removeClass('active-char');
        $("#delete").css({"display":"none"});
		$(".character-box").html('<h3 class="character-fullname"><i class="fas fa-plus"></i></h3><div class="character-info">').attr("data-ischar", "false");
    };
	Kashacter.ShowWelcome = function() {
         $('.charWelcome').css({"display":"block"});
		 $('#changelog').css({"display":"block"});
		 IsInMainMenu = true
    };
	Kashacter.HideWelcome = function() {
         $('.charWelcome').css({"display":"none"});
		 $('#changelog').css({"display":"none"});
		 IsInMainMenu = false
    };
    window.onload = function(e) {
        window.addEventListener('message', function(event) {
            switch(event.data.action) {
                case 'openui':
                    Kashacter.ShowUI(event.data);
                    break;
				case 'openwelcome':
                    Kashacter.ShowWelcome();
                    break;
				case 'displayback':
					 $('.top-bar2').css({"display":"block"});
					 $('.bottom-bar2').css({"display":"block"});
					$('.BG').css({"display":"block"});
                    break;
            }
        })
		document.onkeydown = function(data) {
			if (data.which == 13 && IsInMainMenu) {
				Kashacter.HideWelcome();
				$('#loading').css({"display":"block"});
				$.post("http://esx_kashacters/ShowSelection", JSON.stringify({}));
			}
		}
    }

})();