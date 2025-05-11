# 🔐 Sistema de Segurança Inteligente com Reconhecimento Facial

Este projeto tem como objetivo desenvolver um sistema de segurança inteligente voltado ao controle de acesso e monitoramento de indivíduos, integrando tecnologias de reconhecimento facial, autenticação via Firebase e um dashboard informativo com gestão de dados criminais.

## 📌 Objetivo

Desenvolver uma aplicação de reconhecimento facial que permita aos oficiais de polícia realizarem consultas ágeis e precisas de antecedentes criminais
durante abordagens, garantindo eficiência operacional sem comprometer a privacidade e os direitos individuais dos cidadãos.


---

## 🧱 Tecnologias Utilizadas

### 🔧 Backend – FastAPI
- FastAPI para construção da API REST
- SQLAlchemy e Pydantic para modelagem e validação
- Banco de dados relacional (PostgreSQL)
- Firebase Authentication (verificação JWT)
- Reconhecimento facial via OpenCV + deep learning
- Documentação automática com Swagger

### 📱 Frontend – Flutter
- Flutter com arquitetura em camadas (Model, View, Controller)
- Integração com API REST via `http` ou `dio`
- Firebase Auth (login e autenticação)
- Navegação com `go_router` (ou `Navigator`)
- Layouts responsivos para tablets e smartphones

---

## 🧠 Funcionalidades

### ✅ Back-End (API)
- 🔐 Autenticação via Firebase JWT
- 📸 Upload e reconhecimento facial com retorno de CPF
- 👤 CRUD de ficha criminal (ligada a uma pessoa)
- 🛑 Alertas de segurança por CPF
- 📁 Upload de imagens e associação com registros

### 📱 Front-End (App Flutter)
- 🔐 Tela de login com Firebase
- 📑 Visualização da ficha criminal de cada pessoa
- 🚨 Visualização e alerta de ocorrência
- 📷 Scanner de rosto e envio de imagem para API
- 🔍 Pesquisa por CPF

---

## 🔄 Fluxo de Integração

1. **Login** → Firebase retorna token JWT
2. **Acesso à API** → Token é enviado via `Authorization: Bearer`
3. **Reconhecimento Facial** → App envia imagem → API retorna CPF → App busca ficha criminal


---

## 🗃️ Estrutura da API

A documentação completa está disponível via Swagger no endpoint `/docs` assim que a API estiver rodando.

Principais endpoints:

- `POST /login/verify-token/` – Verifica validade do JWT
- `POST /pessoa/` – Cria novo registro de pessoa
- `GET /pessoa/{cpf}` – Retorna dados de uma pessoa
- `POST /ficha-criminal/` – Cadastra ficha criminal
- `POST /reconhecimento-facial/` – Envia imagem para identificação

---

## ⚙️ Executando o Projeto

```bash
# Requisitos
Python 3.10+
MySQL em execução
Firebase configurado

# Instalar dependências
pip install -r requirements.txt

# Rodar servidor
uvicorn main:app --reload
