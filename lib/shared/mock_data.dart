final Map<String, dynamic> companyData = {
  "name": "Empresa Exemplo",
  "imageUrl": 'assets/images/img-company.png',
  "address": "Rua Exemplo, 123",
  "phoneNumber": "(11) 1234-5678",
  "workingHours": "Seg-Sex, 8h às 18h",
  "rating": 4.5,
  "accessibilityData": {
    "Acessibilidade Física": [
      {"tipo": "Rampas", "status": true},
      {"tipo": "Elevadores", "status": true},
      {"tipo": "Portas Largas", "status": true},
      {"tipo": "Banheiros Adaptados", "status": false},
      {"tipo": "Pisos e Superfícies Anti-derrapantes", "status": true},
      {"tipo": "Estacionamento Reservado", "status": true}
    ],
    "Acessibilidade Comunicacional": [
      {"tipo": "Sinalização com Braille e Pictogramas", "status": true},
      {"tipo": "Informações Visuais Claras e Contrastantes", "status": true},
      {"tipo": "Dispositivos Auditivos", "status": false},
      {"tipo": "Documentos e Materiais em Formatos Acessíveis", "status": true}
    ],
    "Acessibilidade Sensorial": [
      {"tipo": "Iluminação Adequada", "status": true},
      {"tipo": "Redução de Ruídos", "status": true}
    ],
    "Acessibilidade Atitudinal": [
      {"tipo": "Treinamento de Funcionários", "status": true},
      {"tipo": "Políticas Inclusivas", "status": true}
    ],
  },
  "performanceData": {
    "numberOfComments": "150",
    "responseRate": "98%",
    "pendingConversations": "2",
    "numberOfReviews": "130",
    "averageRating": "9.2",
    "returningCustomersPercentage": "92,5%",
    "resolvedConversationsRate": "97%",
    "averageResponseTime": "14 horas",
  },
  "commentsData": [
    {
      "title": "Excelente acessibilidade!",
      "userImage": 'assets/images/placeholder-user.png',
      "userName": "Carlos Souza",
      "text": "O local é muito bem adaptado para cadeirantes.",
      "date": "02/09/2024",
    },
    {
      "title": "Muito bom",
      "userImage": 'assets/images/placeholder-user.png',
      "userName": "Ana Oliveira",
      "text": "Gostei muito do atendimento e das instalações.",
      "date": "30/08/2024",
    },
  ],
  "cnpj": "12345678000190",
  "registrationDate": "01 de Fev de 2024",
  "about":
      "Empresa de exemplo especializada em soluções acessíveis para todos. Comprometida com a inclusão e acessibilidade.",
};

// Dados de acessibilidade (Itens que vão ficar no firebase, para o filtro de acessibilidade)
final Map<String, List<Map<String, dynamic>>> accessibilityData = {
  "Acessibilidade Física": [
    {"tipo": "Rampas", "status": false},
    {"tipo": "Elevadores", "status": false},
    {"tipo": "Portas Largas", "status": false},
    {"tipo": "Banheiros Adaptados", "status": false},
    {"tipo": "Pisos e Superfícies Anti-derrapantes", "status": false},
    {"tipo": "Estacionamento Reservado", "status": false}
  ],
  "Acessibilidade Comunicacional": [
    {"tipo": "Sinalização com Braille e Pictogramas", "status": false},
    {"tipo": "Informações Visuais Claras e Contrastantes", "status": false},
    {"tipo": "Dispositivos Auditivos", "status": false},
    {"tipo": "Documentos e Materiais em Formatos Acessíveis", "status": false}
  ],
  "Acessibilidade Sensorial": [
    {"tipo": "Iluminação Adequada", "status": false},
    {"tipo": "Redução de Ruídos", "status": false}
  ],
  "Acessibilidade Atitudinal": [
    {"tipo": "Treinamento de Funcionários", "status": false},
    {"tipo": "Políticas Inclusivas", "status": false}
  ],
};

// Dados sobre ranking das empresas (Itens que vão ficar no firebase)
final Map<String, List<Map<String, dynamic>>> companyRakingData = {
  'company': [
    {
      'name': 'Empresa 1',
      'rating': 4,
      'imageUrl': 'assets/images/img-company.png'
    },
    {
      'name': 'Empresa 2',
      'rating': 4,
      'imageUrl': 'assets/images/img-company.png'
    },
    {
      'name': 'Empresa 3',
      'rating': 3,
      'imageUrl': 'assets/images/img-company.png'
    },
    {
      'name': 'Empresa 4',
      'rating': 2,
      'imageUrl': 'assets/images/img-company.png'
    },
  ]
};
