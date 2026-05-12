-- CRIACAO DAS TABELAS
CREATE TABLE aeroporto (
    id_aeroporto SERIAL PRIMARY KEY,
    codigo       CHAR(3)      NOT NULL UNIQUE,
    nome         VARCHAR(100) NOT NULL,
    cidade       VARCHAR(100) NOT NULL,
    pais         VARCHAR(100) NOT NULL
);

CREATE TABLE voo (
    id_voo            SERIAL PRIMARY KEY,
    codigo_voo        VARCHAR(10)  NOT NULL UNIQUE,
    id_origem         INT          NOT NULL REFERENCES aeroporto(id_aeroporto),
    id_destino        INT          NOT NULL REFERENCES aeroporto(id_aeroporto),
    horario_saida     TIMESTAMP    NOT NULL,
    horario_chegada   TIMESTAMP    NOT NULL,
    status_voo        VARCHAR(20)  NOT NULL DEFAULT 'EMBARQUE'
                      CHECK (status_voo IN ('EMBARQUE','EM_CURSO','ATRASADO','POUSADO','CANCELADO'))
);

CREATE TABLE posicao_voo (
    id_posicao        SERIAL PRIMARY KEY,
    id_voo            INT          NOT NULL REFERENCES voo(id_voo),
    latitude          DECIMAL(9,6) NOT NULL,
    longitude         DECIMAL(9,6) NOT NULL,
    altitude_m        INT,
    percentual_trajeto DECIMAL(5,2),
    previsao_chegada  TIMESTAMP,
    atualizado_em     TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- INSERCAO DE DADOS
INSERT INTO aeroporto (codigo, nome, cidade, pais) VALUES
('GRU', 'Aeroporto Internacional de Guarulhos', 'Sao Paulo', 'Brasil'),
('GIG', 'Aeroporto Internacional do Galeao', 'Rio de Janeiro', 'Brasil'),
('BSB', 'Aeroporto Internacional de Brasilia', 'Brasilia', 'Brasil'),
('FLN', 'Aeroporto Internacional de Florianopolis', 'Florianopolis', 'Brasil'),
('FOR', 'Aeroporto Internacional Pinto Martins', 'Fortaleza', 'Brasil');

INSERT INTO voo (codigo_voo, id_origem, id_destino, horario_saida, horario_chegada, status_voo) VALUES
('LA1001', 1, 2, '2026-05-11 08:00', '2026-05-11 09:10', 'EM_CURSO'),
('LA1002', 2, 3, '2026-05-11 09:30', '2026-05-11 10:45', 'ATRASADO'),
('LA1003', 3, 4, '2026-05-11 11:00', '2026-05-11 12:30', 'EMBARQUE'),
('LA1004', 4, 5, '2026-05-11 07:00', '2026-05-11 09:50', 'EM_CURSO'),
('LA1005', 1, 5, '2026-05-11 06:00', '2026-05-11 08:40', 'POUSADO'),
('LA1006', 5, 1, '2026-05-11 13:00', '2026-05-11 15:50', 'CANCELADO');

INSERT INTO posicao_voo (id_voo, latitude, longitude, altitude_m, percentual_trajeto, previsao_chegada) VALUES
(1, -23.120, -44.380, 11000, 55.00, '2026-05-11 09:15'),
(4, -27.500, -48.100, 10500, 40.00, '2026-05-11 10:05');

-- CONSULTAS
-- 1. Todos os dados de um voo
SELECT v.*, a1.nome AS origem, a2.nome AS destino
FROM voo v
JOIN aeroporto a1 ON v.id_origem = a1.id_aeroporto
JOIN aeroporto a2 ON v.id_destino = a2.id_aeroporto
WHERE v.codigo_voo = 'LA1001';

-- 2. Posicao de um voo
SELECT v.codigo_voo, p.latitude, p.longitude,
       p.altitude_m, p.percentual_trajeto, p.previsao_chegada
FROM posicao_voo p
JOIN voo v ON p.id_voo = v.id_voo
WHERE v.codigo_voo = 'LA1001';

-- 3. Voos em atraso
SELECT codigo_voo, horario_saida, horario_chegada
FROM voo WHERE status_voo = 'ATRASADO';

-- 4. Voos cancelados
SELECT codigo_voo, horario_saida, horario_chegada
FROM voo WHERE status_voo = 'CANCELADO';
