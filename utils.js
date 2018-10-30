const portMap = new Map([
    ['registered', 'Registrado'],
    ['waiting_formation', 'Esperando Formação'],
    ['formation', 'Em Formação'],
    ['internship', 'Em Estágio'], 
    ['hired', 'Colocado'],
    ['reserved', 'Em Reserva'],
    ['gave_up', 'Desistiu'],
    ['male', 'Masculino'],
    ['female', 'Feminino']
]);

const errorMap = new Map([
    ['name', 'Nome'],
    ['birthdate', 'Data de Nascimento'],
    ['address', 'Morada'],
    ['phone', 'Telefone'],
    ['email', 'Email'],
    ['bi', 'Número de BI'],
    ['nif', 'Número de NIF'],
    ['gender', 'Género'],
    ['Invalid value', 'inválido'],
    ['shop', 'Loja'],
    ['shift_from', 'Início do Turno'],
    ['shift_to', 'Fim do Turno'],
    ['shop_number', 'Loja Número'],
    ['date_from', 'Início do Periodo'],
    ['date_to', 'Fim do Periodo'],
    ['cachier', 'Caixa'],
    ['cleaning', 'Limpeza'],
    ['customer_service', 'Atendimento / Serviço Cliente'],
    ['replacement', 'Reposição'],
    ['team_work', 'Trabalho em Equipe / Organização'],
    ['cold_meats', 'Charcutaria'],
    ['flexibility', 'Flexibilidade'],
    ['autonomy', 'Autonomia'],
    ['punctuality', 'Pontualidade / Assiduidade'],
    ['honesty', 'Honestidade'],
    ['proactivity', 'Pró Actividade'],
    ['responsibility', 'Responsabilidade'],
    ['interest_level', 'Nivel de Interesse'],
    ['availability', 'Disponibilidade'],
    ['personal_hygiene', 'Uniforme (Higiene Pessoal)'],
    ['responsible_hr', 'Responsavel Recursos Humanos'],
    ['advisor', 'Orientador'],
    ['username', 'Nome de Utilizador'],
    ['password', 'Senha'],
    ['confirm_password', 'Confirmar Senha'],
    ['group', 'Grupo'],
    ['teoric_part', 'Duração Teoria'],
    ['pratic_part', 'Duração Prática'],
    ['subscription_cost', 'Preço Inscrição'],
    ['certificate_cost', 'Preço Certificado'],
    ['quantity', 'Quantidade'],
]);

const scoreMap = new Map([
    [1, 'Mau'],
    [2, 'Insuficiente'],
    [3, 'Suficiente'],
    [4, 'Bom'],
    [5, 'Muito Bom'],
]);

const changeSG = (person) => {
    // if person is an array
    if(person.hasOwnProperty('length')) {
        for(p of person) {
            p.state = portMap.get(p.state);
            p.gender = p.gender === 'male' ? 'Masculino' : 'Feminino';
        }
    // if it is an object
    } else {
        person.state = portMap.get(person.state);
        person.gender = person.gender === 'male' ? 'Masculino' : 'Feminino';
    }
    return person;
};

const changeError = (error) => {
    error.param = errorMap.get(error.param);
    error.msg = errorMap.get(error.msg);
    return error;
};

const getProperDate = (date) => {
    date = date.split('-');
    for (let i=1; i<3; i++) {
        if (date[i].length == 1) {
            date[i] = `0${date[i]}`;
        }
    }
    return date.join('-');
};

const comparePass = (req, res, next) => {
    throw new Error('password invalid');
}

const setScore = (evaluations, discounts, increases) => {
    let media = 0, count = 0;
    for (evaluation of evaluations) {
        ev = evaluation;
        let tec = (ev.cachier*2/6) + (ev.cleaning*2/15) + (ev.customer_service*2/15) + (ev.replacement*2/15) + (ev.team_work*2/15) + (ev.cold_meats*2/15);
        let pes = (ev.flexibility*1/9) + (ev.autonomy*1/9) + (ev.punctuality*1/9) + (ev.honesty*1/9) + (ev.proactivity*1/9) + (ev.responsability*1/9) + (ev.interest_level*1/9) + (ev.availability*1/9) + (ev.personal_hygiene*1/9);
        let total = (tec * 0.6) + (pes * 0.4);
        ev.score = Number(total.toFixed(2));
        ev.scoreText = scoreMap.get(parseInt(ev.score));
        count++;
        media += ev.score;
    }
    media /= count;
    for (discount of discounts) {
        media -= discount.quantity
    }
    for (increase of increases) {
        media += increase.quantity
    }
    if (media > 5) media = 5
    if (media < 1) media = 1
    evaluations.media = Number(media.toFixed(2));
    evaluations.mediaText = scoreMap.get(parseInt(evaluations.media));
    return evaluations;
};

module.exports = {
    portMap,
    changeSG,
    changeError,
    getProperDate,
    comparePass,
    setScore
}