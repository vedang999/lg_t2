// TODO 2 done: Import 'dartssh2' package
import 'package:dartssh2/dartssh2.dart';
import 'package:lg_connection/entities/kml/screen_overlay_entity.dart';
import 'package:lg_connection/entities/kml/kml_entity.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';

class KMLContent {
  static const String monumentsKML = r'''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2">
  <Document>
    <name>World Monuments Tour</name>
    
    <!-- Information Overlays -->
    <ScreenOverlay id="info-taj">
      <name>Taj Mahal Info</name>
      <visibility>0</visibility>
      <overlayXY x="0.02" y="0.98" xunits="fraction" yunits="fraction"/>
      <screenXY x="0.02" y="0.98" xunits="fraction" yunits="fraction"/>
      <rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>
      <size x="0.4" y="0.25" xunits="fraction" yunits="fraction"/>
      <description><![CDATA[
        <div style="color: white; font-family: Arial; font-size: 18px; background-color: rgba(0,0,0,0.85); padding: 20px; border-radius: 10px;">
          <h2 style="color: #ffaa00; margin: 0 0 10px 0;">Taj Mahal</h2>
          • Built between 1632-1653<br/>
          • Commissioned by Mughal Emperor Shah Jahan<br/>
          • UNESCO World Heritage Site<br/>
          • Example of Mughal architecture
        </div>
      ]]></description>
    </ScreenOverlay>

    <ScreenOverlay id="info-pyramids">
      <name>Pyramids Info</name>
      <visibility>0</visibility>
      <overlayXY x="0.02" y="0.98" xunits="fraction" yunits="fraction"/>
      <screenXY x="0.02" y="0.98" xunits="fraction" yunits="fraction"/>
      <rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>
      <size x="0.4" y="0.25" xunits="fraction" yunits="fraction"/>
      <description><![CDATA[
        <div style="color: white; font-family: Arial; font-size: 18px; background-color: rgba(0,0,0,0.85); padding: 20px; border-radius: 10px;">
          <h2 style="color: #ffaa00; margin: 0 0 10px 0;">Pyramids of Giza</h2>
          • Built around 2560 BC<br/>
          • Oldest of the Seven Wonders<br/>
          • Great Pyramid height: 146.5 meters<br/>
          • Complex includes three pyramids
        </div>
      ]]></description>
    </ScreenOverlay>

    <ScreenOverlay id="info-colosseum">
      <name>Colosseum Info</name>
      <visibility>0</visibility>
      <overlayXY x="0.02" y="0.98" xunits="fraction" yunits="fraction"/>
      <screenXY x="0.02" y="0.98" xunits="fraction" yunits="fraction"/>
      <rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>
      <size x="0.4" y="0.25" xunits="fraction" yunits="fraction"/>
      <description><![CDATA[
        <div style="color: white; font-family: Arial; font-size: 18px; background-color: rgba(0,0,0,0.85); padding: 20px; border-radius: 10px;">
          <h2 style="color: #ffaa00; margin: 0 0 10px 0;">Colosseum</h2>
          • Built 70-80 AD<br/>
          • Largest ancient amphitheater<br/>
          • Could hold 50,000-80,000 spectators<br/>
          • Symbol of Imperial Rome
        </div>
      ]]></description>
    </ScreenOverlay>

    <gx:Tour>
      <name>Monuments Tour</name>
      <gx:Playlist>
        <!-- Initial view -->
        <gx:FlyTo>
          <gx:duration>3</gx:duration>
          <gx:flyToMode>smooth</gx:flyToMode>
          <LookAt>
            <longitude>30</longitude>
            <latitude>30</latitude>
            <altitude>0</altitude>
            <heading>0</heading>
            <tilt>0</tilt>
            <range>12000000</range>
            <altitudeMode>relativeToGround</altitudeMode>
          </LookAt>
        </gx:FlyTo>

        <!-- Taj Mahal -->
        <gx:FlyTo>
          <gx:duration>3</gx:duration>
          <gx:flyToMode>smooth</gx:flyToMode>
          <LookAt>
            <longitude>78.0422</longitude>
            <latitude>27.1751</latitude>
            <altitude>0</altitude>
            <heading>0</heading>
            <tilt>60</tilt>
            <range>1000</range>
            <altitudeMode>relativeToGround</altitudeMode>
          </LookAt>
        </gx:FlyTo>
        
        <gx:Wait>
          <gx:duration>5</gx:duration>
        </gx:Wait>

        <!-- Pyramids of Giza -->
        <gx:FlyTo>
          <gx:duration>3</gx:duration>
          <gx:flyToMode>smooth</gx:flyToMode>
          <LookAt>
            <longitude>31.1342</longitude>
            <latitude>29.9792</latitude>
            <altitude>0</altitude>
            <heading>0</heading>
            <tilt>60</tilt>
            <range>2000</range>
            <altitudeMode>relativeToGround</altitudeMode>
          </LookAt>
        </gx:FlyTo>

        <gx:Wait>
          <gx:duration>5</gx:duration>
        </gx:Wait>

        <!-- Colosseum -->
        <gx:FlyTo>
          <gx:duration>3</gx:duration>
          <gx:flyToMode>smooth</gx:flyToMode>
          <LookAt>
            <longitude>12.4922</longitude>
            <latitude>41.8902</latitude>
            <altitude>0</altitude>
            <heading>0</heading>
            <tilt>60</tilt>
            <range>1000</range>
            <altitudeMode>relativeToGround</altitudeMode>
          </LookAt>
        </gx:FlyTo>

        <gx:Wait>
          <gx:duration>5</gx:duration>
        </gx:Wait>
      </gx:Playlist>
    </gx:Tour>
  </Document>
</kml>''';

  static const String greatWallKML = r'''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
  <Document>
    <name>Great Wall of China</name>
    
    <Style id="wallStyle">
      <LineStyle>
        <color>ff0000ff</color>
        <width>6</width>
      </LineStyle>
      <PolyStyle>
        <color>7f0000ff</color>
      </PolyStyle>
    </Style>

    <Placemark>
      <name>Great Wall - Mutianyu Section</name>
      <description>Famous restored section of the Great Wall</description>
      <styleUrl>#wallStyle</styleUrl>
      <MultiGeometry>
        <LineString>
          <extrude>1</extrude>
          <tessellate>1</tessellate>
          <altitudeMode>relativeToGround</altitudeMode>
          <coordinates>
            116.5563,40.4311,200
            116.5593,40.4321,200
            116.5623,40.4331,200
            116.5653,40.4341,200
            116.5683,40.4351,200
            116.5713,40.4361,200
          </coordinates>
        </LineString>
      </MultiGeometry>
    </Placemark>

    <Placemark>
      <name>Great Wall - Badaling Section</name>
      <description>Most visited section of the Great Wall</description>
      <styleUrl>#wallStyle</styleUrl>
      <MultiGeometry>
        <LineString>
          <extrude>1</extrude>
          <tessellate>1</tessellate>
          <altitudeMode>relativeToGround</altitudeMode>
          <coordinates>
            116.0161,40.3439,200
            116.0191,40.3449,200
            116.0221,40.3459,200
            116.0251,40.3469,200
            116.0281,40.3479,200
            116.0311,40.3489,200
          </coordinates>
        </LineString>
      </MultiGeometry>
    </Placemark>

    <LookAt>
      <longitude>116.5623</longitude>
      <latitude>40.4331</latitude>
      <altitude>0</altitude>
      <heading>45</heading>
      <tilt>60</tilt>
      <range>3000</range>
      <altitudeMode>relativeToGround</altitudeMode>
    </LookAt>
  </Document>
</kml>''';

}

typedef ProgressCallback = void Function(String status, double progress);

class SSH {
  late String _host;
  late String _port;
  late String _username;
  late String _passwordOrKey;
  late String _numberOfRigs;
  SSHClient? _client;
  bool _isConnected = false;

  int get leftScreen {
    final rigs = int.tryParse(_numberOfRigs);
    if (rigs == null || rigs <= 0) {
      return 1;
    }
    if (rigs == 1) {
      return 1;
    }
    return (rigs / 2).floor() + 2;
  }

  Future<void> initConnectionDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _host = prefs.getString('ipAddress') ?? 'default_host';
    _port = prefs.getString('sshPort') ?? '22';
    _username = prefs.getString('username') ?? 'lg';
    _passwordOrKey = prefs.getString('password') ?? 'lg';
    _numberOfRigs = prefs.getString('numberOfRigs') ?? '3';
  }

  Future<bool?> connectToLG() async {
    await initConnectionDetails();
    if (_isConnected) {
      return true;
    }
    try {
      // TODO 3 done: Connect to Liquid Galaxy system
      final socket = await SSHSocket.connect(_host, int.parse(_port));
      _client = SSHClient(
        socket,
        username: _username,
        onPasswordRequest: () => _passwordOrKey,
      );
      print('IP: $_host, port: $_port');
      _isConnected = true;
      return true;
    } on SocketException catch (e) {
      print('Failed to connect: $e');
      _isConnected = false;
      return false;
    }
  }

  Future<SSHSession?> execute() async {
    try {
      if (_client == null) {
        print('SSH client is not initialized.');
        return null;
      }
      // TODO 4 done: Execute a demo command
      final execResult = await _client!.execute('echo "search=Spain" > /tmp/query.txt');
      return execResult;
    } catch (e) {
      print('An error occurred while executing the command: $e');
      return null;
    }
  }

  // TODO 11: Make functions for each of the tasks in the home screen
  Future<void> relaunchLG() async {
    try {
      await initConnectionDetails();
      final password = _passwordOrKey;
      final user = _username;
      final rigs = int.parse(_numberOfRigs);

      for (var i = rigs; i >= 1; i--) {
        final relaunchCommand = """RELAUNCH_CMD="\\
if [ -f /etc/init/lxdm.conf ]; then
  export SERVICE=lxdm
elif [ -f /etc/init/lightdm.conf ]; then
  export SERVICE=lightdm
else
  exit 1
fi
if  [[ \\\$(service \\\$SERVICE status) =~ 'stop' ]]; then
  echo $password | sudo -S service \\\${SERVICE} start
else
  echo $password | sudo -S service \\\${SERVICE} restart
fi
" && sshpass -p $password ssh -x -t lg@lg$i "\$RELAUNCH_CMD\"""";

        try {
          await _client!.execute('"/home/$user/bin/lg-relaunch" > /home/$user/log.txt');
          await _client!.execute(relaunchCommand);
          print('Relaunched Liquid Galaxy on rig $i');
        } catch (e) {
          print('Failed to relaunch rig $i: $e');
        }
      }
    } catch (e) {
      print('Error in relaunchLG(): $e');
    }
  }

  Future<void> shutdownLG() async {
    try {
      await initConnectionDetails();
      final password = _passwordOrKey;
      final rigs = int.parse(_numberOfRigs);

      for (var i = rigs; i >= 1; i--) {
        try {
          await _client!.execute(
              'sshpass -p $password ssh -t lg$i "echo $password | sudo -S poweroff"'
          );
          print('Shut down rig $i successfully.');
        } catch (e) {
          print('Failed to shut down rig $i: $e');
        }
      }
    } catch (e) {
      print('Error in shutdownLG(): $e');
    }
  }

  Future<void> rebootLG() async {
    try {
      await initConnectionDetails();
      final password = _passwordOrKey;
      final rigs = int.parse(_numberOfRigs);

      for (var i = rigs; i >= 1; i--) {
        try {
          await _client!.execute(
              'sshpass -p $password ssh -t lg$i "echo $password | sudo -S reboot"'
          );
          print('Rebooted rig $i successfully.');
        } catch (e) {
          print('Failed to reboot rig $i: $e');
        }
      }
    } catch (e) {
      print('Error in rebootLG(): $e');
    }
  }

  Future<void> setRefresh() async {
    try {
      await initConnectionDetails();
      final password = _passwordOrKey;
      const search = '<href>##LG_PHPIFACE##kml\\/slave_{{slave}}.kml<\\/href>';
      const replace =
          '<href>##LG_PHPIFACE##kml\\/slave/{{slave}}.kml<\\/href><refreshMode>onInterval<\\/refreshMode><refreshInterval>2<\\/refreshInterval>';

      final command =
          'echo $password | sudo -S sed -i "s/$search/$replace/" ~/earth/kml/slave/myplaces.kml';
      final clear =
          'echo $password | sudo -S sed -i "s/$replace/$search/" ~/earth/kml/slave/myplaces.kml';

      for (var i = 2; i <= int.parse(_numberOfRigs); i++) {
        final clearCmd = clear.replaceAll('{{slave}}', i.toString());
        final cmd = command.replaceAll('{{slave}}', i.toString());

        if (_client == null) {
          print("SSHClient is not initialized.");
          return;
        }

        try {
          await _client!.execute(clearCmd);
          await _client!.execute(cmd);
          print('Set refresh for slave $i successfully.');
        } catch (e) {
          print('Failed to set refresh for slave $i: $e');
        }
      }

      await rebootLG();
    } catch (e) {
      print('Error in setRefresh(): $e');
    }
  }

  Future<void> cleanLogos() async {
    if (!_isConnected) {
      print('Not connected. Attempting to reconnect...');
      final connected = await connectToLG();
      if (!connected!) {
        print('Failed to reconnect to Liquid Galaxy.');
        return;
      }
      print('Reconnected successfully.');
    }
    String logoKML = '''<?xml version="1.0" encoding="UTF-8"?>
  <kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
    <Document id="logo">
    </Document>
  </kml>''';

    try {
      print('Attempting to clear logo on screen $leftScreen...');
      await _client!.execute("echo '$logoKML' > /var/www/html/kml/slave_$leftScreen.kml");
      print('Logo cleared successfully on screen $leftScreen');
    } catch (e) {
      print('Could not clear logo: $e');
      return Future.error(e);
    }
  }

  Future<void> setLogos({
    String name = 'SVT-logos',
    String content = '<name>Logos</name>',
  }) async {
    final screenOverlay = ScreenOverlayEntity.logos();
    final kml = KMLEntity(
      name: name,
      content: content,
      screenOverlay: screenOverlay.tag,
    );

    try {
      await sendKMLToSlave(leftScreen, kml.body);
      print('Logo set successfully on screen $leftScreen');
    } catch (e) {
      print('Error setting logo: $e');
    }
  }

  Future<void> sendMonumentsTour({ProgressCallback? onProgress}) async {
    try {
      if (_client == null) {
        onProgress?.call('Error: SSH client not initialized', 0);
        return;
      }

      onProgress?.call('Preparing monuments tour...', 0.1);
      await _client?.run('mkdir -p /var/www/html/kmls');

      onProgress?.call('Uploading tour file...', 0.3);
      final sftp = await _client?.sftp();
      final sftpFile = await sftp?.open('/var/www/html/kmls/monuments_tour.kml',
          mode: SftpFileOpenMode.create | SftpFileOpenMode.write);

      final kmlStream = Stream.fromIterable(
          [Uint8List.fromList(utf8.encode(KMLContent.monumentsKML))]
      );
      await sftpFile?.write(kmlStream);
      await sftpFile?.close();

      onProgress?.call('Starting tour...', 0.5);
      await _client?.run('echo "http://lg1:81/kmls/monuments_tour.kml" > /var/www/html/kmls.txt');
      await Future.delayed(const Duration(seconds: 2));
      await _client?.run('echo "playtour=Monuments Tour" > /tmp/query.txt');

      onProgress?.call('Visiting Taj Mahal...', 0.6);
      await Future.delayed(const Duration(seconds: 8));

      onProgress?.call('Visiting Pyramids...', 0.7);
      await Future.delayed(const Duration(seconds: 8));

      onProgress?.call('Visiting Colosseum...', 0.8);
      await Future.delayed(const Duration(seconds: 8));

      onProgress?.call('Completing tour...', 0.9);
      await Future.delayed(const Duration(seconds: 2));

      onProgress?.call('Tour completed successfully', 1.0);
    } catch (e) {
      onProgress?.call('Error during tour: $e', -1);
      try {
        await stopTour();
        await _client?.run('rm /var/www/html/kmls/monuments_tour.kml');
        await _client?.run('echo "" > /var/www/html/kmls.txt');
      } catch (cleanupError) {
        print('Failed to cleanup after error: $cleanupError');
      }
    }
  }

  Future<void> sendGreatWallKML({ProgressCallback? onProgress}) async {
    try {
      if (_client == null) {
        onProgress?.call('Error: SSH client not initialized', 0);
        return;
      }

      onProgress?.call('Preparing Great Wall visualization...', 0.2);
      print('Creating directory...');
      await _client?.run('mkdir -p /var/www/html/kmls');

      onProgress?.call('Loading visualization...', 0.5);
      print('Creating KML file...');

      // First clear any existing KML
      await _client?.run('echo "" > /var/www/html/kmls.txt');
      await Future.delayed(const Duration(seconds: 1));

      // Write the KML content directly
      print('Writing KML content...');
      await _client?.run('''echo '${KMLContent.greatWallKML}' > /var/www/html/kmls/great_wall.kml''');
      await Future.delayed(const Duration(seconds: 1));

      print('Setting up visualization...');
      // Set the view to look at the Great Wall
      await _client?.run('echo "flytoview=<LookAt><longitude>116.5623</longitude><latitude>40.4331</latitude><altitude>0</altitude><heading>45</heading><tilt>60</tilt><range>3000</range><altitudeMode>relativeToGround</altitudeMode></LookAt>" > /tmp/query.txt');
      await Future.delayed(const Duration(seconds: 2));

      print('Loading KML...');
      // Load the KML file
      await _client?.run('echo "http://lg1:81/kmls/great_wall.kml" > /var/www/html/kmls.txt');

      onProgress?.call('Visualization complete', 1.0);
      print('Great Wall KML loaded successfully');

    } catch (e) {
      print('Error in sendGreatWallKML: $e');
      onProgress?.call('Error: $e', -1);
      try {
        await _client?.run('rm /var/www/html/kmls/great_wall.kml');
        await _client?.run('echo "" > /var/www/html/kmls.txt');
      } catch (cleanupError) {
        print('Failed to cleanup after error: $cleanupError');
      }
    }
  }

  Future<void> cleanKML() async {
    try {
      if (_client == null) {
        print('SSH client is not initialized.');
        return;
      }

      // Clear the query file
      await _client?.run('echo "" > /tmp/query.txt');

      // Clear the kmls.txt file
      await _client?.run('echo "" > /var/www/html/kmls.txt');

      // Remove any KML files in the kmls directory
      await _client?.run('rm -f /var/www/html/kmls/*.kml');

      print('Successfully cleared all KML files');
    } catch (e) {
      print('Failed to clean KML: $e');
    }
  }

  Future<void> stopTour() async {
    try {
      if (_client == null) return;
      await _client?.run('echo "exittour=true" > /tmp/query.txt');
    } catch (e) {
      print('Failed to stop tour: $e');
    }
  }

  Future<void> sendKMLToSlave(int screen, String content) async {
    try {
      await _client!.execute("echo '$content' > /var/www/html/kml/slave_$screen.kml");
    } catch (e) {
      print(e);
    }
  }
}