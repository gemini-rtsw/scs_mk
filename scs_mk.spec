%define _prefix /gem_base/epics/ioc
%define name scs_mk
%define repository gemdev
%define debug_package %{nil}
%define arch %(uname -m)
%define git_hash %(git rev-parse --short HEAD 2>/dev/null || echo "nogit")
%define git_branch %( (git rev-parse --abbrev-ref HEAD 2>/dev/null | grep -v HEAD || echo ${CI_COMMIT_REF_NAME:-nobranch}) | sed 's/[^a-zA-Z0-9]/_/g' )

#These global defines are added to prevent stripping
# symbols on vxWorks cross-compiled code
# Getting 'strip' to work is probably only needed for
# building a related debug sub-package
#
# But this prevents all the strip warnings
# mrippa 20120202
%global _enable_debug_package 0
%global debug_package %{nil}
%global __os_install_post /usr/lib/rpm/brp-compress %{nil}

Summary: %{name} Package, a module for EPICS base
Name: %{name}
Version: 2.11
Release: 8.%{git_branch}.%{git_hash}%{?dist}
License: EPICS Open License
Group: Applications/Engineering
Source0: %{name}-%{version}.tar.gz
ExclusiveArch: %{arch}
Prefix: %{_prefix}
## You may specify dependencies here
## Versions are pinned exactly. To upgrade a dependency, edit the version
## below explicitly — do not relax the pins.
BuildRequires: re2c
BuildRequires: tdct
BuildRequires: epics-base-devel    = 7.0.7-0.git.37.9b80a5c
BuildRequires: sequencer-devel     = 2.2.9.e5e3615-4.git.68.cf961a8.el8
BuildRequires: autosave-devel      = 5.10.2-0.git.11.b869ff1.el8
BuildRequires: bancomm-devel       = 1.6.13-4.git.28.1ca0cb4.el8
BuildRequires: geminiRec-devel     = 4.1.13-3.git.53.c94c965.el8
BuildRequires: timelib-devel       = 2.1.4-3.git.21.866a01c.el8
BuildRequires: slalib-devel        = 1.9.7-6.git.67.7872e05.el8
BuildRequires: xycom-devel         = 2.1.12-2.git.40.bfc6610.el8
BuildRequires: gemUtil-devel       = 1.6.13-2.git.27.0265e0f.el8
BuildRequires: timeProbe-devel     = 1.1.16-3.git.27.7207767.el8
BuildRequires: tcslib-devel        = 1.1.1-9.git.37.d589d5e.el8
BuildRequires: pvload-devel        = 1.2.1-7.git.45.a07ac91.el8
BuildRequires: symb-devel          = 1.6.13-4.git.13.a94249f.el8
BuildRequires: vmi5588-devel       = 1.3-1.git.18.07dd878.el8
Requires: epics-base = 7.0.7-0.git.37.9b80a5c
Requires: sequencer  = 2.2.9.e5e3615-4.git.68.cf961a8.el8
Requires: autosave   = 5.10.2-0.git.11.b869ff1.el8
Requires: bancomm    = 1.6.13-4.git.28.1ca0cb4.el8
Requires: geminiRec  = 4.1.13-3.git.53.c94c965.el8
Requires: timelib    = 2.1.4-3.git.21.866a01c.el8
Requires: slalib     = 1.9.7-6.git.67.7872e05.el8
Requires: xycom      = 2.1.12-2.git.40.bfc6610.el8
Requires: gemUtil    = 1.6.13-2.git.27.0265e0f.el8
Requires: timeProbe  = 1.1.16-3.git.27.7207767.el8
Requires: tcslib     = 1.1.1-9.git.37.d589d5e.el8
Requires: pvload     = 1.2.1-7.git.45.a07ac91.el8
Requires: symb       = 1.6.13-4.git.13.a94249f.el8
Requires: vmi5588    = 1.3-1.git.18.07dd878.el8
## Switch dependency checking off
AutoReqProv: no

%description
This is the module %{name}.

## If you want to have a devel-package to be generated uncomment the following:
%package devel
Summary: %{name}-devel Package
Group: Development/Gemini
Requires: %{name} = %{version}-%{release}
Requires: tdct
Requires: re2c
Requires: epics-base-devel = 7.0.7-0.git.37.9b80a5c
Requires: sequencer-devel  = 2.2.9.e5e3615-4.git.68.cf961a8.el8
Requires: autosave-devel   = 5.10.2-0.git.11.b869ff1.el8
Requires: bancomm-devel    = 1.6.13-4.git.28.1ca0cb4.el8
Requires: geminiRec-devel  = 4.1.13-3.git.53.c94c965.el8
Requires: timelib-devel    = 2.1.4-3.git.21.866a01c.el8
Requires: slalib-devel     = 1.9.7-6.git.67.7872e05.el8
Requires: xycom-devel      = 2.1.12-2.git.40.bfc6610.el8
Requires: gemUtil-devel    = 1.6.13-2.git.27.0265e0f.el8
Requires: timeProbe-devel  = 1.1.16-3.git.27.7207767.el8
Requires: tcslib-devel     = 1.1.1-9.git.37.d589d5e.el8
Requires: pvload-devel     = 1.2.1-7.git.45.a07ac91.el8
Requires: symb-devel       = 1.6.13-4.git.13.a94249f.el8
Requires: vmi5588-devel    = 1.3-1.git.18.07dd878.el8
%description devel
This is the module %{name}.

%prep
%setup -q 

%build
#update environment from former rpm installations due to BuildRequires
source /gem_base/etc/profile
#start virtual framebuffer to have graphics for java
#Xvfb :1  -ac -nolisten tcp -nolisten unix &

make distclean uninstall
#DISPLAY=:1 make
make
#killall Xvfb

%install
export DONT_STRIP=1
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/%{_prefix}/%{name}
cp -r dbd $RPM_BUILD_ROOT/%{_prefix}/%{name}
cp -r db $RPM_BUILD_ROOT/%{_prefix}/%{name}
cp -r bin $RPM_BUILD_ROOT/%{_prefix}/%{name}
cp -r configure $RPM_BUILD_ROOT/%{_prefix}/%{name}
cp -r data $RPM_BUILD_ROOT/%{_prefix}/%{name}
cp -r lib $RPM_BUILD_ROOT/%{_prefix}/%{name}

%postun
if [ "$1" = "0" ]; then
	rm -rf %{_prefix}/%{name}
fi


%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
   /%{_prefix}/%{name}/bin
   /%{_prefix}/%{name}/db
   /%{_prefix}/%{name}/dbd
   /%{_prefix}/%{name}/configure
   /%{_prefix}/%{name}/data
   /%{_prefix}/%{name}/lib

%files devel
%defattr(-,root,root)
   # No files needed for devel package, just dependencies

%changelog
