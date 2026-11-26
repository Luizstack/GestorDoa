import "./style.css";

const app = document.querySelector("#app");

app.innerHTML = `
  <main class="card">
    <h1>GestorDoa</h1>
    <p class="subtitle">Sistema de gestão de doações da ONG</p>
    <p id="status" class="status">Consultando a API...</p>
    <p id="horario" class="horario"></p>
  </main>
`;

async function carregarStatus() {
  const statusEl = document.querySelector("#status");
  const horarioEl = document.querySelector("#horario");

  try {
    const resposta = await fetch("/api/health");
    if (!resposta.ok) throw new Error(`HTTP ${resposta.status}`);
    const dados = await resposta.json();

    statusEl.textContent = `Status da API: ${dados.status}`;
    statusEl.classList.add("ok");
    horarioEl.textContent = `Verificado em ${new Date(dados.timestamp).toLocaleString("pt-BR")}`;
  } catch (erro) {
    statusEl.textContent = "Status da API: indisponível";
    statusEl.classList.add("erro");
    horarioEl.textContent = "Verifique se a API está rodando (npm run api).";
    console.error(erro);
  }
}

void carregarStatus();
