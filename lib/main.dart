import 'package:flutter/material.dart';

void main() {
  runApp(const CyberSecurityApp());
}

// ============================================================
// MODEL
// ============================================================

class SecurityIncident {
  String id;
  String title;
  String category;
  String severity;
  String status;
  String affectedSystem;
  String description;
  String assignedTo;
  String createdDate;
  String notes;
  String responseAction;

  SecurityIncident({
    required this.id,
    required this.title,
    required this.category,
    required this.severity,
    required this.status,
    required this.affectedSystem,
    required this.description,
    required this.assignedTo,
    required this.createdDate,
    required this.notes,
    required this.responseAction,
  });
}

// ============================================================
// APP
// ============================================================

class CyberSecurityApp extends StatefulWidget {
  const CyberSecurityApp({super.key});

  @override
  State<CyberSecurityApp> createState() => _CyberSecurityAppState();
}

class _CyberSecurityAppState extends State<CyberSecurityApp> {
  ThemeMode themeMode = ThemeMode.dark;

  void changeTheme(bool dark) {
    setState(() {
      themeMode = dark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CyberGuard SOC',
      themeMode: themeMode,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF4F7FB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF080D18),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF22C55E),
          brightness: Brightness.dark,
        ),
      ),
      home: SecurityDashboard(
        isDark: themeMode == ThemeMode.dark,
        onThemeChanged: changeTheme,
      ),
    );
  }
}

// ============================================================
// DASHBOARD
// ============================================================

class SecurityDashboard extends StatefulWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  const SecurityDashboard({
    super.key,
    required this.isDark,
    required this.onThemeChanged,
  });

  @override
  State<SecurityDashboard> createState() => _SecurityDashboardState();
}

class _SecurityDashboardState extends State<SecurityDashboard> {
  int selectedPage = 0;

  final List<SecurityIncident> incidents = [];

  final TextEditingController searchController = TextEditingController();

  String searchText = '';
  String severityFilter = 'All';
  String statusFilter = 'All';
  String categoryFilter = 'All';

  Color get primary => widget.isDark
      ? const Color(0xFF22C55E)
      : const Color(0xFF2563EB);

  Color get background => widget.isDark
      ? const Color(0xFF080D18)
      : const Color(0xFFF4F7FB);

  Color get cardColor => widget.isDark
      ? const Color(0xFF111827)
      : Colors.white;

  Color get cardColor2 => widget.isDark
      ? const Color(0xFF172033)
      : const Color(0xFFF8FAFC);

  Color get textColor => widget.isDark
      ? Colors.white
      : const Color(0xFF0F172A);

  Color get mutedColor => widget.isDark
      ? const Color(0xFF94A3B8)
      : const Color(0xFF64748B);

  int get totalIncidents => incidents.length;

  int get openIncidents =>
      incidents.where((i) => i.status == 'Open').length;

  int get investigatingIncidents =>
      incidents.where((i) => i.status == 'Investigating').length;

  int get resolvedIncidents =>
      incidents.where((i) => i.status == 'Resolved').length;

  int get criticalIncidents =>
      incidents.where((i) => i.severity == 'Critical').length;

  int get highIncidents =>
      incidents.where((i) => i.severity == 'High').length;

  int get mediumIncidents =>
      incidents.where((i) => i.severity == 'Medium').length;

  int get lowIncidents =>
      incidents.where((i) => i.severity == 'Low').length;

  List<SecurityIncident> get filteredIncidents {
    return incidents.where((incident) {
      final query = searchText.toLowerCase();

      final matchesSearch =
          query.isEmpty ||
              incident.id.toLowerCase().contains(query) ||
              incident.title.toLowerCase().contains(query) ||
              incident.category.toLowerCase().contains(query) ||
              incident.affectedSystem.toLowerCase().contains(query) ||
              incident.assignedTo.toLowerCase().contains(query);

      final matchesSeverity =
          severityFilter == 'All' ||
              incident.severity == severityFilter;

      final matchesStatus =
          statusFilter == 'All' ||
              incident.status == statusFilter;

      final matchesCategory =
          categoryFilter == 'All' ||
              incident.category == categoryFilter;

      return matchesSearch &&
          matchesSeverity &&
          matchesStatus &&
          matchesCategory;
    }).toList();
  }

  List<String> get categories {
    final values = incidents.map((e) => e.category).toSet().toList();
    values.sort();
    return values;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 900) {
          return _mobileLayout();
        }

        return Scaffold(
          backgroundColor: background,
          body: Row(
            children: [
              _sidebar(),
              Expanded(
                child: _desktopContent(),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // SIDEBAR
  // ============================================================

  Widget _sidebar() {
    return Container(
      width: 245,
      decoration: BoxDecoration(
        color: widget.isDark
            ? const Color(0xFF0C1422)
            : Colors.white,
        border: Border(
          right: BorderSide(
            color: widget.isDark
                ? Colors.white.withOpacity(.06)
                : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 24, 18, 28),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: primary.withOpacity(.12),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      Icons.shield_rounded,
                      color: primary,
                      size: 25,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CyberGuard',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Security Operations',
                          style: TextStyle(
                            color: mutedColor,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _navItem(
                      Icons.dashboard_rounded,
                      'Dashboard',
                      0,
                    ),
                    _navItem(
                      Icons.warning_amber_rounded,
                      'Incidents',
                      1,
                    ),
                    _navItem(
                      Icons.analytics_rounded,
                      'Analytics',
                      2,
                    ),
                    _navItem(
                      Icons.assignment_rounded,
                      'Reports',
                      3,
                    ),
                    _navItem(
                      Icons.settings_rounded,
                      'Settings',
                      4,
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(18),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: primary.withOpacity(.08),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: primary.withOpacity(.12),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: incidents.isEmpty
                            ? Colors.grey
                            : Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        incidents.isEmpty
                            ? 'Monitoring Ready'
                            : 'System Monitoring',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem(
      IconData icon,
      String title,
      int index,
      ) {
    final selected = selectedPage == index;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 4,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() {
            selectedPage = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
          decoration: BoxDecoration(
            color: selected
                ? primary.withOpacity(.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: selected ? primary : mutedColor,
              ),
              const SizedBox(width: 13),
              Text(
                title,
                style: TextStyle(
                  color: selected ? primary : mutedColor,
                  fontSize: 13,
                  fontWeight: selected
                      ? FontWeight.w700
                      : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DESKTOP
  // ============================================================

  Widget _desktopContent() {
    return SafeArea(
      child: Column(
        children: [
          _topBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                28,
                10,
                28,
                30,
              ),
              child: _pageContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBar() {
    return Container(
      height: 82,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: BoxDecoration(
        color: background,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  _pageTitle(),
                  style: TextStyle(
                    color: textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Security Operations Center',
                  style: TextStyle(
                    color: mutedColor,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            width: 280,
            height: 42,
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              style: TextStyle(
                color: textColor,
                fontSize: 13,
              ),
              decoration: InputDecoration(
                hintText: 'Search incidents...',
                hintStyle: TextStyle(
                  color: mutedColor,
                  fontSize: 12,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: 19,
                  color: mutedColor,
                ),
                filled: true,
                fillColor: cardColor,
                contentPadding:
                const EdgeInsets.symmetric(
                  vertical: 0,
                ),
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          IconButton(
            tooltip: 'Notifications',
            onPressed: () {
              _showMessage(
                incidents.isEmpty
                    ? 'No security alerts available.'
                    : '${incidents.length} incident record(s) available.',
              );
            },
            icon: Icon(
              Icons.notifications_none_rounded,
              color: mutedColor,
            ),
          ),

          const SizedBox(width: 5),

          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: primary.withOpacity(.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.admin_panel_settings_rounded,
              color: primary,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  String _pageTitle() {
    switch (selectedPage) {
      case 1:
        return 'Security Incidents';
      case 2:
        return 'Security Analytics';
      case 3:
        return 'Security Reports';
      case 4:
        return 'System Settings';
      default:
        return 'Security Dashboard';
    }
  }

  // ============================================================
  // PAGE CONTENT
  // ============================================================

  Widget _pageContent() {
    switch (selectedPage) {
      case 1:
        return _incidentsPage();
      case 2:
        return _analyticsPage();
      case 3:
        return _reportsPage();
      case 4:
        return _settingsPage();
      default:
        return _dashboardPage();
    }
  }

  // ============================================================
  // DASHBOARD
  // ============================================================

  Widget _dashboardPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _hero(),
        const SizedBox(height: 22),

        _sectionHeader(
          'Security Overview',
          'Real-time incident monitoring',
        ),

        const SizedBox(height: 14),

        LayoutBuilder(
          builder: (context, constraints) {
            final count =
            constraints.maxWidth > 1100 ? 4 : 2;

            return GridView.count(
              crossAxisCount: count,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              shrinkWrap: true,
              physics:
              const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.0,
              children: [
                _statCard(
                  'Total Incidents',
                  totalIncidents,
                  Icons.security_rounded,
                  primary,
                ),
                _statCard(
                  'Open Incidents',
                  openIncidents,
                  Icons.lock_open_rounded,
                  Colors.orange,
                ),
                _statCard(
                  'Investigating',
                  investigatingIncidents,
                  Icons.search_rounded,
                  Colors.purple,
                ),
                _statCard(
                  'Critical Threats',
                  criticalIncidents,
                  Icons.gpp_bad_rounded,
                  Colors.red,
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 22),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: _panel(
                title: 'Threat Severity',
                subtitle: 'Incident distribution by severity',
                child: SizedBox(
                  height: 270,
                  child: incidents.isEmpty
                      ? _emptyChart(
                    'Add incidents to view severity analytics.',
                  )
                      : _severityChart(),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: _panel(
                title: 'Incident Status',
                subtitle: 'Current response status',
                child: SizedBox(
                  height: 270,
                  child: incidents.isEmpty
                      ? _emptyChart(
                    'Status analytics will appear here.',
                  )
                      : _statusChart(),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 22),

        _panel(
          title: 'Recent Incidents',
          subtitle: 'Latest security events',
          action: TextButton.icon(
            onPressed: () {
              setState(() {
                selectedPage = 1;
              });
            },
            icon: const Icon(Icons.arrow_forward, size: 16),
            label: const Text('View all'),
          ),
          child: incidents.isEmpty
              ? _emptyState(
            Icons.shield_outlined,
            'No incidents yet',
            'Add your first security incident to start monitoring.',
          )
              : Column(
            children: incidents
                .reversed
                .take(5)
                .map(
                  (incident) =>
                  _incidentRow(incident),
            )
                .toList(),
          ),
        ),

        const SizedBox(height: 22),

        _quickActions(),
      ],
    );
  }

  Widget _hero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: widget.isDark
              ? [
            const Color(0xFF10233A),
            const Color(0xFF0C1728),
          ]
              : [
            const Color(0xFFEAF4FF),
            Colors.white,
          ],
        ),
        border: Border.all(
          color: primary.withOpacity(.12),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(.12),
                        borderRadius:
                        BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.circle,
                            size: 7,
                            color: primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'SECURITY OPERATIONS',
                            style: TextStyle(
                              color: primary,
                              fontSize: 9,
                              fontWeight:
                              FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Stay Ahead of\\nSecurity Threats',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 28,
                    height: 1.12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Monitor incidents, analyze threats and manage your security response from one central workspace.',
                  style: TextStyle(
                    color: mutedColor,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 18),
                ElevatedButton.icon(
                  onPressed: _openAddIncident,
                  icon: const Icon(
                    Icons.add_rounded,
                    size: 18,
                  ),
                  label: const Text(
                    'Report Incident',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: primary.withOpacity(.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shield_rounded,
              size: 90,
              color: primary.withOpacity(.75),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STAT CARD
  // ============================================================

  Widget _statCard(
      String title,
      int value,
      IconData icon,
      Color accent,
      ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: widget.isDark
              ? Colors.white.withOpacity(.05)
              : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: accent.withOpacity(.11),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: accent,
              size: 23,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: mutedColor,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$value',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INCIDENTS PAGE
  // ============================================================

  Widget _incidentsPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          'Incident Management',
          'Track and respond to security events',
          action: ElevatedButton.icon(
            onPressed: _openAddIncident,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('New Incident'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding:
              const EdgeInsets.symmetric(
                horizontal: 17,
                vertical: 13,
              ),
            ),
          ),
        ),

        const SizedBox(height: 18),

        _filterBar(),

        const SizedBox(height: 18),

        _panel(
          title: 'Incident Records',
          subtitle:
          '${filteredIncidents.length} record(s) found',
          child: filteredIncidents.isEmpty
              ? _emptyState(
            Icons.security_outlined,
            incidents.isEmpty
                ? 'No incidents recorded'
                : 'No matching incidents',
            incidents.isEmpty
                ? 'Use New Incident to report a security event.'
                : 'Try changing your search or filters.',
          )
              : Column(
            children: [
              ...filteredIncidents.map(
                    (incident) =>
                    _incidentCard(incident),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _filterBar() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: widget.isDark
              ? Colors.white.withOpacity(.05)
              : const Color(0xFFE2E8F0),
        ),
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          _filterDropdown(
            'Severity',
            severityFilter,
            [
              'All',
              'Critical',
              'High',
              'Medium',
              'Low',
            ],
                (value) {
              setState(() {
                severityFilter = value;
              });
            },
          ),
          _filterDropdown(
            'Status',
            statusFilter,
            [
              'All',
              'Open',
              'Investigating',
              'Resolved',
              'Closed',
            ],
                (value) {
              setState(() {
                statusFilter = value;
              });
            },
          ),
          _filterDropdown(
            'Category',
            categoryFilter,
            [
              'All',
              ...categories,
            ],
                (value) {
              setState(() {
                categoryFilter = value;
              });
            },
          ),
          OutlinedButton.icon(
            onPressed: () {
              setState(() {
                searchController.clear();
                searchText = '';
                severityFilter = 'All';
                statusFilter = 'All';
                categoryFilter = 'All';
              });
            },
            icon: const Icon(
              Icons.refresh_rounded,
              size: 17,
            ),
            label: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  Widget _filterDropdown(
      String label,
      String value,
      List<String> items,
      ValueChanged<String> onChanged,
      ) {
    return SizedBox(
      width: 170,
      child: DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: cardColor2,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding:
          const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ),
        ),
        items: items
            .map(
              (item) => DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: TextStyle(
                fontSize: 12,
                color: textColor,
              ),
            ),
          ),
        )
            .toList(),
        onChanged: (value) {
          if (value != null) {
            onChanged(value);
          }
        },
      ),
    );
  }

  Widget _incidentCard(
      SecurityIncident incident,
      ) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _showIncidentDetails(incident),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: cardColor2,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: widget.isDark
                ? Colors.white.withOpacity(.04)
                : const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color:
                _severityColor(incident.severity)
                    .withOpacity(.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _severityIcon(incident.severity),
                color:
                _severityColor(incident.severity),
                size: 22,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          incident.title,
                          overflow:
                          TextOverflow.ellipsis,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 13,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        incident.id,
                        style: TextStyle(
                          color: mutedColor,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${incident.category} • ${incident.affectedSystem}',
                    style: TextStyle(
                      color: mutedColor,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            _statusBadge(incident.severity),
            const SizedBox(width: 10),
            _statusBadge(incident.status),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  _openEditIncident(incident);
                } else if (value == 'delete') {
                  _deleteIncident(incident);
                } else if (value == 'details') {
                  _showIncidentDetails(incident);
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 'details',
                  child: Text('View Details'),
                ),
                PopupMenuItem(
                  value: 'edit',
                  child: Text('Edit'),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ],
              child: Icon(
                Icons.more_vert_rounded,
                color: mutedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _incidentRow(
      SecurityIncident incident,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: widget.isDark
                ? Colors.white.withOpacity(.05)
                : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color:
              _severityColor(incident.severity)
                  .withOpacity(.10),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(
              _severityIcon(incident.severity),
              color:
              _severityColor(incident.severity),
              size: 17,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  incident.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  incident.id,
                  style: TextStyle(
                    color: mutedColor,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          _statusBadge(incident.severity),
          const SizedBox(width: 8),
          _statusBadge(incident.status),
        ],
      ),
    );
  }

  // ============================================================
  // ANALYTICS
  // ============================================================

  Widget _analyticsPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          'Security Analytics',
          'Understand your current threat landscape',
        ),
        const SizedBox(height: 20),

        LayoutBuilder(
          builder: (context, constraints) {
            final count =
            constraints.maxWidth > 1000 ? 4 : 2;

            return GridView.count(
              crossAxisCount: count,
              shrinkWrap: true,
              physics:
              const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.8,
              children: [
                _analyticsMiniCard(
                  'Critical',
                  criticalIncidents,
                  Colors.red,
                  Icons.gpp_bad_rounded,
                ),
                _analyticsMiniCard(
                  'High',
                  highIncidents,
                  Colors.orange,
                  Icons.warning_rounded,
                ),
                _analyticsMiniCard(
                  'Medium',
                  mediumIncidents,
                  Colors.amber,
                  Icons.info_rounded,
                ),
                _analyticsMiniCard(
                  'Low',
                  lowIncidents,
                  Colors.green,
                  Icons.check_circle_rounded,
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 20),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _panel(
                title: 'Severity Distribution',
                subtitle:
                'Incidents grouped by threat level',
                child: SizedBox(
                  height: 330,
                  child: incidents.isEmpty
                      ? _emptyChart(
                    'No data available yet.',
                  )
                      : _severityChart(),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _panel(
                title: 'Status Distribution',
                subtitle:
                'Current incident lifecycle',
                child: SizedBox(
                  height: 330,
                  child: incidents.isEmpty
                      ? _emptyChart(
                    'No data available yet.',
                  )
                      : _statusChart(),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        _panel(
          title: 'Category Analysis',
          subtitle: 'Incidents by security category',
          child: SizedBox(
            height: 330,
            child: incidents.isEmpty
                ? _emptyChart(
              'Add incidents to generate analytics.',
            )
                : _categoryChart(),
          ),
        ),
      ],
    );
  }

  Widget _analyticsMiniCard(
      String title,
      int value,
      Color color,
      IconData icon,
      ) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(.14),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 27,
          ),
          const SizedBox(width: 13),
          Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: mutedColor,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '$value',
                style: TextStyle(
                  color: textColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // REPORTS
  // ============================================================

  Widget _reportsPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          'Security Reports',
          'Operational summary of security activity',
          action: ElevatedButton.icon(
            onPressed: () {
              _showMessage(
                'Report generated successfully.',
              );
            },
            icon: const Icon(
              Icons.download_rounded,
              size: 18,
            ),
            label: const Text('Generate Report'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
          ),
        ),

        const SizedBox(height: 20),

        _panel(
          title: 'Security Summary',
          subtitle: 'Current system statistics',
          child: Column(
            children: [
              _reportRow(
                'Total Incidents',
                '$totalIncidents',
                Icons.security_rounded,
              ),
              _reportRow(
                'Open Incidents',
                '$openIncidents',
                Icons.lock_open_rounded,
              ),
              _reportRow(
                'Investigating',
                '$investigatingIncidents',
                Icons.search_rounded,
              ),
              _reportRow(
                'Resolved',
                '$resolvedIncidents',
                Icons.check_circle_outline_rounded,
              ),
              _reportRow(
                'Critical Threats',
                '$criticalIncidents',
                Icons.gpp_bad_outlined,
              ),
              _reportRow(
                'High Threats',
                '$highIncidents',
                Icons.warning_amber_rounded,
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        _panel(
          title: 'Incident Register',
          subtitle:
          'Complete incident records',
          child: incidents.isEmpty
              ? _emptyState(
            Icons.description_outlined,
            'No report data',
            'Incident records will appear here after submission.',
          )
              : Column(
            children: incidents.map((incident) {
              return _reportIncidentRow(
                incident,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _reportRow(
      String title,
      String value,
      IconData icon,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: widget.isDark
                ? Colors.white.withOpacity(.05)
                : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: mutedColor,
                fontSize: 12,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _reportIncidentRow(
      SecurityIncident incident,
      ) {
    return Container(
      padding: const EdgeInsets.all(13),
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        color: cardColor2,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${incident.id} — ${incident.title}',
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _statusBadge(incident.severity),
          const SizedBox(width: 8),
          _statusBadge(incident.status),
        ],
      ),
    );
  }

  // ============================================================
  // SETTINGS
  // ============================================================

  Widget _settingsPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          'System Settings',
          'Configure your security workspace',
        ),

        const SizedBox(height: 20),

        _panel(
          title: 'Appearance',
          subtitle: 'Customize dashboard appearance',
          child: Column(
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Dark Theme',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'Use a dark interface for security operations.',
                  style: TextStyle(
                    color: mutedColor,
                    fontSize: 10,
                  ),
                ),
                value: widget.isDark,
                activeColor: primary,
                onChanged: widget.onThemeChanged,
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        _panel(
          title: 'Data Management',
          subtitle: 'Manage local incident records',
          child: Column(
            children: [
              _settingAction(
                Icons.delete_sweep_outlined,
                'Clear All Incidents',
                'Remove all incident records from this session.',
                Colors.red,
                    () {
                  if (incidents.isEmpty) {
                    _showMessage(
                      'There are no incident records to clear.',
                    );
                    return;
                  }

                  _confirmClearAll();
                },
              ),
              _settingAction(
                Icons.refresh_rounded,
                'Reset Filters',
                'Return incident filters to their default values.',
                primary,
                    () {
                  setState(() {
                    searchController.clear();
                    searchText = '';
                    severityFilter = 'All';
                    statusFilter = 'All';
                    categoryFilter = 'All';
                  });

                  _showMessage(
                    'Filters reset successfully.',
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        _panel(
          title: 'System Information',
          subtitle: 'Application details',
          child: Column(
            children: [
              _infoRow(
                'Application',
                'CyberGuard SOC',
              ),
              _infoRow(
                'Module',
                'Incident Response',
              ),
              _infoRow(
                'Records',
                '${incidents.length}',
              ),
              _infoRow(
                'Monitoring',
                incidents.isEmpty
                    ? 'Ready'
                    : 'Active',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _settingAction(
      IconData icon,
      String title,
      String subtitle,
      Color color,
      VoidCallback onTap,
      ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: color.withOpacity(.10),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Icon(
          icon,
          color: color,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: mutedColor,
          fontSize: 10,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: mutedColor,
      ),
      onTap: onTap,
    );
  }

  Widget _infoRow(
      String title,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: mutedColor,
                fontSize: 12,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // QUICK ACTIONS
  // ============================================================

  Widget _quickActions() {
    return _panel(
      title: 'Quick Actions',
      subtitle: 'Common security operations',
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _quickButton(
            Icons.add_alert_rounded,
            'Report Incident',
            primary,
            _openAddIncident,
          ),
          _quickButton(
            Icons.analytics_outlined,
            'View Analytics',
            Colors.purple,
                () {
              setState(() {
                selectedPage = 2;
              });
            },
          ),
          _quickButton(
            Icons.description_outlined,
            'View Reports',
            Colors.orange,
                () {
              setState(() {
                selectedPage = 3;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _quickButton(
      IconData icon,
      String title,
      Color color,
      VoidCallback onTap,
      ) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardColor2,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(.12),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 21,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CHARTS
  // ============================================================

  Widget _severityChart() {
    final data = [
      _ChartData('Critical', criticalIncidents, Colors.red),
      _ChartData('High', highIncidents, Colors.orange),
      _ChartData('Medium', mediumIncidents, Colors.amber),
      _ChartData('Low', lowIncidents, Colors.green),
    ];

    return Padding(
      padding: const EdgeInsets.only(
        top: 12,
        right: 15,
        left: 5,
        bottom: 5,
      ),
      child: CustomPaint(
        painter: BarChartPainter(
          data: data,
          textColor: textColor,
          gridColor: widget.isDark
              ? Colors.white.withOpacity(.07)
              : const Color(0xFFE2E8F0),
        ),
        child: const SizedBox.expand(),
      ),
    );
  }

  Widget _categoryChart() {
    final counts = <String, int>{};

    for (final incident in incidents) {
      counts[incident.category] =
          (counts[incident.category] ?? 0) + 1;
    }

    final sorted = counts.entries.toList()
      ..sort(
            (a, b) => b.value.compareTo(a.value),
      );

    final data = sorted
        .take(8)
        .map(
          (entry) => _ChartData(
        entry.key,
        entry.value,
        primary,
      ),
    )
        .toList();

    return Padding(
      padding: const EdgeInsets.all(8),
      child: CustomPaint(
        painter: BarChartPainter(
          data: data,
          textColor: textColor,
          gridColor: widget.isDark
              ? Colors.white.withOpacity(.07)
              : const Color(0xFFE2E8F0),
        ),
        child: const SizedBox.expand(),
      ),
    );
  }

  Widget _statusChart() {
    final data = [
      _ChartData(
        'Open',
        openIncidents,
        Colors.orange,
      ),
      _ChartData(
        'Investigating',
        investigatingIncidents,
        Colors.purple,
      ),
      _ChartData(
        'Resolved',
        resolvedIncidents,
        Colors.green,
      ),
      _ChartData(
        'Closed',
        incidents
            .where((i) => i.status == 'Closed')
            .length,
        Colors.blue,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(8),
      child: CustomPaint(
        painter: DonutChartPainter(
          data: data,
          textColor: textColor,
          mutedColor: mutedColor,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }

  Widget _emptyChart(String text) {
    return Center(
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bar_chart_rounded,
            size: 42,
            color: mutedColor.withOpacity(.35),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: mutedColor,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MOBILE
  // ============================================================

  Widget _mobileLayout() {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: Row(
          children: [
            Icon(
              Icons.shield_rounded,
              color: primary,
              size: 23,
            ),
            const SizedBox(width: 9),
            Text(
              'CyberGuard',
              style: TextStyle(
                color: textColor,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showMessage(
                incidents.isEmpty
                    ? 'No security alerts.'
                    : '${incidents.length} incident(s) recorded.',
              );
            },
            icon: Icon(
              Icons.notifications_none_rounded,
              color: mutedColor,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: cardColor,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(22),
                child: Row(
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: primary.withOpacity(.12),
                        borderRadius:
                        BorderRadius.circular(13),
                      ),
                      child: Icon(
                        Icons.shield_rounded,
                        color: primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'CyberGuard SOC',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              _mobileNav(
                Icons.dashboard_rounded,
                'Dashboard',
                0,
              ),
              _mobileNav(
                Icons.warning_amber_rounded,
                'Incidents',
                1,
              ),
              _mobileNav(
                Icons.analytics_rounded,
                'Analytics',
                2,
              ),
              _mobileNav(
                Icons.assignment_rounded,
                'Reports',
                3,
              ),
              _mobileNav(
                Icons.settings_rounded,
                'Settings',
                4,
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              8,
              16,
              5,
            ),
            child: SizedBox(
              height: 44,
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
                style: TextStyle(
                  color: textColor,
                  fontSize: 12,
                ),
                decoration: InputDecoration(
                  hintText: 'Search incidents...',
                  hintStyle: TextStyle(
                    color: mutedColor,
                    fontSize: 12,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: mutedColor,
                  ),
                  filled: true,
                  fillColor: cardColor,
                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _pageContent(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        onPressed: _openAddIncident,
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _mobileNav(
      IconData icon,
      String title,
      int index,
      ) {
    final selected = selectedPage == index;

    return ListTile(
      selected: selected,
      selectedTileColor: primary.withOpacity(.10),
      leading: Icon(
        icon,
        color: selected ? primary : mutedColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: selected ? primary : textColor,
          fontSize: 13,
          fontWeight:
          selected ? FontWeight.bold : null,
        ),
      ),
      onTap: () {
        setState(() {
          selectedPage = index;
        });
        Navigator.pop(context);
      },
    );
  }

  // ============================================================
  // ADD / EDIT INCIDENT
  // ============================================================

  void _openAddIncident() {
    _showIncidentDialog();
  }

  void _openEditIncident(
      SecurityIncident incident,
      ) {
    _showIncidentDialog(
      existing: incident,
    );
  }

  void _showIncidentDialog({
    SecurityIncident? existing,
  }) {
    final isEdit = existing != null;

    final idController = TextEditingController(
      text: existing?.id ?? '',
    );
    final titleController = TextEditingController(
      text: existing?.title ?? '',
    );
    final systemController = TextEditingController(
      text: existing?.affectedSystem ?? '',
    );
    final descriptionController =
    TextEditingController(
      text: existing?.description ?? '',
    );
    final assignedController = TextEditingController(
      text: existing?.assignedTo ?? '',
    );
    final notesController = TextEditingController(
      text: existing?.notes ?? '',
    );
    final responseController = TextEditingController(
      text: existing?.responseAction ?? '',
    );

    String category =
        existing?.category ?? 'Malware';
    String severity =
        existing?.severity ?? 'Medium';
    String status =
        existing?.status ?? 'Open';

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
              context,
              setDialogState,
              ) {
            return AlertDialog(
              backgroundColor: cardColor,
              title: Row(
                children: [
                  Icon(
                    isEdit
                        ? Icons.edit_rounded
                        : Icons.add_alert_rounded,
                    color: primary,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    isEdit
                        ? 'Edit Incident'
                        : 'Report Incident',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 620,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _dialogInput(
                                idController,
                                'Incident ID',
                                'e.g. INC-001',
                                Icons.tag_rounded,
                                required: true,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _dialogInput(
                                titleController,
                                'Incident Title',
                                'e.g. Suspicious Login',
                                Icons.title_rounded,
                                required: true,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: _dialogDropdown(
                                'Category',
                                category,
                                [
                                  'Malware',
                                  'Phishing',
                                  'Unauthorized Access',
                                  'Data Breach',
                                  'DDoS',
                                  'Ransomware',
                                  'Account Compromise',
                                  'Other',
                                ],
                                    (value) {
                                  setDialogState(() {
                                    category = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _dialogDropdown(
                                'Severity',
                                severity,
                                [
                                  'Critical',
                                  'High',
                                  'Medium',
                                  'Low',
                                ],
                                    (value) {
                                  setDialogState(() {
                                    severity = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: _dialogDropdown(
                                'Status',
                                status,
                                [
                                  'Open',
                                  'Investigating',
                                  'Resolved',
                                  'Closed',
                                ],
                                    (value) {
                                  setDialogState(() {
                                    status = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _dialogInput(
                                systemController,
                                'Affected System',
                                'e.g. Web Server',
                                Icons.computer_rounded,
                                required: true,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        _dialogInput(
                          assignedController,
                          'Assigned Analyst',
                          'e.g. Security Team',
                          Icons.person_outline_rounded,
                        ),

                        const SizedBox(height: 12),

                        _dialogInput(
                          descriptionController,
                          'Incident Description',
                          'Describe the security event...',
                          Icons.description_outlined,
                          maxLines: 3,
                        ),

                        const SizedBox(height: 12),

                        _dialogInput(
                          notesController,
                          'Investigation Notes',
                          'Add investigation notes...',
                          Icons.note_alt_outlined,
                          maxLines: 3,
                        ),

                        const SizedBox(height: 12),

                        _dialogInput(
                          responseController,
                          'Response Action',
                          'Describe the response taken...',
                          Icons.bolt_rounded,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (!formKey.currentState!
                        .validate()) {
                      return;
                    }

                    final id = idController.text.trim();

                    if (!isEdit &&
                        incidents.any(
                              (item) =>
                          item.id.toLowerCase() ==
                              id.toLowerCase(),
                        )) {
                      _showMessage(
                        'Incident ID already exists.',
                      );
                      return;
                    }

                    setState(() {
                      if (isEdit) {
                        existing.id = id;
                        existing.title =
                            titleController.text.trim();
                        existing.category = category;
                        existing.severity = severity;
                        existing.status = status;
                        existing.affectedSystem =
                            systemController.text.trim();
                        existing.description =
                            descriptionController.text.trim();
                        existing.assignedTo =
                            assignedController.text.trim();
                        existing.notes =
                            notesController.text.trim();
                        existing.responseAction =
                            responseController.text.trim();
                      } else {
                        incidents.add(
                          SecurityIncident(
                            id: id,
                            title:
                            titleController.text.trim(),
                            category: category,
                            severity: severity,
                            status: status,
                            affectedSystem:
                            systemController.text.trim(),
                            description:
                            descriptionController.text
                                .trim(),
                            assignedTo:
                            assignedController.text
                                .trim(),
                            createdDate:
                            _currentDate(),
                            notes:
                            notesController.text.trim(),
                            responseAction:
                            responseController.text
                                .trim(),
                          ),
                        );
                      }
                    });

                    Navigator.pop(dialogContext);

                    _showMessage(
                      isEdit
                          ? 'Incident updated successfully.'
                          : 'Incident reported successfully.',
                    );
                  },
                  icon: Icon(
                    isEdit
                        ? Icons.save_rounded
                        : Icons.add_rounded,
                    size: 18,
                  ),
                  label: Text(
                    isEdit ? 'Save Changes' : 'Add Incident',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _dialogInput(
      TextEditingController controller,
      String label,
      String hint,
      IconData icon, {
        bool required = false,
        int maxLines = 1,
      }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(
        color: textColor,
        fontSize: 12,
      ),
      validator: required
          ? (value) {
        if (value == null ||
            value.trim().isEmpty) {
          return 'Required';
        }
        return null;
      }
          : null,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(
          icon,
          size: 19,
        ),
        filled: true,
        fillColor: cardColor2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _dialogDropdown(
      String label,
      String value,
      List<String> items,
      ValueChanged<String> onChanged,
      ) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: cardColor2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem(
          value: item,
          child: Text(
            item,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: textColor,
              fontSize: 11,
            ),
          ),
        ),
      )
          .toList(),
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
    );
  }

  // ============================================================
  // DETAILS
  // ============================================================

  void _showIncidentDetails(
      SecurityIncident incident,
      ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: cardColor,
          title: Row(
            children: [
              Icon(
                _severityIcon(incident.severity),
                color:
                _severityColor(incident.severity),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  incident.title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 600,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _statusBadge(incident.severity),
                      _statusBadge(incident.status),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _detailRow(
                    'Incident ID',
                    incident.id,
                  ),
                  _detailRow(
                    'Category',
                    incident.category,
                  ),
                  _detailRow(
                    'Affected System',
                    incident.affectedSystem,
                  ),
                  _detailRow(
                    'Assigned Analyst',
                    incident.assignedTo.isEmpty
                        ? 'Not assigned'
                        : incident.assignedTo,
                  ),
                  _detailRow(
                    'Created',
                    incident.createdDate,
                  ),
                  const SizedBox(height: 12),
                  _detailBlock(
                    'Description',
                    incident.description,
                  ),
                  _detailBlock(
                    'Investigation Notes',
                    incident.notes,
                  ),
                  _detailBlock(
                    'Response Action',
                    incident.responseAction,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _openEditIncident(incident);
              },
              icon: const Icon(
                Icons.edit_rounded,
                size: 17,
              ),
              label: const Text('Edit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _detailRow(
      String title,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 125,
            child: Text(
              title,
              style: TextStyle(
                color: mutedColor,
                fontSize: 11,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: textColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailBlock(
      String title,
      String value,
      ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: cardColor2,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: primary,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value.isEmpty ? 'No information added.' : value,
            style: TextStyle(
              color: value.isEmpty
                  ? mutedColor
                  : textColor,
              fontSize: 11,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DELETE
  // ============================================================

  void _deleteIncident(
      SecurityIncident incident,
      ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: cardColor,
          title: Text(
            'Delete Incident?',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete ${incident.id}?',
            style: TextStyle(
              color: mutedColor,
              fontSize: 12,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  incidents.remove(incident);
                });

                Navigator.pop(context);

                _showMessage(
                  'Incident deleted successfully.',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _confirmClearAll() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: cardColor,
          title: Text(
            'Clear All Incidents?',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'This will remove all current incident records.',
            style: TextStyle(
              color: mutedColor,
              fontSize: 12,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  incidents.clear();
                });

                Navigator.pop(context);

                _showMessage(
                  'All incidents cleared.',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Clear All'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // COMMON UI
  // ============================================================

  Widget _sectionHeader(
      String title,
      String subtitle, {
        Widget? action,
      }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: mutedColor,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        if (action != null) action,
      ],
    );
  }

  Widget _panel({
    required String title,
    required String subtitle,
    required Widget child,
    Widget? action,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: widget.isDark
              ? Colors.white.withOpacity(.05)
              : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: mutedColor,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              if (action != null) action,
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _emptyState(
      IconData icon,
      String title,
      String subtitle,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 35,
      ),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: primary.withOpacity(.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: primary.withOpacity(.65),
                size: 29,
              ),
            ),
            const SizedBox(height: 13),
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: mutedColor,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    final color = _statusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Critical':
        return Colors.red;
      case 'High':
        return Colors.orange;
      case 'Medium':
        return Colors.amber.shade700;
      case 'Low':
        return Colors.green;
      case 'Open':
        return Colors.orange;
      case 'Investigating':
        return Colors.purple;
      case 'Resolved':
        return Colors.green;
      case 'Closed':
        return Colors.blue;
      default:
        return primary;
    }
  }

  Color _severityColor(String severity) {
    switch (severity) {
      case 'Critical':
        return Colors.red;
      case 'High':
        return Colors.orange;
      case 'Medium':
        return Colors.amber.shade700;
      case 'Low':
        return Colors.green;
      default:
        return primary;
    }
  }

  IconData _severityIcon(String severity) {
    switch (severity) {
      case 'Critical':
        return Icons.gpp_bad_rounded;
      case 'High':
        return Icons.warning_rounded;
      case 'Medium':
        return Icons.info_rounded;
      case 'Low':
        return Icons.check_circle_rounded;
      default:
        return Icons.security_rounded;
    }
  }

  String _currentDate() {
    final now = DateTime.now();

    return '${now.day.toString().padLeft(2, '0')}/'
        '${now.month.toString().padLeft(2, '0')}/'
        '${now.year}';
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }
}

// ============================================================
// CHART DATA
// ============================================================

class _ChartData {
  final String label;
  final int value;
  final Color color;

  _ChartData(
      this.label,
      this.value,
      this.color,
      );
}

// ============================================================
// BAR CHART PAINTER
// ============================================================

class BarChartPainter extends CustomPainter {
  final List<_ChartData> data;
  final Color textColor;
  final Color gridColor;

  BarChartPainter({
    required this.data,
    required this.textColor,
    required this.gridColor,
  });

  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    if (data.isEmpty) return;

    final left = 42.0;
    final right = 12.0;
    final top = 15.0;
    final bottom = 42.0;

    final chartWidth =
        size.width - left - right;
    final chartHeight =
        size.height - top - bottom;

    int maxValue = 1;

    for (final item in data) {
      if (item.value > maxValue) {
        maxValue = item.value;
      }
    }

    if (maxValue < 4) {
      maxValue = 4;
    }

    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;

    final labelPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i <= 4; i++) {
      final y =
          top + chartHeight - (chartHeight * i / 4);

      canvas.drawLine(
        Offset(left, y),
        Offset(size.width - right, y),
        gridPaint,
      );

      final value =
      (maxValue * i / 4).round();

      labelPainter.text = TextSpan(
        text: '$value',
        style: TextStyle(
          color: textColor.withOpacity(.55),
          fontSize: 9,
        ),
      );

      labelPainter.layout();

      labelPainter.paint(
        canvas,
        Offset(
          left - labelPainter.width - 7,
          y - labelPainter.height / 2,
        ),
      );
    }

    final barSpace =
        chartWidth / data.length;
    final barWidth =
        barSpace * .48;

    for (int i = 0; i < data.length; i++) {
      final item = data[i];

      final height =
          chartHeight *
              (item.value / maxValue);

      final x =
          left +
              barSpace * i +
              (barSpace - barWidth) / 2;

      final y =
          top + chartHeight - height;

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          x,
          y,
          barWidth,
          height,
        ),
        const Radius.circular(7),
      );

      canvas.drawRRect(
        rect,
        Paint()..color = item.color,
      );

      labelPainter.text = TextSpan(
        text: '${item.value}',
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      );

      labelPainter.layout();

      labelPainter.paint(
        canvas,
        Offset(
          x +
              barWidth / 2 -
              labelPainter.width / 2,
          y - 17,
        ),
      );

      final label =
      item.label.length > 11
          ? '${item.label.substring(0, 10)}…'
          : item.label;

      labelPainter.text = TextSpan(
        text: label,
        style: TextStyle(
          color: textColor.withOpacity(.65),
          fontSize: 8,
        ),
      );

      labelPainter.layout();

      labelPainter.paint(
        canvas,
        Offset(
          x +
              barWidth / 2 -
              labelPainter.width / 2,
          top + chartHeight + 9,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(
      covariant BarChartPainter oldDelegate,
      ) {
    return true;
  }
}

// ============================================================
// DONUT CHART PAINTER
// ============================================================

class DonutChartPainter extends CustomPainter {
  final List<_ChartData> data;
  final Color textColor;
  final Color mutedColor;

  DonutChartPainter({
    required this.data,
    required this.textColor,
    required this.mutedColor,
  });

  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    final total = data.fold<int>(
      0,
          (sum, item) => sum + item.value,
    );

    if (total == 0) return;

    final center = Offset(
      size.width * .36,
      size.height * .48,
    );

    final radius =
        size.shortestSide * .27;

    final rect = Rect.fromCircle(
      center: center,
      radius: radius,
    );

    double startAngle = -1.5708;

    for (final item in data) {
      if (item.value == 0) continue;

      final sweep =
          (item.value / total) * 6.28318;

      final paint = Paint()
        ..color = item.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * .30
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        rect,
        startAngle,
        sweep,
        false,
        paint,
      );

      startAngle += sweep;
    }

    final centerPainter = TextPainter(
      text: TextSpan(
        text: '$total',
        style: TextStyle(
          color: textColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    centerPainter.layout();

    centerPainter.paint(
      canvas,
      Offset(
        center.dx - centerPainter.width / 2,
        center.dy - 17,
      ),
    );

    final labelPainter = TextPainter(
      text: TextSpan(
        text: 'Total',
        style: TextStyle(
          color: mutedColor,
          fontSize: 9,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    labelPainter.layout();

    labelPainter.paint(
      canvas,
      Offset(
        center.dx - labelPainter.width / 2,
        center.dy + 12,
      ),
    );

    double legendY = 25;

    for (final item in data) {
      if (item.value == 0) continue;

      canvas.drawCircle(
        Offset(size.width * .69, legendY + 5),
        5,
        Paint()..color = item.color,
      );

      final percentage =
      ((item.value / total) * 100).round();

      final painter = TextPainter(
        text: TextSpan(
          text:
          '${item.label}  $percentage%',
          style: TextStyle(
            color: textColor.withOpacity(.75),
            fontSize: 9,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      painter.layout();

      painter.paint(
        canvas,
        Offset(
          size.width * .69 + 11,
          legendY - 2,
        ),
      );

      legendY += 30;
    }
  }

  @override
  bool shouldRepaint(
      covariant DonutChartPainter oldDelegate,
      ) {
    return true;
  }
}