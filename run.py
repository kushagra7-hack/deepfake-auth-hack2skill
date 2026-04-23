import re

file_path = r'k:\hack2skill_deepfake\flutter-client\lib\screens\dashboard_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    code = f.read()

# Replace Colors
code = re.sub(
    r'const _kBg = Color\(0xFF030303\);\s*const _kSurface = Color\(0xFF0A0A0A\);\s*const _kBorder = Color\(0x1AFFFFFF\);',
    'const _kBg = Color(0xFF000000);\nconst _kSurface = Color(0x05FFFFFF);\nconst _kBorder = Color(0x0DFFFFFF);\nconst _kZinc400 = Color(0xFFA1A1AA);\nconst _kZinc500 = Color(0xFF71717A);',
    code
)

# Fix Header Title Font
code = code.replace(
    '''style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    letterSpacing: 1.5,
                  )''',
    '''style: GoogleFonts.syne(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    letterSpacing: 1.5,
                  )'''
)

# Fix Stat Cards Layout
new_stat_card = '''Widget _buildStatCard(_StatCardData c) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kBorder),
        boxShadow: const [
          BoxShadow(color: Color(0x05FFFFFF), blurRadius: 20, spreadRadius: 0, offset: Offset(0, 0)),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -8,
            right: -8,
            child: Icon(c.icon, color: c.color.withAlpha(25), size: 48),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                c.label.toUpperCase(),
                style: GoogleFonts.outfit(
                  color: _kZinc400,
                  fontSize: 12,
                  letterSpacing: 0.6,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    c.value,
                    style: GoogleFonts.syne(
                        color: c.color == Colors.white ? Colors.white : c.color, 
                        fontSize: 36, 
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.5,
                    ),
                  ),
                  if (c.suffix != null)
                    Text(c.suffix!,
                        style: GoogleFonts.syne(
                            color: _kZinc500, fontSize: 18)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }'''

code = re.sub(r'Widget _buildStatCard\(_StatCardData c\).*?\n  \}', new_stat_card, code, flags=re.DOTALL)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(code)
print('Done!')
