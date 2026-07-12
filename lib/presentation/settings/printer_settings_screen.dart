import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import '../../../services/providers/printer_provider.dart';

class PrinterSettingsScreen extends ConsumerStatefulWidget {
  const PrinterSettingsScreen({super.key});

  @override
  ConsumerState<PrinterSettingsScreen> createState() => _PrinterSettingsScreenState();
}

class _PrinterSettingsScreenState extends ConsumerState<PrinterSettingsScreen> {
  List<BluetoothInfo> _devices = [];
  bool _isScanning = false;
  String? _connectedMac;
  bool _isConnecting = false;

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndScan();
  }

  Future<void> _checkPermissionsAndScan() async {
    setState(() => _isScanning = true);
    try {
      final bool permissionGranted = await PrintBluetoothThermal.isPermissionBluetoothGranted;
      if (!permissionGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Izin Bluetooth diperlukan untuk mencari printer.')),
          );
        }
        setState(() => _isScanning = false);
        return;
      }
      
      final bool bluetoothEnabled = await PrintBluetoothThermal.bluetoothEnabled;
      if (!bluetoothEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tolong nyalakan Bluetooth terlebih dahulu.')),
          );
        }
        setState(() => _isScanning = false);
        return;
      }

      final devices = await PrintBluetoothThermal.pairedBluetooths;
      setState(() {
        _devices = devices;
      });
      
      final bool isConnected = await PrintBluetoothThermal.connectionStatus;
      if (isConnected) {
        // If already connected to something, ideally we check our provider.
        final savedMac = ref.read(selectedPrinterProvider);
        if (savedMac != null) {
          setState(() {
            _connectedMac = savedMac;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mencari perangkat: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  Future<void> _connectToPrinter(BluetoothInfo device) async {
    setState(() => _isConnecting = true);
    try {
      final bool isConnected = await PrintBluetoothThermal.connectionStatus;
      if (isConnected) {
        await PrintBluetoothThermal.disconnect;
      }
      
      final bool result = await PrintBluetoothThermal.connect(macPrinterAddress: device.macAdress);
      if (result) {
        setState(() => _connectedMac = device.macAdress);
        ref.read(selectedPrinterProvider.notifier).setPrinter(device.macAdress);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Terhubung ke ${device.name}'), backgroundColor: Colors.green),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal terhubung ke printer.'), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isConnecting = false);
    }
  }

  Future<void> _disconnectPrinter() async {
    setState(() => _isConnecting = true);
    try {
      await PrintBluetoothThermal.disconnect;
      setState(() => _connectedMac = null);
      ref.read(selectedPrinterProvider.notifier).setPrinter(null);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Printer terputus.'), backgroundColor: Colors.grey),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memutus koneksi: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isConnecting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Printer Bluetooth', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 20, letterSpacing: -0.5)),
        centerTitle: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFD72323), Color(0xFF1A1A1A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isScanning || _isConnecting ? null : _checkPermissionsAndScan,
          ),
        ],
      ),
      body: _isScanning
          ? const Center(child: CircularProgressIndicator())
          : _devices.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.bluetooth_disabled, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text('Tidak ada perangkat terpasang (paired) ditemukan.'),
                      TextButton(
                        onPressed: _checkPermissionsAndScan,
                        child: const Text('Cari Ulang'),
                      )
                    ],
                  ),
                )
              : ListView.separated(
                  itemCount: _devices.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final device = _devices[index];
                    final isConnected = _connectedMac == device.macAdress;

                    return ListTile(
                      leading: Icon(
                        Icons.print,
                        color: isConnected ? Colors.green : Colors.grey,
                      ),
                      title: Text(device.name.isEmpty ? 'Unknown Device' : device.name),
                      subtitle: Text(device.macAdress),
                      trailing: isConnected
                          ? OutlinedButton(
                              onPressed: _isConnecting ? null : _disconnectPrinter,
                              style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                              child: const Text('Putuskan'),
                            )
                          : ElevatedButton(
                              onPressed: _isConnecting ? null : () => _connectToPrinter(device),
                              child: const Text('Hubungkan'),
                            ),
                    );
                  },
                ),
    );
  }
}
