const toggleSlide = () => {
    let slider = document.getElementById('slider');
    if (slider.classList.contains('hide')) {
        slider.classList.remove('hide');
    } else {
        slider.classList.add('hide');
    }
};

const toggleInfo = () => {
    let info_content = document.getElementById('info-content');
    if (info_content.classList.contains('hide')) {
        info_content.classList.remove('hide');
    } else {
        info_content.classList.add('hide');
    }
};

const loadPage = (path) => {
    location.pathname = path;
};

var user = null;
var path = null;

const showModal = (id, pth) => {
    let modal = document.getElementById('myModal');
    user = id;
    path = pth;
    modal.style.display = 'block';
};

const hideModal = () => {
    let modal = document.getElementById('myModal');
    modal.style.display = 'none';
};

const delUser = () => {
    let pth = path + user;
    if(location.pathname.search('pessoas') != -1 || location.pathname.search('avaliado') != -1) {
        let cat = location.pathname.split('/');
        cat = cat[cat.length - 1];
        pth += `/${cat}`;
        if (location.pathname.search('pessoas') != -1) {
            pth += '?' + location.href.split('?')[1];
        }
    }
    loadPage(pth);
};

window.onload = () => {
    let modal = document.getElementById('myModal');
    var span = document.getElementsByClassName("close")[0];

    // When the user clicks on <span> (x), close the modal
    span.onclick = function() {
        modal.style.display = "none";
    }

    // When the user clicks anywhere outside of the modal, close it
    window.onclick = function(event) {
        if (event.target == modal) {
            modal.style.display = "none";
        }
    }
}

$(document).ready(function () {
    let options = {};
    if (location.pathname === '/pessoas/eval'){
        options.order = [[4, 'desc']];
    }
    $('#myTable').DataTable(options);
});
