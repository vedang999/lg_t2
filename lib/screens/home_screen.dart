import 'package:flutter/material.dart';
import 'package:lg_connection/components/connection_flag.dart';
import 'package:lg_connection/connections/ssh.dart';
import 'package:lg_connection/components/ConfirmDialog.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late SSH ssh;
  bool _isLoading = false;
  bool connectionStatus = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  String _currentStatus = '';
  double _progress = 0.0;

  final List<Color> buttonColors = [
    Colors.purple,
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.teal,
    Colors.indigo,
    Colors.pink,
    Colors.cyan,
  ];

  @override
  void initState() {
    super.initState();
    ssh = SSH();
    _connectToLG();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _connectToLG() async {
    bool? result = await ssh.connectToLG();
    setState(() {
      connectionStatus = result!;
    });
  }

  void _updateProgress(String status, double progress) {
    setState(() {
      _currentStatus = status;
      _progress = progress;
    });
  }

  Future<void> _showConfirmDialog({
    required String title,
    required String message,
    required Future<void> Function() action,
  }) async {
    final dialog = ConfirmDialog(
      title: title,
      message: message,
      onCancel: () {
        Navigator.of(context).pop();
      },
      onConfirm: () async {
        Navigator.of(context).pop();
        setState(() => _isLoading = true);
        try {
          await action();
        } finally {
          if (mounted) {
            setState(() {
              _isLoading = false;
              _currentStatus = '';
              _progress = 0.0;
            });
          }
        }
      },
    );

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 150),
      pageBuilder: (context, _, __) => dialog,
    );
  }

  Future<void> _executeDirectAction(Future<void> Function() action) async {
    setState(() => _isLoading = true);
    try {
      await action();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _currentStatus = '';
          _progress = 0.0;
        });
      }
    }
  }

  Widget _buildProgressOverlay() {
    if (!_isLoading) return const SizedBox.shrink();
    return Container(
      color: Colors.black54,
      child: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  value: _progress >= 0 ? _progress : null,
                ),
                const SizedBox(height: 16),
                Text(
                  _currentStatus.isNotEmpty ? _currentStatus : 'Processing...',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required IconData icon,
    required Color color,
    required Future<void> Function() onPressed,
    String? dialogTitle,
    String? dialogMessage,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MouseRegion(
          onEnter: (_) => _controller.forward(),
          onExit: (_) => _controller.reverse(),
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color,
                    color.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: _isLoading
                      ? null
                      : () {
                    if (dialogTitle != null && dialogMessage != null) {
                      _showConfirmDialog(
                        title: dialogTitle,
                        message: dialogMessage,
                        action: onPressed,
                      );
                    } else {
                      _executeDirectAction(onPressed);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icon,
                          color: Colors.white,
                          size: 28,
                        ).animate()
                            .fadeIn(duration: 600.ms)
                            .scale(delay: 200.ms),
                        const SizedBox(height: 8),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ).animate()
                              .fadeIn(duration: 600.ms)
                              .slideY(begin: 0.2, delay: 200.ms),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: const Text(
          'Liquid Galaxy Control',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ).animate().fadeIn(duration: 600.ms).slideX(),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black87),
            onPressed: () async {
              await Navigator.pushNamed(context, '/settings');
              _connectToLG();
            },
          ).animate().fadeIn(duration: 600.ms),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: connectionStatus ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: connectionStatus ? Colors.green : Colors.red,
                      width: 1.5,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        connectionStatus ? Icons.wifi : Icons.wifi_off,
                        color: connectionStatus ? Colors.green : Colors.red,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        connectionStatus ? 'Connected' : 'Disconnected',
                        style: TextStyle(
                          color: connectionStatus ? Colors.green : Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ).animate()
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: -0.2, duration: 400.ms),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildButton(
                              text: 'Relaunch LG',
                              icon: Icons.replay,
                              color: buttonColors[0],
                              dialogTitle: 'Confirm Relaunch',
                              dialogMessage: 'Are you sure you want to relaunch the Liquid Galaxy system?',
                              onPressed: () async => await ssh.relaunchLG(),
                            ),
                            _buildButton(
                              text: 'Reboot LG',
                              icon: Icons.restart_alt,
                              color: buttonColors[1],
                              dialogTitle: 'Confirm Reboot',
                              dialogMessage: 'This will reboot all Liquid Galaxy systems. Are you sure?',
                              onPressed: () async => await ssh.rebootLG(),
                            ),
                            _buildButton(
                              text: 'Shutdown LG',
                              icon: Icons.power_settings_new,
                              color: buttonColors[2],
                              dialogTitle: 'Confirm Shutdown',
                              dialogMessage: 'This will completely shut down all Liquid Galaxy systems. Are you sure?',
                              onPressed: () async => await ssh.shutdownLG(),
                            ),
                            _buildButton(
                              text: 'Set Logo',
                              icon: Icons.image,
                              color: buttonColors[3],
                              onPressed: () async => await ssh.setLogos(),
                            ),
                            _buildButton(
                              text: 'Clear Logo',
                              icon: Icons.hide_image,
                              color: buttonColors[4],
                              onPressed: () async => await ssh.cleanLogos(),
                            ),
                            _buildButton(
                              text: 'Send KML 1',
                              icon: Icons.location_city,
                              color: buttonColors[5],
                              onPressed: () async => await ssh.sendMonumentsTour(
                                onProgress: _updateProgress,
                              ),
                            ),
                            _buildButton(
                              text: 'Send KML 2',
                              icon: Icons.landscape,
                              color: buttonColors[6],
                              onPressed: () async => await ssh.sendGreatWallKML(
                                onProgress: _updateProgress,
                              ),
                            ),
                            _buildButton(
                              text: 'Clear KML',
                              icon: Icons.clear_all,
                              color: buttonColors[7],
                              onPressed: () async => await ssh.cleanKML(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            'Made by Vedang.L for GSoC 2025 LG T2',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                            textAlign: TextAlign.center,
                          ).animate()
                              .fadeIn(duration: 600.ms)
                              .slideY(begin: 0.2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildProgressOverlay(),
        ],
      ),
    );
  }
}