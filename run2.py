import re

file_path = r'k:\hack2skill_deepfake\flutter-client\lib\screens\dashboard_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    code = f.read()

# Fix table header style
code = code.replace(
    '''const headerStyle = TextStyle(
      color: Color(0xFF71717A),
      fontSize: 10,
      letterSpacing: 1.5,
      fontWeight: FontWeight.w600,
    );''',
    '''final headerStyle = GoogleFonts.outfit(
      color: _kZinc500,
      fontSize: 11,
      letterSpacing: 1.0,
      fontWeight: FontWeight.w600,
    );'''
)

# Fix Analysis log title font
code = code.replace(
    '''Text('Analysis Log',
                        style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                            fontSize: 13)),''',
    '''Text('ANALYSIS LOG',
                        style: GoogleFonts.syne(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2.0,
                            fontSize: 14)),'''
)

# Fix System Throughput title
code = code.replace(
    '''Text(
          'System Throughput',
          style: GoogleFonts.outfit(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
        ),''',
    '''Text(
          'System Throughput',
          style: GoogleFonts.syne(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
        ),'''
)

# Fix Threat Distribution title
code = code.replace(
    '''Text(
          'Threat Distribution',
          style: GoogleFonts.outfit(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
        ),''',
    '''Text(
          'Threat Distribution',
          style: GoogleFonts.syne(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
        ),'''
)

# Fix ThreatLevel score
code = code.replace(
    '''Text(
                      scan.threatScore.toStringAsFixed(1),
                      style: GoogleFonts.outfit(
                          color: threat.color,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),''',
    '''Text(
                      scan.threatScore.toStringAsFixed(1),
                      style: GoogleFonts.syne(
                          color: threat.color,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),'''
)

# Fix _threatScore in UploadZone
code = code.replace(
    '''Text(
                _threatScore.toStringAsFixed(1),
                style: GoogleFonts.outfit(
                    color: threat.color,
                    fontSize: 28,
                    fontWeight: FontWeight.w300),
              ),''',
    '''Text(
                _threatScore.toStringAsFixed(1),
                style: GoogleFonts.syne(
                    color: threat.color,
                    fontSize: 32,
                    fontWeight: FontWeight.w300),
              ),'''
)


with open(file_path, 'w', encoding='utf-8') as f:
    f.write(code)
print('Done!')
