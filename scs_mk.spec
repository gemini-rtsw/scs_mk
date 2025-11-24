%define _prefix /gem_base/epics/ioc
%define name scs_mk
%define repository gemdev
%define debug_package %{nil}
%define arch %(uname -m)
%define git_hash %(git rev-parse --short HEAD 2>/dev/null || echo "nogit")
%define git_branch %(git rev-parse --abbrev-ref HEAD 2>/dev/null | sed 's/[^a-zA-Z0-9._-]/-/g' | sed 's/-\+/-/g' | sed 's/^-\|-$//g' || echo "nobranch")

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
Version: 2.9
Release: 8.%{git_branch}.%{git_hash}%{?dist}
License: EPICS Open License
Group: Applications/Engineering
Source0: %{name}-%{version}.tar.gz
ExclusiveArch: %{arch}
Prefix: %{_prefix}
## You may specify dependencies here
BuildRequires: epics-base-devel re2c tdct sequencer-devel autosave-devel bancomm-devel geminiRec-devel timelib-devel slalib-devel xycom-devel gemUtil-devel timeProbe-devel tcslib-devel pvload-devel symb-devel vmi5588-devel
Requires: epics-base sequencer autosave bancomm geminiRec timelib slalib xycom gemUtil timeProbe tcslib pvload symb vmi5588
## Switch dependency checking off
AutoReqProv: no

%description
This is the module %{name}.

## If you want to have a devel-package to be generated uncomment the following:
%package devel
Summary: %{name}-devel Package
Group: Development/Gemini
Requires: %{name} epics-base-devel tdct re2c sequencer-devel autosave-devel  bancomm-devel geminiRec-devel timelib-devel slalib-devel xycom-devel gemUtil-devel timeProbe-devel tcslib-devel pvload-devel symb-devel vmi5588-devel
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

%files devel
%defattr(-,root,root)
   # No files needed for devel package, just dependencies

%changelog
