import psycopg2
import redis
import json

pg = psycopg2.connect(
    host="172.20.240.1",
    database="companhia_aerea",
    user="postgres",
    password="123"
)

r = redis.Redis(host="localhost", port=6379, decode_responses=True)
cursor = pg.cursor()

cursor.execute("""
    SELECT v.id_voo, v.codigo_voo,
           a1.nome AS origem, a2.nome AS destino,
           v.horario_saida, v.horario_chegada,
           v.status_voo,
           p.latitude, p.longitude,
           p.percentual_trajeto, p.previsao_chegada
    FROM voo v
    JOIN aeroporto a1 ON v.id_origem = a1.id_aeroporto
    JOIN aeroporto a2 ON v.id_destino = a2.id_aeroporto
    LEFT JOIN posicao_voo p ON p.id_voo = v.id_voo
    WHERE v.status_voo = 'EM_CURSO'
    ORDER BY p.atualizado_em DESC NULLS LAST
""")

voos = cursor.fetchall()
r.delete("voos_em_curso")

for voo in voos:
    id_voo, codigo, origem, destino, saida, chegada, status, lat, lon, pct, prev = voo
    r.rpush("voos_em_curso", id_voo)
    r.hset("voo:" + str(id_voo), mapping={
        "codigo": codigo,
        "origem": origem,
        "destino": destino,
        "horario_saida": str(saida),
        "horario_chegada": str(chegada),
        "status": status,
        "latitude": str(lat) if lat else "",
        "longitude": str(lon) if lon else "",
        "percentual_trajeto": str(pct) if pct else "",
        "previsao_chegada": str(prev) if prev else "",
    })
    print("Voo " + codigo + " salvo no Redis")

print("\n--- Voos em curso no Redis ---")
ids = r.lrange("voos_em_curso", 0, -1)
for id_voo in ids:
    dados = r.hgetall("voo:" + str(id_voo))
    print(json.dumps(dados, indent=2, ensure_ascii=False))

cursor.close()
pg.close()
print("\nConcluido!")
