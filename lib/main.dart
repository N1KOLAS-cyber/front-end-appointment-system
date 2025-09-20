import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Función para guardar cita demo en la colección 'DocApp'
  Future<void> _guardarCitaDemo(BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('DocApp').add(
        {
          'paciente': 'Frick Estrella',
          'motivo': 'Revision general',
          'fecha': '2025-09-30',
          'creadoEn': FieldValue.serverTimestamp(),
        }
      );
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cita guardada en DocApp'),
            backgroundColor: Colors.purple,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Función para guardar múltiples citas de prueba
  Future<void> _guardarCitasPrueba(BuildContext context) async {
    try {
      // Lista de 11 pacientes de prueba
      final List<Map<String, String>> pacientes = [
        {
          'paciente': 'Erick Estrella', 
          'sintoma': 'Dolor de cabeza', 
          'fecha': '2025-09-20'
        },
        {
          'paciente': 'María González', 
          'sintoma': 'Fiebre y escalofríos', 
          'fecha': '2025-09-21'
        },
        {
          'paciente': 'Carlos Rodríguez', 
          'sintoma': 'Dolor abdominal', 
          'fecha': '2025-09-22'
        },
        {
          'paciente': 'Laura Martínez', 
          'sintoma': 'Consulta prenatal', 
          'fecha': '2025-09-23'
        },
        {
          'paciente': 'Jorge López', 
          'sintoma': 'Presión arterial alta', 
          'fecha': '2025-09-24'
        },
        {
          'paciente': 'Ana Sánchez', 
          'sintoma': 'Control diabetes', 
          'fecha': '2025-09-25'
        },
        {
          'paciente': 'Miguel Díaz', 
          'sintoma': 'Dolor articular', 
          'fecha': '2025-09-26'
        },
        {
          'paciente': 'Sofía Ramírez', 
          'sintoma': 'Alergia estacional', 
          'fecha': '2025-09-27'
        },
        {
          'paciente': 'David Torres', 
          'sintoma': 'Lesión deportiva', 
          'fecha': '2025-09-28'
        },
        {
          'paciente': 'Elena Castro', 
          'sintoma': 'Chequeo anual', 
          'fecha': '2025-09-29'
        },
        {
          'paciente': 'Pedro Vargas', 
          'sintoma': 'Problemas respiratorios', 
          'fecha': '2025-09-30'
        },
      ];

      // Guardar cada paciente en Firestore
      for (var paciente in pacientes) {
        await FirebaseFirestore.instance.collection('citas_prueba').add({
          'paciente': paciente['paciente'],
          'sintoma': paciente['sintoma'],
          'fecha': paciente['fecha'],
          'creadoEn': FieldValue.serverTimestamp(),
        });
      }
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('11 citas de prueba guardadas en citas_prueba'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Función para eliminar una cita individual
  Future<void> _eliminarCitaIndividual(BuildContext context, String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('citas_prueba')
          .doc(docId)
          .delete();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cita eliminada'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al eliminar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Función para eliminar todas las citas
  Future<void> _eliminarTodasLasCitas(BuildContext context) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('citas_prueba')
          .get();
      
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Todas las citas han sido eliminadas'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al eliminar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistema de Citas Médicas', 
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.purple[700],
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Botón para guardar cita demo - MORADO
            ElevatedButton.icon(
              onPressed: () => _guardarCitaDemo(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
              icon: const Icon(Icons.calendar_today, size: 24),
              label: const Text(
                'Guardar Cita Demo',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            
            // Botón para guardar 11 citas de prueba - AZUL
            ElevatedButton.icon(
              onPressed: () => _guardarCitasPrueba(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
              icon: const Icon(Icons.group_add, size: 24),
              label: const Text(
                'Guardar 11 Citas de Prueba',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            
            // Botón para eliminar todas las citas - ROJO
            ElevatedButton.icon(
              onPressed: () => _eliminarTodasLasCitas(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
              icon: const Icon(Icons.delete_forever, size: 24),
              label: const Text(
                'Eliminar Todas las Citas',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 32),
            
            // Título para la sección de lecturas
            const Text(
              'Citas Almacenadas:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 16),
            
            // Lectura de datos de Firestore
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('citas_prueba')
                    .orderBy('creadoEn', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.purple),
                    );
                  }
                  
                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_today, size: 50, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('No hay citas guardadas aún.', 
                              style: TextStyle(fontSize: 16)),
                          Text('Presiona el botón para agregar 11 citas de prueba.',
                              style: TextStyle(fontSize: 14, color: Colors.grey)),
                        ],
                      ),
                    );
                  }
                  
                  return ListView(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 3,
                        color: Colors.grey[50],
                        child: ListTile(
                          leading: const Icon(Icons.person, color: Colors.purple),
                          title: Text(
                            data['paciente'] ?? 'Sin nombre',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Síntoma: ${data['sintoma'] ?? 'No especificado'}',
                                  style: const TextStyle(fontSize: 14)),
                              Text('Fecha: ${data['fecha'] ?? 'No especificada'}',
                                  style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _eliminarCitaIndividual(context, document.id),
                            tooltip: 'Eliminar esta cita',
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      
      // Mensaje de confirmación de Firebase
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 20),
            SizedBox(width: 8),
            Text(
              "Firebase inicializado correctamente",
              style: TextStyle(color: Colors.green, fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }
}