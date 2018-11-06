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

const calculateTotal = () => {
    let numFormations = document.forms[0].children.length - 2;
    let formation;
    let total = 0;
    for (let i=0; i<numFormations; i++) {
        formation = document.forms[0].children[i].children[9].children[0];
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

//////////////////////////////////////////////
/////////////// DATATABLES ///////////////////
//////////////////////////////////////////////

$(document).ready(function () {
    let options = {
        lengthMenu: [10],
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

//////////////////////////////////////////////
//////////////// MATERIALIZE /////////////////
//////////////////////////////////////////////

var datepicker_opts = {
    format: 'yyyy-mm-dd',
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
};

var timepicker_opts = {
    twelveHour: false,
    i18n: {
        cancel: 'Cancelar',
        clear: 'Limpar',
        done: 'Ok'
    }
}

var user = null;
var path = null;
var modal = null;

const delUser = () => {
    let pth = path + user;
    if(location.pathname.search('pessoas') != -1 || location.pathname.search('avaliado') != -1) {
        let cat = location.pathname.split('/');
        cat = cat[cat.length - 1];
        pth += `/${cat}`;
    }
    loadPage(pth);
};

const dismissModal = () => {
    M.Modal.getInstance(modal).close();
};

document.addEventListener('DOMContentLoaded', function() {
    M.Datepicker.init(document.querySelectorAll('.datepicker'), datepicker_opts);
    M.Timepicker.init(document.querySelectorAll('.timepicker'), timepicker_opts);
    M.FormSelect.init(document.querySelectorAll('select'));
    M.Sidenav.init(document.querySelectorAll('.sidenav'));
    M.Modal.init(document.querySelectorAll('.modal'), {
        onOpenStart: function(mod, target) {
           user = target.getAttribute('user-id');
           path = target.getAttribute('path');
           modal = mod;
        }
    });
});

const openSidenav = () => {
    let el = document.querySelectorAll('.sidenav');
    let inst = M.Sidenav.init(el)[0];
    inst.open();
};