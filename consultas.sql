-- 1. Todos os dados de um voo
SELECT v.*,
       a1.nome AS origem,
       a2.nome AS destino,
       ae.modelo AS aeronave,
       ae.fabricante
FROM voo v
JOIN aeroporto a1 ON v.id_origem = a1.id_aeroporto
JOIN aeroporto a2 ON v.id_destino = a2.id_aeroporto
LEFT JOIN aeronave ae ON v.id_aeronave = ae.id_aeronave
WHERE v.codigo_voo = 'LA1001';

-- 2. Dados de posicao de um voo
SELECT v.codigo_voo, p.latitude, p.longitude,
       p.altitude_m, p.percentual_trajeto, p.previsao_chegada
FROM posicao_voo p
JOIN voo v ON p.id_voo = v.id_voo
WHERE v.codigo_voo = 'LA1001';

-- 3. Lista dos voos em atraso
SELECT v.codigo_voo, v.horario_saida, v.horario_chegada,
       a1.nome AS origem, a2.nome AS destino
FROM voo v
JOIN aeroporto a1 ON v.id_origem = a1.id_aeroporto
JOIN aeroporto a2 ON v.id_destino = a2.id_aeroporto
WHERE v.status_voo = 'ATRASADO';

-- 4. Lista dos voos cancelados
SELECT v.codigo_voo, v.horario_saida, v.horario_chegada,
       a1.nome AS origem, a2.nome AS destino
FROM voo v
JOIN aeroporto a1 ON v.id_origem = a1.id_aeroporto
JOIN aeroporto a2 ON v.id_destino = a2.id_aeroporto
WHERE v.status_voo = 'CANCELADO';
