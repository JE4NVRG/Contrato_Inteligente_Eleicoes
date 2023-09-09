// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UrnaEletronica {
    
    // Estrutura para representar um candidato
    struct Candidato {
        string nome;
        string partido;
        uint numero;
        string nomeVice;
        uint votos;
    }

    // Enumeração para representar os diferentes cargos
    enum Cargo { Prefeito, Deputado, Senador, Governador, Presidente }

    // Mapeamento de cargos para uma lista de candidatos
    mapping(Cargo => Candidato[]) public candidatosPorCargo;

    // Mapeamento para verificar se um endereço já votou
    mapping(address => mapping(Cargo => bool)) public eleitores;

    // Função para adicionar um novo candidato
    function adicionarCandidato(Cargo _cargo, string memory _nome, string memory _partido, uint _numero, string memory _nomeVice) public {
        candidatosPorCargo[_cargo].push(Candidato(_nome, _partido, _numero, _nomeVice, 0));
    }

    // Função para votar em um candidato
    function votar(Cargo _cargo, uint _numeroCandidato) public {
        // Verifica se o eleitor já votou para o cargo especificado
        require(!eleitores[msg.sender][_cargo], unicode"Você já votou para este cargo!");

        // Encontra o candidato pelo número e adiciona um voto
        Candidato[] storage candidatos = candidatosPorCargo[_cargo];
        for(uint i = 0; i < candidatos.length; i++) {
            if(candidatos[i].numero == _numeroCandidato) {
                candidatos[i].votos += 1;

                // Marca o eleitor como já votado para o cargo especificado
                eleitores[msg.sender][_cargo] = true;
                return;
            }
        }
        
        // Se não encontrar o candidato, reverte a transação
        revert(unicode"Candidato não encontrado!");
    }

    // Função para obter o total de candidatos para um cargo
    function obterTotalDeCandidatos(Cargo _cargo) public view returns (uint) {
        return candidatosPorCargo[_cargo].length;
    }

    // Função para obter os detalhes de um candidato
    function obterCandidato(Cargo _cargo, uint _indiceCandidato) public view returns (string memory nome, string memory partido, uint numero, string memory nomeVice, uint votos) {
        require(_indiceCandidato < candidatosPorCargo[_cargo].length, unicode"Candidato não existe!");
        Candidato storage candidato = candidatosPorCargo[_cargo][_indiceCandidato];
        nome = candidato.nome;
        partido = candidato.partido;
        numero = candidato.numero;
        nomeVice = candidato.nomeVice;
        votos = candidato.votos;
    }
}

