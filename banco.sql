-- ============================================
-- BANCO DE DADOS - COMPANHIA AEREA
-- Banco de Dados II - Unochapeco
-- ============================================

-- CRIACAO DAS TABELAS

CREATE TABLE aeronave (
    id_aeronave SERIAL PRIMARY KEY,
    modelo      VARCHAR(100) NOT NULL,
    fabricante  VARCHAR(100) NOT NULL,
    capacidade  INTEGER      NOT NULL CHECK (capacidade > 0)
);

CREATE TABLE aeroporto (
    id_aeroporto SERIAL PRIMARY KEY,
    codigo       CHAR(3)      NOT NULL UNIQUE,
    nome         VARCHAR(100) NOT NULL,
    cidade       VARCHAR(100) NOT NULL,
    pais         VARCHAR(100) NOT NULL
);

CREATE TABLE voo (
    id_voo          SERIAL PRIMARY KEY,
    codigo_voo      VARCHAR(10)  NOT NULL UNIQUE,
    id_origem       INT          NOT NULL REFERENCES aeroporto(id_aeroporto),
    id_destino      INT          NOT NULL REFERENCES aeroporto(id_aeroporto),
    horario_saida   TIMESTAMP    NOT NULL,
    horario_chegada TIMESTAMP    NOT NULL,
    status_voo      VARCHAR(20)  NOT NULL DEFAULT 'EMBARQUE'
                    CHECK (status_voo IN ('EMBARQUE','EM_CURSO','ATRASADO','POUSADO','CANCELADO')),
    id_aeronave     INT          REFERENCES aeronave(id_aeronave)
);

CREATE TABLE posicao_voo (
    id_posicao         SERIAL PRIMARY KEY,
    id_voo             INT          NOT NULL REFERENCES voo(id_voo),
    latitude           DECIMAL(9,6) NOT NULL,
    longitude          DECIMAL(9,6) NOT NULL,
    altitude_m         INT,
    percentual_trajeto DECIMAL(5,2),
    previsao_chegada   TIMESTAMP,
    atualizado_em      TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- ============================================
-- INSERCAO DE DADOS
-- ============================================

INSERT INTO aeronave (modelo, fabricante, capacidade) VALUES
('A320neo',    'Airbus',  180),
('737-800',    'Boeing',  186),
('E195-E2',    'Embraer', 136),
('ATR 72-600', 'ATR',      70),
('A321neo',    'Airbus',  220);

INSERT INTO aeroporto (codigo, nome, cidade, pais) VALUES
('GRU', 'Aeroporto Internacional de Guarulhos',     'Sao Paulo',      'Brasil'),
('GIG', 'Aeroporto Internacional do Galeao',        'Rio de Janeiro', 'Brasil'),
('BSB', 'Aeroporto Internacional de Brasilia',      'Brasilia',       'Brasil'),
('FLN', 'Aeroporto Internacional de Florianopolis', 'Florianopolis',  'Brasil'),
('FOR', 'Aeroporto Internacional Pinto Martins',    'Fortaleza',      'Brasil');

INSERT INTO voo (codigo_voo, id_origem, id_destino, horario_saida, horario_chegada, status_voo, id_aeronave) VALUES
('LA1001', 1, 2, '2026-05-11 08:00', '2026-05-11 09:10', 'EM_CURSO',  1),
('LA1002', 2, 3, '2026-05-11 09:30', '2026-05-11 10:45', 'ATRASADO',  2),
('LA1003', 3, 4, '2026-05-11 11:00', '2026-05-11 12:30', 'EMBARQUE',  3),
('LA1004', 4, 5, '2026-05-11 07:00', '2026-05-11 09:50', 'EM_CURSO',  1),
('LA1005', 1, 5, '2026-05-11 06:00', '2026-05-11 08:40', 'POUSADO',   2),
('LA1006', 5, 1, '2026-05-11 13:00', '2026-05-11 15:50', 'CANCELADO', 3);

INSERT INTO posicao_voo (id_voo, latitude, longitude, altitude_m, percentual_trajeto, previsao_chegada) VALUES
(1, -23.120, -44.380, 11000, 55.00, '2026-05-11 09:15'),
(4, -27.500, -48.100, 10500, 40.00, '2026-05-11 10:05');
