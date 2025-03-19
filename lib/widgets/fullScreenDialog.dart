import 'package:flutter/material.dart';

class Fullscreendialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Select a plan'),
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.close),
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //   ),
          // ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPlanOption('Plano básico', 'R\$ 9,90/mês', context),
                SizedBox(height: 16),
                _buildPlanOption('Plano Premium', 'R\$ 19,99/mês', context),
                SizedBox(height: 16),
                _buildPlanOption('Plano Empresarial', 'R\$ 49,99/mês', context),
                SizedBox(height: 24),
                TextButton(
                  onPressed: () {
                    // Navegar para a tela de registro
                  },
                  child: Text('Ainda não tem uma conta? Registre-se'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanOption(String title, String price, BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        print('selected Plan $title');
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(price, style: TextStyle(fontSize: 16, color: Colors.green)),
        ],
      ),
    );
  }
}
