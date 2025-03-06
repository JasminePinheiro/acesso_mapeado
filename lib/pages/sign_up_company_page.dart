import 'package:acesso_mapeado/controllers/sign_up_company_controller.dart';
import 'package:acesso_mapeado/shared/design_system.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class SignUpCompanyPage extends StatefulWidget {
  const SignUpCompanyPage({super.key});

  @override
  State<SignUpCompanyPage> createState() => _SignUpCompanyPageState();
}

class _SignUpCompanyPageState extends State<SignUpCompanyPage> {
  final _formKey = GlobalKey<FormState>();
  late SignUpCompanyController _controller;
  int _currentStep = 0;
  final Map<String, TimeOfDay> _openingTimes = {};
  final Map<String, TimeOfDay> _closingTimes = {};

  // Flag para rastrear a validade do CEP
  bool _isCEPValid = false;

  // Controllers para os campos do formulário
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cnpjController = MaskedTextController(mask: '00.000.000/0000-00');
  final _phoneController = MaskedTextController(mask: '(00) 00000-0000');
  final _addressController = TextEditingController();
  final _aboutController = TextEditingController();
  final _cepController = MaskedTextController(mask: '00000-000');
  final _numberController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _workingHoursController = TextEditingController();
  final _instagramUrlController = TextEditingController();
  final _facebookUrlController = TextEditingController();
  final _twitterUrlController = TextEditingController();
  final _youtubeUrlController = TextEditingController();
  final _tiktokUrlController = TextEditingController();
  final _pinterestUrlController = TextEditingController();
  final _linkedinUrlController = TextEditingController();
  final _websiteUrlController = TextEditingController();

  // Controladores de tempo para cada dia da semana
  final Map<String, TextEditingController> _openingTimeControllers = {
    'Segunda-feira': TextEditingController(),
    'Terça-feira': TextEditingController(),
    'Quarta-feira': TextEditingController(),
    'Quinta-feira': TextEditingController(),
    'Sexta-feira': TextEditingController(),
    'Sábado': TextEditingController(),
    'Domingo': TextEditingController(),
  };

  final Map<String, TextEditingController> _closingTimeControllers = {
    'Segunda-feira': TextEditingController(),
    'Terça-feira': TextEditingController(),
    'Quarta-feira': TextEditingController(),
    'Quinta-feira': TextEditingController(),
    'Sexta-feira': TextEditingController(),
    'Sábado': TextEditingController(),
    'Domingo': TextEditingController(),
  };

  // Dados de acessibilidade como estado da página
  final Map<String, List<Map<String, dynamic>>> accessibilityData = {
    "Acessibilidade Física": [
      {"tipo": "Rampas", "status": false},
      {"tipo": "Elevadores", "status": false},
      {"tipo": "Portas Largas", "status": false},
      {"tipo": "Banheiros Adaptados", "status": false},
      {"tipo": "Pisos Táteis e Superfícies Anti-derrapantes", "status": false},
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

  Future<Map<String, dynamic>> getAddressData(String cep) async {
    final response = await Dio().get('https://viacep.com.br/ws/$cep/json/');
    return response.data;
  }

  @override
  void initState() {
    super.initState();
    _controller = SignUpCompanyController(
      formKey: _formKey,
      nameController: _nameController,
      emailController: _emailController,
      cnpjController: _cnpjController,
      phoneController: _phoneController,
      addressController: _addressController,
      numberController: _numberController,
      neighborhoodController: _neighborhoodController,
      cityController: _cityController,
      stateController: _stateController,
      zipCodeController: _cepController,
      aboutController: _aboutController,
      workingHoursController: _workingHoursController,
      instagramUrlController: _instagramUrlController,
      facebookUrlController: _facebookUrlController,
      twitterUrlController: _twitterUrlController,
      youtubeUrlController: _youtubeUrlController,
      tiktokUrlController: _tiktokUrlController,
      pinterestUrlController: _pinterestUrlController,
      linkedinUrlController: _linkedinUrlController,
      websiteUrlController: _websiteUrlController,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _cnpjController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _aboutController.dispose();
    _cepController.dispose();
    _numberController.dispose();
    _neighborhoodController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _workingHoursController.dispose();
    _instagramUrlController.dispose();
    _facebookUrlController.dispose();
    _twitterUrlController.dispose();
    _youtubeUrlController.dispose();
    _tiktokUrlController.dispose();
    _pinterestUrlController.dispose();
    _linkedinUrlController.dispose();
    _websiteUrlController.dispose();
    for (var controller in _openingTimeControllers.values) {
      controller.dispose();
    }
    for (var controller in _closingTimeControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onStepContinue() {
    if (_formKey.currentState!.validate()) {
      bool isValid = true;
      for (String day in _openingTimeControllers.keys) {
        String opening = _openingTimeControllers[day]!.text;
        String closing = _closingTimeControllers[day]!.text;
        if ((opening.isNotEmpty && closing.isEmpty) ||
            (opening.isEmpty && closing.isNotEmpty)) {
          isValid = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Por favor, complete os horários de $day')),
          );
          break;
        }
      }

      if (isValid) {
        if (_currentStep < 2) {
          setState(() {
            _currentStep++;
          });
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, corrija os erros antes de continuar')),
      );
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Future<void> _selectTime(
      BuildContext context, String day, bool isOpening) async {
    final TimeOfDay initialTime = isOpening
        ? (_openingTimes[day] ?? const TimeOfDay(hour: 9, minute: 0))
        : (_closingTimes[day] ?? const TimeOfDay(hour: 18, minute: 0));

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      setState(() {
        if (isOpening) {
          _openingTimes[day] = picked;
          _openingTimeControllers[day]!.text = picked.format(context);
        } else {
          _closingTimes[day] = picked;
          _closingTimeControllers[day]!.text = picked.format(context);
        }
      });
    }
  }

  void _clearWorkingHours() {
    setState(() {
      _openingTimes.clear();
      _closingTimes.clear();
      _openingTimeControllers.forEach((key, controller) {
        controller.clear();
      });
      _closingTimeControllers.forEach((key, controller) {
        controller.clear();
      });
    });
  }

  Widget _buildStepIndicator(int stepIndex, String stepName) {
    return Column(
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: _currentStep == stepIndex
              ? Theme.of(context).colorScheme.primary
              : AppColors.lightGray.withOpacity(0.3),
          child: Text(
            (stepIndex + 1).toString(),
            style: TextStyle(
              color:
                  _currentStep == stepIndex ? AppColors.white : AppColors.black,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          stepName,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine() {
    return Container(
      width: 40,
      height: 2,
      color: AppColors.lightGray,
    );
  }

  // Método para converter os horários de funcionamento para o formato necessário
  Map<String, Map<String, String>> _getWorkingHoursData() {
    Map<String, Map<String, String>> data = {};
    for (String day in _openingTimeControllers.keys) {
      String open = _openingTimeControllers[day]!.text;
      String close = _closingTimeControllers[day]!.text;

      if (open.isNotEmpty || close.isNotEmpty) {
        data[day] = {
          'open': open.isNotEmpty ? open : 'Fechado',
          'close': close.isNotEmpty ? close : 'Fechado',
        };
      }
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.darkGray.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              )
            ],
          ),
        ),
        leading: IconButton(
          icon: Image.asset('assets/icons/arrow-left.png'),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStepIndicator(0, 'Dados Empresariais'),
                  _buildStepLine(),
                  _buildStepIndicator(1, 'Endereço'),
                  _buildStepLine(),
                  _buildStepIndicator(2, 'Acessibilidade'),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'Cadastre-se',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ListView(
                  children: [
                    if (_currentStep == 0) _buildStepCompanyDetails(),
                    if (_currentStep == 1) _buildStepAddress(),
                    if (_currentStep == 2) _buildStepAccessibility(),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentStep > 0)
                          ElevatedButton(
                            onPressed: _onStepCancel,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              'Voltar',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: AppTypography.large,
                              ),
                            ),
                          ),
                        const Spacer(),
                        if (_currentStep == 2)
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Coleta os dados de horários de funcionamento
                                Map<String, Map<String, String>>
                                    workingHoursData = _getWorkingHoursData();

                                _controller.signUp(
                                  context,
                                  accessibilityData,
                                  '${_addressController.text}, ${_numberController.text} ${_cityController.text} - ${_stateController.text}',
                                  workingHoursData, // Passa os dados de horários
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Por favor, corrija os erros antes de concluir o cadastro')),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
                            child: const Text(
                              'Concluir',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: AppTypography.large,
                              ),
                            ),
                          )
                        else
                          ElevatedButton(
                            onPressed: _onStepContinue,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
                            child: Text(
                              'Próximo',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: AppTypography.large,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepCompanyDetails() {
    return Column(
      children: [
        const SizedBox(height: 10),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Nome fantasia',
            border: OutlineInputBorder(),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Por favor, insira o nome fantasia';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _cnpjController,
          decoration: const InputDecoration(
            labelText: 'CNPJ',
            border: OutlineInputBorder(),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira o CNPJ';
            }
            if (!_controller.isValidCNPJ(value)) {
              return 'CNPJ inválido';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(
            labelText: 'Telefone',
            border: OutlineInputBorder(),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          ),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira o telefone';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'E-mail da empresa',
            border: OutlineInputBorder(),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira o e-mail';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'E-mail inválido';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _aboutController,
          decoration: const InputDecoration(
            labelText: 'Sobre a empresa',
            border: OutlineInputBorder(),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          ),
          maxLines: 3,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Por favor, insira uma descrição da empresa';
            }
            return null;
          },
        ),
        _buildWorkingHours(),
      ],
    );
  }

  Widget _buildWorkingHours() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Horário de Funcionamento',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        ..._openingTimeControllers.keys.map((day) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(day, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectTime(context, day, true),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _openingTimeControllers[day],
                          decoration: const InputDecoration(
                            labelText: 'Abertura',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            hintText: 'Opcional',
                          ),
                          validator: (value) {
                            String dayClosing =
                                _closingTimeControllers[day]!.text;
                            if (value != null &&
                                value.isNotEmpty &&
                                dayClosing.isEmpty) {
                              return 'Selecione o horário \n de fechamento';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectTime(context, day, false),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _closingTimeControllers[day],
                          decoration: const InputDecoration(
                            labelText: 'Fechamento',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            hintText: 'Opcional',
                          ),
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              String dayOpening =
                                  _openingTimeControllers[day]!.text;
                              if (dayOpening.isEmpty) {
                                return 'Selecione o horário \n de abertura primeiro';
                              }

                              // Converter os horários para minutos
                              TimeOfDay? opening = _openingTimes[day];
                              TimeOfDay? closing = _closingTimes[day];

                              if (opening != null && closing != null) {
                                final openingMinutes =
                                    opening.hour * 60 + opening.minute;
                                final closingMinutes =
                                    closing.hour * 60 + closing.minute;
                                if (closingMinutes <= openingMinutes) {
                                  return 'Fechamento deve \n ser após a abertura';
                                }
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          );
        }),
        const SizedBox(height: 10),
        Center(
          child: ElevatedButton(
            onPressed: _clearWorkingHours,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white,
              side: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              'Limpar Horários',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: AppTypography.small,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepAddress() {
    return Column(
      children: [
        const SizedBox(height: 10),
        TextFormField(
          controller: _cepController,
          decoration: const InputDecoration(
            labelText: 'CEP',
            border: OutlineInputBorder(),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira o CEP';
            }
            if (!_isCEPValid) {
              return 'CEP inválido';
            }
            return null;
          },
          onChanged: (value) async {
            if (value.length == 9) {
              // Formato '00000-000'
              try {
                Map<String, dynamic> addressData =
                    await getAddressData(value.replaceAll('-', ''));
                if (addressData.containsKey('erro') &&
                    addressData['erro'] == true) {
                  setState(() {
                    _isCEPValid = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('CEP não encontrado')),
                  );
                } else {
                  setState(() {
                    _isCEPValid = true;
                    _addressController.text = addressData['logradouro'] ?? '';
                    _neighborhoodController.text = addressData['bairro'] ?? '';
                    _cityController.text = addressData['localidade'] ?? '';
                    _stateController.text = addressData['uf'] ?? '';
                  });
                }
              } catch (e) {
                setState(() {
                  _isCEPValid = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('Erro ao buscar o endereço. Verifique o CEP.')),
                );
              }
            } else {
              setState(() {
                _isCEPValid = false;
              });
            }
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(
            labelText: 'Endereço',
            border: OutlineInputBorder(),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira o endereço';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _numberController,
          decoration: const InputDecoration(
            labelText: 'Número',
            border: OutlineInputBorder(),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira o número';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _neighborhoodController,
          decoration: const InputDecoration(
            labelText: 'Bairro',
            border: OutlineInputBorder(),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira o bairro';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _cityController,
          decoration: const InputDecoration(
            labelText: 'Cidade',
            border: OutlineInputBorder(),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira a cidade';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _stateController,
          decoration: const InputDecoration(
            labelText: 'Estado',
            border: OutlineInputBorder(),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira o estado';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildStepAccessibility() {
    return Column(
      children: [
        const Text(
          "Marque as acessibilidades da sua empresa",
          style: TextStyle(
            color: AppColors.black,
            fontSize: AppTypography.large,
          ),
        ),
        const SizedBox(height: 20),
        ...accessibilityData.entries.map((entry) {
          String category = entry.key;
          List<Map<String, dynamic>> items = entry.value;
          return ExpansionTile(
            title: Text(
              category,
              style: const TextStyle(
                color: AppColors.black,
                fontSize: AppTypography.medium,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: items.map((item) {
              return CheckboxListTile(
                title: Text(
                  item["tipo"],
                  style: const TextStyle(color: AppColors.darkGray),
                ),
                value: item["status"],
                onChanged: (bool? value) {
                  setState(() {
                    item["status"] = value ?? false;
                  });
                },
                activeColor: Theme.of(context).colorScheme.primary,
                checkColor: Theme.of(context).colorScheme.onPrimary,
              );
            }).toList(),
          );
        }),
      ],
    );
  }
}
