-- =====================================================================
-- GestorDoa · schema.sql
-- Associação Mesa Solidária · banco de alimentos (ONG fictícia)
-- PIE II · Atividade 2 · baseado no MER do Documento de Visão (PIE I)
--
-- Recria o banco do zero: pode ser executado várias vezes seguidas.
--
-- Entidades:  usuario, familia, tipo_alimento, alimento, entrega
-- Associativa (N:N entre entrega e alimento): entrega_alimento
--
-- LGPD: da família guardamos só o que o atendimento usa (nome do
-- responsável, telefone, bairro e número de pessoas). Sem CPF e sem
-- endereço completo, porque a cesta é retirada na sede.
-- =====================================================================

SET NAMES utf8mb4;
DROP DATABASE IF EXISTS gestordoa;
CREATE DATABASE gestordoa CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE gestordoa;

-- ---------------------------------------------------------------------
-- USUARIO: quem acessa o sistema (coordenador ou voluntário)
-- ---------------------------------------------------------------------
CREATE TABLE usuario (
  id_usuario INT AUTO_INCREMENT PRIMARY KEY,
  nome       VARCHAR(150) NOT NULL,
  email      VARCHAR(100) NOT NULL UNIQUE,
  senha_hash VARCHAR(255) NOT NULL,                -- hash bcrypt, nunca a senha
  perfil     ENUM('coordenador', 'voluntario') NOT NULL DEFAULT 'voluntario',
  ativo      BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT chk_usuario_email CHECK (email LIKE '%_@_%._%')
);

-- ---------------------------------------------------------------------
-- FAMILIA: família atendida, que retira uma cesta por mês
-- ---------------------------------------------------------------------
CREATE TABLE familia (
  id_familia       INT AUTO_INCREMENT PRIMARY KEY,
  nome_responsavel VARCHAR(150) NOT NULL,
  telefone         VARCHAR(20)  NOT NULL UNIQUE,   -- impede cadastro duplicado (RF4)
  bairro           VARCHAR(80)  NOT NULL,
  qtd_pessoas      INT NOT NULL DEFAULT 1,
  data_cadastro    DATE NOT NULL DEFAULT (CURRENT_DATE),
  ativo            BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT chk_familia_pessoas CHECK (qtd_pessoas > 0)
);

-- ---------------------------------------------------------------------
-- TIPO_ALIMENTO: grãos, laticínios, óleos, enlatados, higiene...
-- ---------------------------------------------------------------------
CREATE TABLE tipo_alimento (
  id_tipo   INT AUTO_INCREMENT PRIMARY KEY,
  nome      VARCHAR(60) NOT NULL UNIQUE,
  descricao VARCHAR(255)
);

-- ---------------------------------------------------------------------
-- ALIMENTO: item do estoque da sede
-- Relacionamento N:1 -> vários alimentos pertencem a um tipo
-- ---------------------------------------------------------------------
CREATE TABLE alimento (
  id_alimento        INT AUTO_INCREMENT PRIMARY KEY,
  id_tipo            INT NOT NULL,
  nome               VARCHAR(150) NOT NULL,
  unidade            ENUM('kg', 'l', 'un', 'pct') NOT NULL DEFAULT 'un',
  quantidade_estoque INT NOT NULL DEFAULT 0,
  estoque_minimo     INT NOT NULL DEFAULT 0,
  ativo              BOOLEAN NOT NULL DEFAULT TRUE,
  -- o mesmo alimento não é cadastrado duas vezes na mesma unidade
  CONSTRAINT uq_alimento_nome_unidade UNIQUE (nome, unidade),
  -- o estoque nunca fica negativo
  CONSTRAINT chk_alimento_estoque CHECK (quantidade_estoque >= 0),
  CONSTRAINT chk_alimento_minimo  CHECK (estoque_minimo >= 0),
  FOREIGN KEY (id_tipo) REFERENCES tipo_alimento (id_tipo)
);

-- ---------------------------------------------------------------------
-- ENTREGA: entrega de uma cesta a uma família
-- Relacionamentos 1:N -> uma família recebe várias entregas;
--                        um usuário registra várias entregas
-- Sem CASCADE: família e usuário com entregas não podem ser apagados,
-- para não perder o histórico (desative com ativo = FALSE)
-- ---------------------------------------------------------------------
CREATE TABLE entrega (
  id_entrega   INT AUTO_INCREMENT PRIMARY KEY,
  id_familia   INT NOT NULL,
  id_usuario   INT NOT NULL,
  data_entrega DATE NOT NULL,
  status       ENUM('agendada', 'entregue', 'cancelada') NOT NULL DEFAULT 'agendada',
  observacao   VARCHAR(255),
  data_criacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_familia) REFERENCES familia (id_familia),
  FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
);

-- ---------------------------------------------------------------------
-- ENTREGA_ALIMENTO: associativa N:N entre entrega e alimento
-- Uma cesta contém vários alimentos; um alimento sai em várias cestas
-- Excluir a entrega apaga os itens dela (ON DELETE CASCADE)
-- ---------------------------------------------------------------------
CREATE TABLE entrega_alimento (
  id_entrega  INT NOT NULL,
  id_alimento INT NOT NULL,
  quantidade  INT NOT NULL CHECK (quantidade > 0),
  PRIMARY KEY (id_entrega, id_alimento),
  FOREIGN KEY (id_entrega)  REFERENCES entrega (id_entrega) ON DELETE CASCADE,
  FOREIGN KEY (id_alimento) REFERENCES alimento (id_alimento)
);
