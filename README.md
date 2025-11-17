# 🎯 Skill Match

<div align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/Material%20Design-757575?style=for-the-badge&logo=material-design&logoColor=white" alt="Material Design" />
</div>

<br/>

<p align="center">
  <strong>Ensina o que sabes, aprende algo novo! 🚀</strong><br/>
  Uma plataforma moderna de troca de habilidades que conecta pessoas com talentos únicos.
</p>

---

## ✨ Sobre o Projeto

**Skill Match** é uma aplicação mobile que revoluciona a forma como partilhamos conhecimentos. Imagina poder ensinar guitarra a alguém em troca de aulas de culinária, ou partilhar as tuas habilidades de design gráfico por aulas de fotografia!

### 🎨 Design Renovado

A aplicação foi completamente redesenhada com foco em:
- **Interface moderna e intuitiva** com animações suaves
- **Landing page atrativa** que destaca as principais funcionalidades
- **Experiência de utilizador premium** com transições fluidas
- **Paleta de cores vibrante** (Roxo primário #8A4FFF, Rosa acento #FF6B9D)
- **Cards elegantes** com gradientes e sombras suaves
- **Navegação simplificada** com bottom navigation bar

---

## 🚀 Funcionalidades

### 🏠 Landing Page
- Design moderno com gradiente animado
- Apresentação clara das funcionalidades principais
- Elementos flutuantes com animações
- Botões de entrada e registo destacados

### 🔐 Autenticação
- **Login** com validação de campos
- **Registo** com confirmação de password
- Animações de transição suaves
- Design responsivo e acessível

### 📱 Homepage
- Lista de ofertas com informação detalhada
- Sistema de filtros por categoria
- Barra de pesquisa funcional
- Cards com design premium mostrando:
  - Avatar e nome do utilizador
  - Distância aproximada
  - Avaliação e número de reviews
  - Habilidade oferecida
  - Habilidade procurada
  - Botões de ação (Detalhes e Contactar)

### ➕ Criar Oferta
- Processo em 3 passos intuitivo
- Seleção de categoria com ícones
- Indicador de progresso visual
- Resumo final antes de publicar
- Modal de confirmação elegante

### 🗺️ Mapa (Em desenvolvimento)
- Visualização de ofertas por localização
- Marcadores interativos
- Filtros de distância

---

## 🎨 Paleta de Cores

```dart
Primary Color:    #8A4FFF  // Roxo vibrante
Secondary Color:  #E5D4FF  // Lilás suave
Accent Color:     #FF6B9D  // Rosa energético
Background:       #FFFFFF  // Branco puro
Surface:          #F8F7FF  // Branco lilás
Text:             #1A1A1A  // Preto suave
Grey:             #9E9E9E  // Cinza neutro
```

---

## 📱 Estrutura do Projeto

```
lib/
├── main.dart                          # Ponto de entrada da aplicação
├── theme/
│   └── app_theme.dart                 # Tema global com cores e estilos
├── screens/
│   ├── landing_screen.dart            # ✨ NOVO: Landing page animada
│   ├── login_screen.dart              # 🔄 Atualizado: Login redesenhado
│   ├── register_screen.dart           # 🔄 Atualizado: Registo melhorado
│   ├── homepage_screen.dart           # 🔄 Atualizado: Homepage moderna
│   ├── create_offer_screen.dart       # 🔄 Atualizado: Criação em passos
│   └── map_screen.dart                # Mapa de ofertas
├── models/
│   └── user_roles.dart                # Modelos de dados
├── services/
│   ├── auth_service.dart              # Serviço de autenticação
│   ├── map_service.dart               # Serviço de mapas
│   └── offer_service.dart             # Serviço de ofertas
└── api/
    └── mock_api.dart                  # API mock para desenvolvimento
```

---

## 🛠️ Tecnologias Utilizadas

- **Flutter** - Framework de desenvolvimento mobile
- **Dart** - Linguagem de programação
- **Material Design 3** - Sistema de design moderno
- **Google Maps** - Integração de mapas
- **Animações Flutter** - Transições suaves e elegantes

---

## 📋 Pré-requisitos

- Flutter SDK (>=2.12.0 <3.0.0)
- Dart SDK
- Android Studio / VS Code
- Emulador Android ou iOS / Dispositivo físico

---

## 🚀 Como Executar

### 1. Clone o repositório
```bash
git clone https://github.com/seu-usuario/skill_match.git
cd skill_match
```

### 2. Instale as dependências
```bash
flutter pub get
```

### 3. Execute a aplicação
```bash
flutter run
```

### 4. Para executar em modo release (melhor performance)
```bash
flutter run --release
```

---

## 🎯 Próximos Passos

- [ ] Implementar backend real
- [ ] Sistema de chat integrado
- [ ] Notificações push
- [ ] Sistema de avaliações
- [ ] Perfil de utilizador completo
- [ ] Sistema de favoritos
- [ ] Filtros avançados
- [ ] Modo escuro
- [ ] Suporte para múltiplos idiomas
- [ ] Integração com redes sociais

---

## 🤝 Contribuições

Contribuições são bem-vindas! Sinta-se à vontade para:
1. Fazer fork do projeto
2. Criar uma branch para sua feature (`git checkout -b feature/NovaFuncionalidade`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova funcionalidade'`)
4. Push para a branch (`git push origin feature/NovaFuncionalidade`)
5. Abrir um Pull Request

---

## 📝 Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

---

## 👤 Autor

Desenvolvido com ❤️ e muito ☕

---

## 📸 Screenshots

### Landing Page
Interface inicial com apresentação das funcionalidades principais

### Homepage
Lista de ofertas disponíveis com design moderno

### Criar Oferta
Processo intuitivo em 3 passos para publicar uma nova oferta

---

<p align="center">
  <strong>⭐ Se gostaste do projeto, deixa uma estrela! ⭐</strong>
</p> 

