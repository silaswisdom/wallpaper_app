import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String quality = 'High (Best Quality)';
  bool notifications = true;
  bool autoRotate = false;
  bool lockWallpaper = false;
  bool syncAcross = false;

  final Color accent = const Color(0xFFFD8C4E);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Settings',
            style: TextStyle(fontSize: 60, fontWeight: FontWeight.w500, color: accent)),
        const SizedBox(height: 8),
        Text('Customize your Wallpaper Studio experience',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w400)),
        const SizedBox(height: 16),
        Expanded(
          child: Card(
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Row(children: [
                Expanded(
                  flex: 3,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Wallpaper Setup',
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24)),
                        SizedBox(height: 8),
                        Text('Configure your wallpaper settings and enable auto-rotation',
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),),
                    const SizedBox(height: 26),
                    Text('Image Quality',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                    SizedBox(height: 16),
                    InputDecorator(
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: quality,
                          items: const [
                            DropdownMenuItem(
                                value: 'High (Best Quality)',
                                child: Text('High (Best Quality)')),
                            DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                            DropdownMenuItem(
                                value: 'Low (Smaller)', child: Text('Low (Smaller)')),
                          ],
                          onChanged: (v) => setState(() => quality = v ?? quality),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('Notification',
                                    style:
                                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                SizedBox(height: 6),
                                Text('Get notified about new wallpapers and updates',
                                    style: TextStyle(fontSize: 13, color: Colors.grey)),
                              ]),
                        ),
                        Transform.scale(
                          scale: 1.05,
                          child: Switch(
                            activeColor: Colors.white,
                            activeTrackColor: accent,
                            value: notifications,
                            onChanged: (v) => setState(() => notifications = v),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).maybePop();
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Settings saved')));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFBB03B),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            elevation: 0,
                          ),
                          child: const Text('Save Settings'),
                        ),
                      ),
                    ]),
                  ]),
                ),
                 const SizedBox(width: 28),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Container(
                      width: 260,
                      height: 480,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade300),
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [
                          Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.link, color: Colors.grey),
                              Text('Connected to device', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),)
                            ],
                          ),
                          SizedBox(height: 11),
                          Text('click to download', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ]),
    );
  }
}