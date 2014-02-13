%define		plugin	check_vserver_count
Summary:	Nagios plugin to check vserver count
Name:		nagios-plugin-%{plugin}
Version:	0.2
Release:	3
License:	GPL v2
Group:		Networking
Source0:	%{plugin}.sh
Source1:	%{plugin}.cfg
BuildRequires:	rpmbuild(macros) >= 1.685
Requires:	grep
Requires:	nagios-common
Requires:	sed >= 4.0
BuildArch:	noarch
BuildRoot:	%{tmpdir}/%{name}-%{version}-root-%(id -u -n)

%define		_sysconfdir	/etc/nagios/plugins
%define		nrpeddir	/etc/nagios/nrpe.d
%define		plugindir	%{_prefix}/lib/nagios/plugins

%description
Nagios plugin to check vserver count. registered via startup mark and
actually running count.

%prep
%setup -qcT

%install
rm -rf $RPM_BUILD_ROOT
install -d $RPM_BUILD_ROOT{%{_sysconfdir},%{nrpeddir},%{plugindir}}
install -p %{SOURCE0} $RPM_BUILD_ROOT%{plugindir}/%{plugin}
cp -p %{SOURCE1} $RPM_BUILD_ROOT%{_sysconfdir}/%{plugin}.cfg
touch $RPM_BUILD_ROOT%{nrpeddir}/%{plugin}.cfg

%clean
rm -rf $RPM_BUILD_ROOT

%triggerin -- nagios-nrpe
%nagios_nrpe -a %{plugin} -f %{_sysconfdir}/%{plugin}.cfg

%triggerun -- nagios-nrpe
%nagios_nrpe -d %{plugin} -f %{_sysconfdir}/%{plugin}.cfg

%files
%defattr(644,root,root,755)
%attr(640,root,nagios) %config(noreplace) %verify(not md5 mtime size) %{_sysconfdir}/%{plugin}.cfg
%attr(755,root,root) %{plugindir}/%{plugin}
%ghost %{nrpeddir}/%{plugin}.cfg
