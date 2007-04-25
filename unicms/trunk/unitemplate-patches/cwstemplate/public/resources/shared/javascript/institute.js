imgNav_0 = new Image(); imgNav_0.src = "/lenya/public/authoring/images/key-visual_0.jpg";
imgNav_1 = new Image(); imgNav_1.src = "/lenya/public/authoring/images/key-visual_1.jpg";
imgNav_2 = new Image(); imgNav_2.src = "/lenya/public/authoring/images/key-visual_2.jpg";
imgNav_3 = new Image(); imgNav_3.src = "/lenya/public/authoring/images/key-visual_3.jpg";
imgNav_4 = new Image(); imgNav_4.src = "/lenya/public/authoring/images/key-visual_4.jpg";
imgNav_5 = new Image(); imgNav_5.src = "/lenya/public/authoring/images/key-visual_5.jpg";

function changeImgNav(imgNr){
    if(imgNr == 0) {
        document.images["key-visual"].src = imgNav_0.src;
    } else {
        document.images["key-visual"].src = eval('imgNav_'+imgNr+'.src');
    }
}

function selectLocation( newLocation ) {
    if ( ( newLocation ) && ( newLocation != '' ) ) {
        location.href = newLocation;
    }
}
