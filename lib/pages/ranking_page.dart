import 'package:acesso_mapeado/shared/logger.dart';
import 'package:flutter/material.dart';
import 'package:acesso_mapeado/shared/design_system.dart';
import 'package:acesso_mapeado/models/company_model.dart';
import 'package:acesso_mapeado/controllers/company_controller.dart';
import 'package:acesso_mapeado/widgets/accessibility_sheet.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  final CompanyController _companyController = CompanyController();
  List<CompanyModel> rankedCompanies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRankedCompanies();
  }

  Future<void> _fetchRankedCompanies() async {
    try {
      rankedCompanies = await _companyController.getAllCompaniesOrderByRating();
    } catch (e) {
      // Log error and handle the case where fetching fails
      Logger.logInfo('Error fetching ranked companies: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showAccessibilitySheet(CompanyModel companyModel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return AccessibilitySheet(companyModel: companyModel);
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildEmptyMessage() {
    return const Center(
      child: Text(
        'Nenhuma empresa encontrada.',
        style: TextStyle(fontSize: 18, color: AppColors.darkGray),
      ),
    );
  }

  Widget _buildCompanyCard(CompanyModel company, int index) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: company.imageUrl != null
              ? NetworkImage(company.imageUrl!)
              : const AssetImage('assets/images/placeholder-company.png')
                  as ImageProvider,
          radius: 29,
        ),
        title: Text('${index + 1}. ${company.name}'),
        subtitle: Row(
          children: List.generate(5, (starIndex) {
            return Icon(
              Icons.star,
              color: starIndex < (company.rating ?? 0)
                  ? Colors.yellow
                  : Colors.grey,
              size: 20,
            );
          }),
        ),
        trailing: _buildInfoButton(),
        onTap: () {
          _showAccessibilitySheet(company);
        },
      ),
    );
  }

  Widget _buildInfoButton() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightPurple),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.info,
              color: AppColors.lightPurple,
            ),
            SizedBox(width: 5),
            Text(
              'Saiba mais',
              style: TextStyle(color: AppColors.lightPurple),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: _isLoading
          ? _buildLoadingIndicator()
          : rankedCompanies.isEmpty
              ? _buildEmptyMessage()
              : ListView.builder(
                  itemCount: rankedCompanies.length,
                  itemBuilder: (context, index) {
                    final company = rankedCompanies[index];
                    return _buildCompanyCard(company, index);
                  },
                ),
    );
  }
}
