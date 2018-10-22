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
    let options = {
        lengthMenu: [7],
        lengthChange: false,
        info: false,
        language: {
            paginate: {
                previous: '<<',
                next: '>>'
            },
            search: 'Filtrar:'
        }
    };
    if (location.pathname === '/pessoas/eval'){
        options.order = [[4, 'desc']];
    }
    $('#myTable').DataTable(options);
});

const calculateTotal = () => {
    let numFormations = document.forms[0].children.length - 2;
    let formation;
    let total = 0;
    for (let i=0; i<numFormations; i++) {
        formation = document.forms[0].children[i].children[10];
        if (formation.checked) {
            subscription = parseFloat(formation.getAttribute('data-insc'));
            certificate = parseFloat(formation.getAttribute('data-cert'));
            total += subscription + certificate;
        }
    }
    let discount = parseFloat(document.getElementById('discount').value);
    total *= (100 - discount) / 100;
    document.getElementById('total').value = total;
};

const enableTotal = () => {
    document.getElementById('total').disabled = false;
    return true;
}

const openSidenav = () => {
    let el = document.querySelectorAll('.sidenav');
    let inst = M.Sidenav.init(el)[0];
    inst.open();
};

const showDatepicker = () => {
    let el = document.querySelectorAll('.datepicker');
    let inst = M.Datepicker.init(el, {
        format: 'dd-mm-yyyy',
        i18n: {
            cancel: 'Cancelar',
            clear: 'Limpar',
            months: [
                'Janeiro',
                'Fevereiro',
                'Março',
                'Abril',
                'Maio',
                'Junho',
                'Julho',
                'Agosto',
                'Setembro',
                'Outubro',
                'Novembro',
                'Dezembro'
            ],
            monthsShort: [
                'Jan',
                'Fev',
                'Mar',
                'Abr',
                'Mai',
                'Jun',
                'Jul',
                'Ago',
                'Set',
                'Out',
                'Nov',
                'Dez'
            ],
            weekdays: [
                'Domingo',
                'Segunda-Feira',
                'Terça-Feira',
                'Quarta-Feira',
                'Quinta-Feira',
                'Sexta-Feira',
                'Sábado'
            ],
            weekdaysShort: [
                'Dom',
                'Seg',
                'Ter',
                'Qua',
                'Qui',
                'Sex',
                'Sab'
            ],
            weekdaysAbbrev: ['D', 'S', 'T', 'Q', 'Q', 'S', 'S']
        }
    })[0];
    inst.open();
}