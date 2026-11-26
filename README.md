# GestorDoa

Sistema web de gestão de doações para ONG, desenvolvido no **Projeto Integrador Extensionista II** do curso de Análise e Desenvolvimento de Sistemas.

Este é o esqueleto inicial do projeto: front-end criado com **Vite+** (Vanilla JavaScript) e uma API em **Express** com a rota `GET /api/health`. A página inicial consulta essa rota e mostra o status da API com a data e a hora da verificação.

## Tecnologias

- [Vite+](https://viteplus.dev/) (modelo Vanilla, JavaScript)
- [Node.js](https://nodejs.org/) 20 ou superior
- [Express](https://expressjs.com/)
- [dotenv](https://github.com/motdotla/dotenv)

## Estrutura

```
gestordoa/
├── server/
│   └── index.js       # API Express (rota GET /api/health)
├── src/
│   ├── main.js        # Página inicial: busca /api/health e mostra o status
│   └── style.css
├── index.html
├── vite.config.ts     # Configuração do Vite+ com proxy /api -> http://localhost:3000
├── .env.example       # Modelo das variáveis de ambiente
└── package.json
```

## Como rodar

1. Clone o repositório e entre na pasta:

   ```bash
   git clone https://github.com/Luizstack/GestorDoa.git
   cd GestorDoa
   ```

2. Instale as dependências:

   ```bash
   npm install
   ```

3. Crie o arquivo `.env` a partir do modelo:

   ```bash
   cp .env.example .env
   ```

   No Windows (PowerShell): `Copy-Item .env.example .env`

4. Em um terminal, inicie a API (porta 3000):

   ```bash
   npm run api
   ```

5. Em outro terminal, inicie o front-end (porta 5173):

   ```bash
   npm run dev
   ```

6. Abra <http://localhost:5173> no navegador. A página deve mostrar **"Status da API: ok"** com a data e a hora.

## Rota da API

| Método | Rota          | Resposta                                                      |
| ------ | ------------- | ------------------------------------------------------------- |
| GET    | `/api/health` | `{ "status": "ok", "timestamp": "2026-11-25T21:14:21.000Z" }` |

Teste direto na API: <http://localhost:3000/api/health>

## Variáveis de ambiente

| Variável | Descrição                 | Padrão |
| -------- | ------------------------- | ------ |
| `PORT`   | Porta em que a API escuta | `3000` |

O arquivo `.env` não é versionado (está no `.gitignore`). Use o `.env.example` como referência.
