import 'package:flutter/material.dart';
import 'package:ui/common/sweet_alert.dart';

class SweetAlertDemo extends StatelessWidget {
  const SweetAlertDemo({Key? key}) : super(key: key);

  void _pop(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sweet Alert'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Success'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) {
                    return SweetAlert.success(
                      content: Text('A operação foi um sucesso.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            _pop(ctx);
                          },
                          child: Text('Ok'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text('Warning'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) {
                    return SweetAlert.warning(
                      title: Text('Cuidado'),
                      content: Text('A operação é perigosa.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            _pop(ctx);
                          },
                          child: Text('Não'),
                        ),
                        TextButton(
                          onPressed: () {
                            _pop(ctx);
                          },
                          child: Text('Sim'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text('Error'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) {
                    return SweetAlert.error(
                      title: Text('Ops!'),
                      content: UnconstrainedBox(child: Center(child: Text('A operação deu erro.'))),
                      actions: [
                        TextButton(
                          onPressed: () {
                            _pop(ctx);
                          },
                          child: Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            _pop(ctx);
                          },
                          child: Text('Tentar Novamente'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
