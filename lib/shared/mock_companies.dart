import 'package:acesso_mapeado/models/company_model.dart';

final List<CompanyModel> mockCompanies = [
  CompanyModel(
    name: 'Tech Innovators SP',
    rating: 4.5,
    imageUrl: 'https://via.placeholder.com/150.png?text=Tech+Innovators+SP',
    address: 'Av. Paulista, 1000, São Paulo, SP',
    latitude: -23.561684,
    longitude: -46.655981,
    phoneNumber: '+55 11 91234-5678',
    workingHours: '9:00 AM - 6:00 PM',
    cnpj: '12.345.678/0001-99',
    registrationDate: '2020-01-15',
    about:
        'Leading company in tech innovations, providing cutting-edge solutions.',
    accessibilityData: {
      'Entradas': [
        {'tipo': 'Rampa', 'status': true},
        {'tipo': 'Elevador', 'status': true},
      ],
      'Banheiros': [
        {'tipo': 'Acessível', 'status': true},
      ],
    },
    commentsData: [
      {
        'title': 'Excelente Atendimento',
        'userName': 'João Silva',
        'userImage': 'https://via.placeholder.com/50.png?text=João',
        'text':
            'A empresa tem um atendimento incrível e produtos de alta qualidade!',
        'date': '2023-08-12',
      },
      {
        'title': 'Ótima Experiência',
        'userName': 'Maria Souza',
        'userImage': 'https://via.placeholder.com/50.png?text=Maria',
        'text': 'Fiquei muito satisfeita com os serviços prestados.',
        'date': '2023-07-20',
      },
    ],
    performanceData: {
      'Satisfação do Cliente': '90%',
      'Crescimento Anual': '15%',
    },
  ),
  CompanyModel(
    name: 'Green Earth GS',
    rating: 3.8,
    imageUrl: 'https://via.placeholder.com/150.png?text=Green+Earth+GS',
    address: 'Rua Oscar Freire, 500, São Paulo, SP',
    latitude: -23.561414,
    longitude: -46.660797,
    phoneNumber: '+55 11 92345-6789',
    workingHours: '8:00 AM - 5:00 PM',
    cnpj: '98.765.432/0001-11',
    registrationDate: '2019-05-22',
    about: 'Sustainable solutions for a greener planet.',
    accessibilityData: {
      'Entradas': [
        {'tipo': 'Porta Automática', 'status': true},
        {'tipo': 'Rampa', 'status': true},
      ],
      'Banheiros': [
        {'tipo': 'Acessível', 'status': true},
      ],
    },
    commentsData: [
      {
        'title': 'Compromisso Ambiental',
        'userName': 'Carlos Pereira',
        'userImage': 'https://via.placeholder.com/50.png?text=Carlos',
        'text': 'Adoro como a Green Earth prioriza a sustentabilidade.',
        'date': '2023-06-10',
      },
    ],
    performanceData: {
      'Impacto Ambiental': 'Redução de 25% nas emissões',
      'Crescimento Anual': '20%',
    },
  ),
  CompanyModel(
    name: 'HealthFirst SP',
    rating: 4.2,
    imageUrl: 'https://via.placeholder.com/150.png?text=HealthFirst+SP',
    address: 'Av. Brigadeiro Faria Lima, 2000, São Paulo, SP',
    latitude: -23.5867,
    longitude: -46.6596,
    phoneNumber: '+55 11 93456-7890',
    workingHours: '24 Horas',
    cnpj: '11.222.333/0001-44',
    registrationDate: '2021-03-10',
    about: 'Comprehensive healthcare services for all your needs.',
    accessibilityData: {
      'Entradas': [
        {'tipo': 'Elevador', 'status': true},
      ],
      'Banheiros': [
        {'tipo': 'Acessível', 'status': true},
      ],
    },
    commentsData: [
      {
        'title': 'Serviço Excelente',
        'userName': 'Ana Lima',
        'userImage': 'https://via.placeholder.com/50.png?text=Ana',
        'text': 'Equipe médica muito atenciosa e profissional.',
        'date': '2023-09-01',
      },
    ],
    performanceData: {
      'Satisfação do Cliente': '85%',
      'Crescimento Anual': '10%',
    },
  ),
  CompanyModel(
    name: 'EduLearn GS',
    rating: 2.7,
    imageUrl: 'https://via.placeholder.com/150.png?text=EduLearn+GS',
    address: 'Rua Augusta, 1500, São Paulo, SP',
    latitude: -23.561396,
    longitude: -46.660121,
    phoneNumber: '+55 11 94567-8901',
    workingHours: '9:00 AM - 8:00 PM',
    cnpj: '55.666.777/0001-88',
    registrationDate: '2018-11-05',
    about: 'Innovative educational platforms for modern learners.',
    accessibilityData: {
      'Entradas': [
        {'tipo': 'Porta Automática', 'status': true},
      ],
      'Banheiros': [
        {'tipo': 'Acessível', 'status': true},
        {'tipo': 'Sem Barreiras', 'status': true},
      ],
    },
    commentsData: [
      {
        'title': 'Plataforma Intuitiva',
        'userName': 'Pedro Almeida',
        'userImage': 'https://via.placeholder.com/50.png?text=Pedro',
        'text': 'Aprender nunca foi tão fácil e agradável!',
        'date': '2023-07-18',
      },
    ],
    performanceData: {
      'Satisfação do Cliente': '92%',
      'Crescimento Anual': '18%',
    },
  ),
  CompanyModel(
    name: 'AutoDrive SP',
    rating: 3.3,
    imageUrl: 'https://via.placeholder.com/150.png?text=AutoDrive+SP',
    address: 'Av. Rebouças, 3000, São Paulo, SP',
    latitude: -23.5543,
    longitude: -46.6665,
    phoneNumber: '+55 11 95678-9012',
    workingHours: '10:00 AM - 7:00 PM',
    cnpj: '99.888.777/0001-66',
    registrationDate: '2022-07-19',
    about: 'Advanced automotive solutions for the modern world.',
    accessibilityData: {
      'Entradas': [
        {'tipo': 'Rampa', 'status': true},
      ],
      'Banheiros': [
        {'tipo': 'Acessível', 'status': true},
      ],
    },
    commentsData: [
      {
        'title': 'Tecnologia de Ponta',
        'userName': 'Lucas Fernandes',
        'userImage': 'https://via.placeholder.com/50.png?text=Lucas',
        'text': 'Veículos com tecnologias incríveis e design moderno.',
        'date': '2023-05-25',
      },
    ],
    performanceData: {
      'Satisfação do Cliente': '88%',
      'Crescimento Anual': '12%',
    },
  ),
  CompanyModel(
    name: 'Foodies Hub SP',
    rating: 4.4,
    imageUrl: 'https://via.placeholder.com/150.png?text=Foodies+Hub+SP',
    address: 'Rua Oscar Freire, 350, São Paulo, SP',
    latitude: -23.561414,
    longitude: -46.660797,
    phoneNumber: '+55 11 96789-0123',
    workingHours: '11:00 AM - 10:00 PM',
    cnpj: '33.444.555/0001-22',
    registrationDate: '2017-09-30',
    about: 'Diverse culinary experiences from around the world.',
    accessibilityData: {
      'Entradas': [
        {'tipo': 'Porta Automática', 'status': true},
        {'tipo': 'Rampa', 'status': true},
      ],
      'Banheiros': [
        {'tipo': 'Acessível', 'status': true},
      ],
    },
    commentsData: [
      {
        'title': 'Variedade Incrível',
        'userName': 'Fernanda Costa',
        'userImage': 'https://via.placeholder.com/50.png?text=Fernanda',
        'text': 'Tem opções deliciosas para todos os gostos!',
        'date': '2023-04-15',
      },
    ],
    performanceData: {
      'Satisfação do Cliente': '91%',
      'Crescimento Anual': '14%',
    },
  ),
  CompanyModel(
    name: 'FitLife Gym SP',
    rating: 3.4,
    imageUrl: 'https://via.placeholder.com/150.png?text=FitLife+Gym+SP',
    address: 'Av. Ibirapuera, 4000, São Paulo, SP',
    latitude: -23.5874,
    longitude: -46.6566,
    phoneNumber: '+55 11 97890-1234',
    workingHours: '6:00 AM - 11:00 PM',
    cnpj: '66.555.444/0001-33',
    registrationDate: '2016-04-12',
    about: 'State-of-the-art fitness center with personal trainers.',
    accessibilityData: {
      'Entradas': [
        {'tipo': 'Rampa', 'status': true},
      ],
      'Banheiros': [
        {'tipo': 'Acessível', 'status': true},
      ],
    },
    commentsData: [
      {
        'title': 'Excelente Infraestrutura',
        'userName': 'Rafael Gomes',
        'userImage': 'https://via.placeholder.com/50.png?text=Rafael',
        'text': 'Equipamentos modernos e ambiente motivador.',
        'date': '2023-03-10',
      },
    ],
    performanceData: {
      'Satisfação do Cliente': '89%',
      'Crescimento Anual': '16%',
    },
  ),
  CompanyModel(
    name: 'TravelSphere SP',
    rating: 4.1,
    imageUrl: 'https://via.placeholder.com/150.png?text=TravelSphere+SP',
    address: 'Rua Haddock Lobo, 2000, São Paulo, SP',
    latitude: -23.5694,
    longitude: -46.6603,
    phoneNumber: '+55 11 98901-2345',
    workingHours: '8:00 AM - 8:00 PM',
    cnpj: '44.333.222/0001-11',
    registrationDate: '2021-12-05',
    about: 'Comprehensive travel planning and booking services.',
    accessibilityData: {
      'Entradas': [
        {'tipo': 'Porta Automática', 'status': true},
      ],
      'Banheiros': [
        {'tipo': 'Acessível', 'status': true},
      ],
    },
    commentsData: [
      {
        'title': 'Planejamento Perfeito',
        'userName': 'Sofia Ramos',
        'userImage': 'https://via.placeholder.com/50.png?text=Sofia',
        'text': 'Minha viagem foi planejada de forma impecável.',
        'date': '2023-02-20',
      },
    ],
    performanceData: {
      'Satisfação do Cliente': '87%',
      'Crescimento Anual': '13%',
    },
  ),
  CompanyModel(
    name: 'EcoClean Services GS',
    rating: 1.2,
    imageUrl: 'https://via.placeholder.com/150.png?text=EcoClean+Services+GS',
    address: 'Av. Brigadeiro Faria Lima, 2500, São Paulo, SP',
    latitude: -23.5833,
    longitude: -46.6800,
    phoneNumber: '+55 11 90012-3456',
    workingHours: '7:00 AM - 7:00 PM',
    cnpj: '77.888.999/0001-00',
    registrationDate: '2015-06-25',
    about:
        'Environmentally friendly cleaning services for homes and businesses.',
    accessibilityData: {
      'Entradas': [
        {'tipo': 'Rampa', 'status': true},
      ],
      'Banheiros': [
        {'tipo': 'Acessível', 'status': true},
      ],
    },
    commentsData: [
      {
        'title': 'Serviço Impecável',
        'userName': 'Gabriel Oliveira',
        'userImage': 'https://via.placeholder.com/50.png?text=Gabriel',
        'text': 'Ambiente limpo e equipe muito profissional.',
        'date': '2023-01-30',
      },
    ],
    performanceData: {
      'Satisfação do Cliente': '95%',
      'Crescimento Anual': '22%',
    },
  ),
  CompanyModel(
    name: 'Artistic Minds SP',
    rating: 2.0,
    imageUrl: 'https://via.placeholder.com/150.png?text=Artistic+Minds+SP',
    address: 'Rua Augusta, 1800, São Paulo, SP',
    latitude: -23.5627,
    longitude: -46.6640,
    phoneNumber: '+55 11 90123-4567',
    workingHours: '10:00 AM - 8:00 PM',
    cnpj: '22.333.444/0001-55',
    registrationDate: '2020-09-18',
    about: 'Art studios and workshops fostering creativity.',
    accessibilityData: {
      'Entradas': [
        {'tipo': 'Porta Automática', 'status': true},
        {'tipo': 'Elevador', 'status': true},
      ],
      'Banheiros': [
        {'tipo': 'Acessível', 'status': true},
      ],
    },
    commentsData: [
      {
        'title': 'Ambiente Inspirador',
        'userName': 'Laura Mendes',
        'userImage': 'https://via.placeholder.com/50.png?text=Laura',
        'text':
            'Espaço perfeito para desenvolver minhas habilidades artísticas.',
        'date': '2023-10-05',
      },
    ],
    performanceData: {
      'Satisfação do Cliente': '80%',
      'Crescimento Anual': '9%',
    },
  ),
  CompanyModel(
    name: 'SmartHome Solutions SP',
    rating: 4.1,
    imageUrl: 'https://via.placeholder.com/150.png?text=SmartHome+Solutions+SP',
    address: 'Av. Brasil, 4000, São Paulo, SP',
    latitude: -23.5745,
    longitude: -46.6682,
    phoneNumber: '+55 11 91234-5678',
    workingHours: '9:00 AM - 9:00 PM',
    cnpj: '66.777.888/0001-33',
    registrationDate: '2019-02-14',
    about:
        'Integrating technology into your home for convenience and security.',
    accessibilityData: {
      'Entradas': [
        {'tipo': 'Rampa', 'status': true},
        {'tipo': 'Porta Automática', 'status': true},
      ],
      'Banheiros': [
        {'tipo': 'Acessível', 'status': true},
      ],
    },
    commentsData: [
      {
        'title': 'Tecnologia Avançada',
        'userName': 'Bruno Carvalho',
        'userImage': 'https://via.placeholder.com/50.png?text=Bruno',
        'text': 'Soluções inteligentes que realmente facilitam o dia a dia.',
        'date': '2023-08-08',
      },
    ],
    performanceData: {
      'Satisfação do Cliente': '93%',
      'Crescimento Anual': '19%',
    },
  ),
  CompanyModel(
    name: 'FashionHub SP',
    rating: 4.2,
    imageUrl: 'https://via.placeholder.com/150.png?text=FashionHub+SP',
    address: 'Rua Oscar Freire, 800, São Paulo, SP',
    latitude: -23.561414,
    longitude: -46.660797,
    phoneNumber: '+55 11 92345-6789',
    workingHours: '10:00 AM - 10:00 PM',
    cnpj: '55.666.777/0001-88',
    registrationDate: '2021-11-11',
    about: 'Trendy clothing and accessories for all ages.',
    accessibilityData: {
      'Entradas': [
        {'tipo': 'Elevador', 'status': true},
      ],
      'Banheiros': [
        {'tipo': 'Acessível', 'status': true},
      ],
    },
    commentsData: [
      {
        'title': 'Variedade Fantástica',
        'userName': 'Isabela Silva',
        'userImage': 'https://via.placeholder.com/50.png?text=Isabela',
        'text': 'Sempre encontro o que procuro com ótimas opções de estilo.',
        'date': '2023-07-05',
      },
    ],
    performanceData: {
      'Satisfação do Cliente': '84%',
      'Crescimento Anual': '11%',
    },
  ),
  CompanyModel(
    name: 'ByteWorks SP',
    rating: 4.7,
    imageUrl: 'https://via.placeholder.com/150.png?text=ByteWorks+SP',
    address: 'Av. Brigadeiro Faria Lima, 3500, São Paulo, SP',
    latitude: -23.5830,
    longitude: -46.6795,
    phoneNumber: '+55 11 93456-7890',
    workingHours: '8:00 AM - 8:00 PM',
    cnpj: '88.999.000/0001-77',
    registrationDate: '2018-08-20',
    about: 'Innovative software development and IT solutions.',
    accessibilityData: {
      'Entradas': [
        {'tipo': 'Rampa', 'status': true},
      ],
      'Banheiros': [
        {'tipo': 'Acessível', 'status': true},
      ],
    },
    commentsData: [
      {
        'title': 'Serviço de Qualidade',
        'userName': 'Fernando Lima',
        'userImage': 'https://via.placeholder.com/50.png?text=Fernando',
        'text': 'Projetos entregues dentro do prazo com excelente qualidade.',
        'date': '2023-06-22',
      },
    ],
    performanceData: {
      'Satisfação do Cliente': '89%',
      'Crescimento Anual': '17%',
    },
  ),
  CompanyModel(
    name: 'Garden Bliss SP',
    rating: 4.3,
    imageUrl: 'https://via.placeholder.com/150.png?text=Garden+Bliss+SP',
    address: 'Av. Paulista, 1500, São Paulo, SP',
    latitude: -23.561684,
    longitude: -46.655981,
    phoneNumber: '+55 11 94567-8901',
    workingHours: '9:00 AM - 7:00 PM',
    cnpj: '33.222.111/0001-66',
    registrationDate: '2017-03-08',
    about: 'Professional landscaping and gardening services.',
    accessibilityData: {
      'Entradas': [
        {'tipo': 'Porta Automática', 'status': true},
      ],
      'Banheiros': [
        {'tipo': 'Acessível', 'status': true},
      ],
    },
    commentsData: [
      {
        'title': 'Jardim Perfeito',
        'userName': 'Camila Torres',
        'userImage': 'https://via.placeholder.com/50.png?text=Camila',
        'text': 'Meu jardim nunca esteve tão bonito e bem cuidado!',
        'date': '2023-05-14',
      },
    ],
    performanceData: {
      'Satisfação do Cliente': '85%',
      'Crescimento Anual': '10%',
    },
  ),
  CompanyModel(
    name: 'SecureNet SP',
    rating: 4.8,
    imageUrl: 'https://via.placeholder.com/150.png?text=SecureNet+SP',
    address: 'Rua Faria Lima, 4000, São Paulo, SP',
    latitude: -23.5821,
    longitude: -46.6790,
    phoneNumber: '+55 11 95678-9012',
    workingHours: '24 Horas',
    cnpj: '00.111.222/0001-33',
    registrationDate: '2016-12-01',
    about: 'Comprehensive cybersecurity solutions for businesses.',
    accessibilityData: {
      'Entradas': [
        {'tipo': 'Elevador', 'status': true},
        {'tipo': 'Porta Automática', 'status': true},
      ],
      'Banheiros': [
        {'tipo': 'Acessível', 'status': true},
      ],
    },
    commentsData: [
      {
        'title': 'Segurança Garantida',
        'userName': 'Daniela Martins',
        'userImage': 'https://via.placeholder.com/50.png?text=Daniela',
        'text': 'Proporcionam tranquilidade com suas soluções de segurança.',
        'date': '2023-04-28',
      },
    ],
    performanceData: {
      'Satisfação do Cliente': '97%',
      'Crescimento Anual': '25%',
    },
  ),
  CompanyModel(
    name: 'BrightLights SP',
    rating: 4.1,
    imageUrl: 'https://via.placeholder.com/150.png?text=BrightLights+SP',
    address: 'Rua Augusta, 2200, São Paulo, SP',
    latitude: -23.561396,
    longitude: -46.660121,
    phoneNumber: '+55 11 96789-0123',
    workingHours: '8:00 AM - 10:00 PM',
    cnpj: '44.555.666/0001-22',
    registrationDate: '2015-03-18',
    about:
        'Innovative lighting solutions for residential and commercial spaces.',
    accessibilityData: {
      'Entradas': [
        {'tipo': 'Porta Automática', 'status': true},
      ],
      'Banheiros': [
        {'tipo': 'Acessível', 'status': true},
      ],
    },
    commentsData: [
      {
        'title': 'Iluminação Perfeita',
        'userName': 'Tatiana Rocha',
        'userImage': 'https://via.placeholder.com/50.png?text=Tatiana',
        'text': 'Transformaram meu espaço com luzes incríveis e eficientes.',
        'date': '2023-03-19',
      },
    ],
    performanceData: {
      'Satisfação do Cliente': '82%',
      'Crescimento Anual': '8%',
    },
  ),
  CompanyModel(
    name: 'PetCare Plus SP',
    rating: 4.5,
    imageUrl: 'https://via.placeholder.com/150.png?text=PetCare+Plus+SP',
    address: 'Av. Brigadeiro Faria Lima, 4500, São Paulo, SP',
    latitude: -23.5833,
    longitude: -46.6795,
    phoneNumber: '+55 11 97890-1234',
    workingHours: '7:00 AM - 9:00 PM',
    cnpj: '77.888.999/0001-00',
    registrationDate: '2020-10-10',
    about: 'Comprehensive pet care services including grooming and veterinary.',
    accessibilityData: {
      'Entradas': [
        {'tipo': 'Rampa', 'status': true},
      ],
      'Banheiros': [
        {'tipo': 'Acessível', 'status': true},
      ],
    },
    commentsData: [
      {
        'title': 'Cuidado Excelente',
        'userName': 'Marcelo Santos',
        'userImage': 'https://via.placeholder.com/50.png?text=Marcelo',
        'text': 'Meu cachorro adora os serviços oferecidos pela PetCare Plus.',
        'date': '2023-02-05',
      },
    ],
    performanceData: {
      'Satisfação do Cliente': '90%',
      'Crescimento Anual': '14%',
    },
  ),
  CompanyModel(
    name: 'BrightFuture Education SP',
    rating: 4.9,
    imageUrl:
        'https://via.placeholder.com/150.png?text=BrightFuture+Education+SP',
    address: 'Av. Paulista, 2500, São Paulo, SP',
    latitude: -23.5667,
    longitude: -46.6567,
    phoneNumber: '+55 11 90123-4567',
    workingHours: '24 Horas',
    cnpj: '55.666.777/0001-88',
    registrationDate: '2014-05-16',
    about: 'Innovative educational programs and tutoring services.',
    accessibilityData: {
      'Entradas': [
        {'tipo': 'Elevador', 'status': true},
        {'tipo': 'Rampa', 'status': true},
      ],
      'Banheiros': [
        {'tipo': 'Acessível', 'status': true},
      ],
    },
    commentsData: [
      {
        'title': 'Educação de Qualidade',
        'userName': 'Renata Ferreira',
        'userImage': 'https://via.placeholder.com/50.png?text=Renata',
        'text':
            'Programas educativos excelentes que realmente ajudam no aprendizado.',
        'date': '2023-01-12',
      },
    ],
    performanceData: {
      'Satisfação do Cliente': '98%',
      'Crescimento Anual': '30%',
    },
  ),
  CompanyModel(
    name: 'UrbanDesign Co. SP',
    rating: 4.0,
    imageUrl: 'https://via.placeholder.com/150.png?text=UrbanDesign+Co.+SP',
    address: 'Av. Rebouças, 5000, São Paulo, SP',
    latitude: -23.5871,
    longitude: -46.6680,
    phoneNumber: '+55 11 91234-5678',
    workingHours: '9:00 AM - 6:00 PM',
    cnpj: '66.777.888/0001-99',
    registrationDate: '2022-04-22',
    about: 'Innovative urban design and architectural solutions.',
    accessibilityData: {
      'Entradas': [
        {'tipo': 'Elevador', 'status': true},
        {'tipo': 'Rampa', 'status': true},
      ],
      'Banheiros': [
        {'tipo': 'Acessível', 'status': true},
      ],
    },
    commentsData: [
      {
        'title': 'Projetos Incríveis',
        'userName': 'Thiago Lima',
        'userImage': 'https://via.placeholder.com/50.png?text=Thiago',
        'text': 'Designs modernos e funcionais que transformaram a cidade.',
        'date': '2023-12-01',
      },
    ],
    performanceData: {
      'Satisfação do Cliente': '80%',
      'Crescimento Anual': '10%',
    },
  ),
  CompanyModel(
    name: 'MediCare Health SP',
    rating: 4.7,
    imageUrl: 'https://via.placeholder.com/150.png?text=MediCare+Health+SP',
    address: 'Av. Brigadeiro Faria Lima, 5500, São Paulo, SP',
    latitude: -23.5842,
    longitude: -46.6799,
    phoneNumber: '+55 11 95678-9012',
    workingHours: '24 Horas',
    cnpj: '33.444.555/0001-66',
    registrationDate: '2013-09-09',
    about: 'Comprehensive healthcare services and emergency care.',
    accessibilityData: {
      'Entradas': [
        {'tipo': 'Elevador', 'status': true},
        {'tipo': 'Porta Automática', 'status': true},
      ],
      'Banheiros': [
        {'tipo': 'Acessível', 'status': true},
      ],
    },
    commentsData: [
      {
        'title': 'Atendimento Rápido',
        'userName': 'Carla Souza',
        'userImage': 'https://via.placeholder.com/50.png?text=Carla',
        'text': 'Equipe médica eficiente e atenciosa.',
        'date': '2023-11-25',
      },
    ],
    performanceData: {
      'Satisfação do Cliente': '94%',
      'Crescimento Anual': '21%',
    },
  ),
  CompanyModel(
    name: 'BrightSkies Airlines SP',
    rating: 4.4,
    imageUrl:
        'https://via.placeholder.com/150.png?text=BrightSkies+Airlines+SP',
    address: 'Av. Paulista, 6000, São Paulo, SP',
    latitude: -23.5641,
    longitude: -46.6650,
    phoneNumber: '+55 11 97890-1234',
    workingHours: '24 Horas',
    cnpj: '44.555.666/0001-22',
    registrationDate: '2015-02-28',
    about: 'Reliable and comfortable air travel experiences.',
    accessibilityData: {
      'Entradas': [
        {'tipo': 'Porta Automática', 'status': true},
      ],
      'Banheiros': [
        {'tipo': 'Acessível', 'status': true},
      ],
    },
    commentsData: [
      {
        'title': 'Voos Confortáveis',
        'userName': 'Lucas Mendes',
        'userImage': 'https://via.placeholder.com/50.png?text=Lucas',
        'text': 'Ambiente agradável e serviço de bordo excelente.',
        'date': '2023-10-18',
      },
    ],
    performanceData: {
      'Satisfação do Cliente': '89%',
      'Crescimento Anual': '15%',
    },
  ),
  CompanyModel(
    name: 'BrightIdeas Consulting SP',
    rating: 4.5,
    imageUrl:
        'https://via.placeholder.com/150.png?text=BrightIdeas+Consulting+SP',
    address: 'Rua Augusta, 2500, São Paulo, SP',
    latitude: -23.5637,
    longitude: -46.6612,
    phoneNumber: '+55 11 98901-2345',
    workingHours: '24 Horas',
    cnpj: '55.666.777/0001-88',
    registrationDate: '2014-05-16',
    about: 'Business consulting services to drive your success.',
    accessibilityData: {
      'Entradas': [
        {'tipo': 'Elevador', 'status': true},
        {'tipo': 'Rampa', 'status': true},
      ],
      'Banheiros': [
        {'tipo': 'Acessível', 'status': true},
      ],
    },
    commentsData: [
      {
        'title': 'Consultoria Excelente',
        'userName': 'Patricia Lima',
        'userImage': 'https://via.placeholder.com/50.png?text=Patricia',
        'text': 'Ajuda valiosa para o crescimento do meu negócio.',
        'date': '2023-09-30',
      },
    ],
    performanceData: {
      'Satisfação do Cliente': '90%',
      'Crescimento Anual': '18%',
    },
  ),
  CompanyModel(
    name: 'SmartTech Innovations SP',
    rating: 4.3,
    imageUrl:
        'https://via.placeholder.com/150.png?text=SmartTech+Innovations+SP',
    address: 'Av. Brigadeiro Faria Lima, 6500, São Paulo, SP',
    latitude: -23.5850,
    longitude: -46.6802,
    phoneNumber: '+55 11 90012-3456',
    workingHours: '8:00 AM - 8:00 PM',
    cnpj: '66.777.888/0001-99',
    registrationDate: '2022-05-05',
    about: 'Advanced IT solutions and software development services.',
    accessibilityData: {
      'Entradas': [
        {'tipo': 'Porta Automática', 'status': true},
      ],
      'Banheiros': [
        {'tipo': 'Acessível', 'status': true},
      ],
    },
    commentsData: [
      {
        'title': 'Soluções Inovadoras',
        'userName': 'Mariana Costa',
        'userImage': 'https://via.placeholder.com/50.png?text=Mariana',
        'text': 'Tecnologias de ponta que melhoraram nossos processos.',
        'date': '2023-08-22',
      },
    ],
    performanceData: {
      'Satisfação do Cliente': '86%',
      'Crescimento Anual': '13%',
    },
  ),
];
