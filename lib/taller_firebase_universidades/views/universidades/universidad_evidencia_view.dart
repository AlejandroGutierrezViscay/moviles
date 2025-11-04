import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/universidad.dart';
import '../../services/universidad_service.dart';
import '../../widgets/custom_drawer.dart';

class UniversidadEvidenciaView extends StatelessWidget {
  const UniversidadEvidenciaView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Evidencia - Universidades Firebase'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Forzar recarga (el StreamBuilder se actualiza automáticamente)
            },
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: StreamBuilder<List<Universidad>>(
        stream: UniversidadService.watchUniversidades(),
        builder: (context, snapshot) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header con información
                _buildInfoHeader(colorScheme),
                const SizedBox(height: 24),
                
                // Estado de conexión
                _buildConnectionStatus(snapshot, colorScheme),
                const SizedBox(height: 24),
                
                // Datos en tiempo real
                _buildRealTimeData(snapshot, colorScheme),
                const SizedBox(height: 24),
                
                // Botón para ir al listado
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => context.push('/universidades'),
                    icon: const Icon(Icons.list),
                    label: const Text('Ver Listado Completo'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoHeader(ColorScheme colorScheme) {
    return Card(
      elevation: 0,
      color: colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.science,
                  color: colorScheme.onPrimaryContainer,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Vista de Evidencia Firebase',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Esta vista muestra datos en tiempo real desde la colección "universidades" en Cloud Firestore.',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onPrimaryContainer.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Los datos se sincronizan automáticamente cuando hay cambios en la base de datos.',
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onPrimaryContainer.withOpacity(0.7),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionStatus(AsyncSnapshot<List<Universidad>> snapshot, ColorScheme colorScheme) {
    Color statusColor;
    IconData statusIcon;
    String statusText;
    String statusDetail;

    if (snapshot.connectionState == ConnectionState.waiting) {
      statusColor = colorScheme.secondary;
      statusIcon = Icons.sync;
      statusText = 'Conectando...';
      statusDetail = 'Estableciendo conexión con Firebase';
    } else if (snapshot.hasError) {
      statusColor = colorScheme.error;
      statusIcon = Icons.error_outline;
      statusText = 'Error de conexión';
      statusDetail = snapshot.error.toString();
    } else {
      statusColor = Colors.green;
      statusIcon = Icons.cloud_done;
      statusText = 'Conectado a Firebase';
      statusDetail = 'Stream activo desde Firestore';
    }

    return Card(
      elevation: 0,
      color: statusColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: statusColor.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(statusIcon, color: statusColor, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    statusText,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    statusDetail,
                    style: TextStyle(
                      color: statusColor.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              DateTime.now().toString().substring(11, 19),
              style: TextStyle(
                color: statusColor.withOpacity(0.7),
                fontSize: 11,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRealTimeData(AsyncSnapshot<List<Universidad>> snapshot, ColorScheme colorScheme) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Cargando datos desde Firebase...',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (snapshot.hasError) {
      return Card(
        color: colorScheme.errorContainer,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(Icons.error_outline, color: colorScheme.error, size: 48),
              const SizedBox(height: 16),
              Text(
                'Error al cargar datos',
                style: TextStyle(
                  color: colorScheme.error,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                snapshot.error.toString(),
                style: TextStyle(color: colorScheme.onErrorContainer),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final universidades = snapshot.data ?? [];

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLowest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.dataset, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Datos en Tiempo Real',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${universidades.length} registros',
                    style: TextStyle(
                      color: colorScheme.onSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            if (universidades.isEmpty)
              _buildEmptyState(colorScheme)
            else
              ...universidades.asMap().entries.map((entry) {
                final index = entry.key;
                final universidad = entry.value;
                return _buildUniversidadEvidencia(universidad, index, colorScheme);
              }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            Icons.school_outlined,
            size: 48,
            color: colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No hay universidades registradas',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'La colección está vacía. Ve al listado para agregar universidades.',
            style: TextStyle(
              color: colorScheme.onSurfaceVariant.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildUniversidadEvidencia(Universidad universidad, int index, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(8),
        color: colorScheme.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      universidad.nombre,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'NIT: ${universidad.nit}',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildDataField('ID Firestore', universidad.id, colorScheme),
          _buildDataField('Dirección', universidad.direccion, colorScheme),
          _buildDataField('Teléfono', universidad.telefono, colorScheme),
          _buildDataField('Página Web', universidad.paginaWeb, colorScheme, isUrl: true),
        ],
      ),
    );
  }

  Widget _buildDataField(String label, String value, ColorScheme colorScheme, {bool isUrl = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 11,
                color: colorScheme.onSurfaceVariant.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'No especificado' : value,
              style: TextStyle(
                fontSize: 11,
                color: value.isEmpty 
                    ? colorScheme.onSurfaceVariant.withOpacity(0.5)
                    : (isUrl ? colorScheme.primary : colorScheme.onSurfaceVariant),
                fontStyle: value.isEmpty ? FontStyle.italic : FontStyle.normal,
                decoration: isUrl && value.isNotEmpty ? TextDecoration.underline : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}