#!/bin/sh
#bof
version=3.1.4
release="February 23 2020"
dc_version=2.8
title="Asuswrt-Merlin Terminal Menu"
contributors="Contributors: Adamm, ColinTaylor, Martineau
 https://www.snbforums.com/members/adamm.19554
 https://www.snbforums.com/members/colintaylor.27699
 https://www.snbforums.com/members/martineau.13215"

### Begin updates for /usr/sbin/amtm ###
if [ "$amtmRev" = 1 ]; then
	g_m amtm_rev1.mod include
fi
### End updates for /usr/sbin/amtm ###

ascii_logo(){
	echo "              _"
	echo "   ____ ____ | |_  ____"
	echo "  / _  |    \|  _)|    \ "
	echo " ( ( | | | | | |__| | | |"
	echo "  \_||_|_|_|_|\___)_|_|_|"
	echo
	echo " $1"
}

about_amtm(){
	p_e_l
	echo " amtm, the $title
 Version $version FW, released on $release
 (Built-in firmware version)

 amtm is a front end that manages popular scripts
 for wireless routers running Asuswrt-Merlin firmware.

 For updates and discussion visit this thread:
 https://www.snbforums.com/threads/amtm-the-asuswrt-merlin-terminal-menu.42415/

 Proudly coded by thelonelycoder:
 Copyright (c) 2016-2066 thelonelycoder - All Rights Reserved
 https://www.snbforums.com/members/thelonelycoder.25480
 https://diversion.ch/amtm.html

 $contributors

 amtm License:
 amtm is free to use under the GNU General
 Public License, version 3 (GPL-3.0).
 https://opensource.org/licenses/GPL-3.0

 Follow amtm on Twitter or Reddit:
 https://twitter.com/DiversionBlock
 https://www.reddit.com/r/diversion"
	p_r_l
	p_e_t "return to menu"
	show_amtm menu
}

c_e(){ [ ! -f /opt/bin/opkg ] && show_amtm " $1 requires the Entware repository\\n installed. Enter ${GN_BG}ep${NC} to install Entware now.";}
c_j_s(){ if [ ! -f "$1" ]; then echo "#!/bin/sh" >"$1"; echo >>"$1"; elif [ -f "$1" ] && ! head -1 "$1" | grep -qE "^#!/bin/sh"; then c_nl "$1"; echo >>"$1"; sed -i '1s~^~#!/bin/sh\n~' "$1";fi; d_t_u "$1"; c_nl "$1"; [ ! -x "$1" ] && chmod 0755 "$1";}
c_d(){ p_e_l;while true;do printf " Continue? [1=Yes e=Exit] ";read -r continue;case "$continue" in 1)echo;break;;[Ee])am=;show_amtm menu;break;;*)printf "\\n input is not an option\\n\\n";;esac done;}
p_e_t(){ printf "\\n Press Enter to $1 ";read -r;echo;}
r_m(){ [ -f "${add}/$1" ] && rm -f "${add}/$1";}
s_d_u(){ case "$release" in *XX*)amtmURL=http://diversion.test/amtm_fw;;*)amtmURL=https://fwupdate.asuswrt-merlin.net/amtm_fw;;esac;}
s_p(){ for i in "$1"/*; do if [ -d "$i" ]; then s_p "$i";elif [ -f "$i" ]; then [ ! -w "$i" ] && chmod 0666 "$i";d_t_u "$i";fi;done;}

g_i_m(){
	for i in "$1"/*; do
		if [ -d "$i" ]; then
			g_i_m "$i"
		elif [ "${i##*.}" = mod ]; then
			rdl=re
			g_m "${i##*/}" new
		fi
	done
	s_p "${add}"
	rdl=
}

show_amtm(){
	s_d_u
	c_t
	unset dlok dfc
	clear
	printf "${R_BG}%-27s%s\\n" " amtm $version FW" "by thelonelycoder ${NC}"
	[ -z "$(nvram get odmpid)" ] && model="$(nvram get productid)" || model="$(nvram get odmpid)"
	echo " $model ($(uname -m)) FW-$(nvram get buildno) @ $(nvram get lan_ipaddr)"
	printf "${R_BG}%-44s ${NC}\\n\\n" "    The $title"

	modules='/opt/bin/diversion diversion 1 Diversion¦-¦the¦Router¦Adblocker
	/jffs/scripts/firewall skynet 2 Skynet¦-¦the¦Router¦Firewall
	/jffs/scripts/FreshJR_QOS FreshJR_QOS 3 FreshJR¦-¦Adaptive¦QOS
	spacer
	/jffs/scripts/YazFi YazFi 4 YazFi¦-¦enhanced¦guest¦WiFi
	/jffs/scripts/scribe scribe 5 scribe¦-¦syslog-ng¦and¦logrotate
	/opt/bin/x3mRouting x3mRouting 6 x3mRouting¦-¦Selective¦Routing
	spacer
	/jffs/addons/unbound/unbound_manager.sh unbound_manager 7 unbound¦Manager¦-¦unbound¦utility
	/jffs/scripts/nsrum nsrum 8 nsrum¦-¦NVRAM¦Save/Restore¦Utility
	spacer
	/jffs/scripts/connmon connmon j1 connmon¦-¦Internet¦uptime¦monitor
	/jffs/scripts/ntpmerlin ntpmerlin j2 ntpMerlin¦-¦NTP¦Daemon
	/jffs/scripts/scmerlin scmerlin j3 scMerlin¦-¦Quick¦access¦control
	spacer
	/jffs/scripts/spdmerlin spdmerlin j4 spdMerlin¦-¦Automatic¦speedtest
	/jffs/scripts/uiDivStats uiDivStats j5 uiDivStats¦-¦Diversion¦WebUI¦stats
	/jffs/scripts/uiScribe uiScribe j6 uiScribe¦-¦WebUI¦for¦scribe¦logs
	spacer
	stubby
	/jffs/dnscrypt/installer dnscrypt di dnscrypt¦installer
	/opt/bin/opkg entware ep Entware¦-¦Software¦repository
	pixelserv-tls
	spacer'

	IFS='
	'
	set -f
	for i in $modules; do
		if [ "$i" = spacer ]; then
			[ "$atii" ] || [ "$ss" ] && echo
			atii=
		elif [ "$i" = stubby ]; then
			scriptloc=/jffs/scripts/install_stubby.sh
			if [ -f "$scriptloc" ] && [ -f /opt/etc/stubby/stubby.yml ]; then
				g_m install_stubby.mod include
				stubby_installed
			elif [ -z "$(nvram get rc_support | tr ' ' '\n' | grep dnspriv)" ] && [ -z "$(nvram get rc_support | tr ' ' '\n' | grep stubby)" ]; then
				[ "$ss" ] && printf "${E_BG} sd${NC} %-9s%s\\n" "install" "Stubby - DNS Privacy Daemon"
				r_m install_stubby.mod
				case_sd(){
					g_m install_stubby.mod include
					[ -f "${add}"/install_stubby.mod ] && install_stubby
				}
			else
				case_sd(){
					show_amtm " Stubby DNS is not available to install. This\\n router supports native DoT, use that instead"
				}
			fi
		elif [ "$i" = pixelserv-tls ]; then
			if [ -f /opt/bin/pixelserv-tls ]; then
				[ ! -f "${add}"/pixelserv-tls.mod ] && [ "$ss" ] && [ -z "$su" ] && printf "${E_BG} ps${NC} %-9s%s\\n" "use" "pixelserv-tls CA for WebUI"
				case_ps(){
					g_m pixelserv-tls.mod include
					[ -f "${add}"/pixelserv-tls.mod ] && use_ps_ca
				}
			else
				r_m pixelserv-tls.mod
				case_ps(){
					show_amtm " No pixelserv-tls beta versions are available\\n at thist time from its author kvic"
				}
			fi
		else
			scriptloc=$(echo $i | awk '{print $1}')
			f2=$(echo $i | awk '{print $2}')
			if [ -f "$scriptloc" ]; then
				g_m ${f2}.mod include
				[ -f "${add}/${f2}.mod" ] && ${f2}_installed
			else
				f3="$(echo $i | awk '{print $3}')"
				[ "$(echo $f3 | wc -m)" -gt 2 ] && ssp= || ssp=' '
				[ "$ss" ] && printf "${E_BG} ${f3}$ssp${NC} %-9s%s\\n" "install" "$(echo $i | awk '{print $4}' | sed 's/¦/ /g')"
				r_m ${f2}.mod
				case $f3 in
					1)		case_1(){ g_m diversion.mod include;[ "$dlok" = 1 ] && install_diversion || show_amtm menu;};;
					2)		case_2(){ g_m skynet.mod include;[ "$dlok" = 1 ] && install_skynet || show_amtm menu;};;
					3)		case_3(){ g_m FreshJR_QOS.mod include;[ "$dlok" = 1 ] && install_FreshJR_QOS || show_amtm menu;};;
					4)		case_4(){ g_m YazFi.mod include;[ "$dlok" = 1 ] && install_YazFi || show_amtm menu;};;
					5)		case_5(){ c_e scribe;g_m scribe.mod include;[ "$dlok" = 1 ] && install_scribe || show_amtm menu;};;
					6)		case_6(){ c_e x3mRouting;g_m x3mRouting.mod include;[ "$dlok" = 1 ] && install_x3mRouting || show_amtm menu;};;
					7)		case_7(){ c_e 'unbound Manager';g_m unbound_manager.mod include;[ "$dlok" = 1 ] && install_unbound_manager || show_amtm menu;};;
					8)		case_8(){ g_m nsrum.mod include;[ "$dlok" = 1 ] && install_nsrum || show_amtm menu;};;
					j1)		case_j1(){ c_e connmon;g_m connmon.mod include;[ "$dlok" = 1 ] && install_connmon || show_amtm menu;};;
					j2)		case_j2(){ c_e ntpmerlin;g_m ntpmerlin.mod include;[ "$dlok" = 1 ] && install_ntpmerlin || show_amtm menu;};;
					j3)		case_j3(){ g_m scmerlin.mod include;[ "$dlok" = 1 ] && install_scmerlin || show_amtm menu;};;
					j4)		case_j4(){ c_e spdMerlin;g_m spdmerlin.mod include;[ "$dlok" = 1 ] && install_spdmerlin || show_amtm menu;};;
					j5)		case_j5(){ g_m uiDivStats.mod include;[ "$dlok" = 1 ] && install_uiDivStats || show_amtm menu;};;
					j6)		case_j6(){ g_m uiScribe.mod include;[ "$dlok" = 1 ] && install_uiScribe || show_amtm menu;};;
					di)		case_di(){ g_m dnscrypt.mod include;[ "$dlok" = 1 ] && install_dnscrypt || show_amtm menu;};;
					ep)		case_ep(){ g_m entware_setup.mod include;[ "$dlok" = 1 ] && install_Entware || show_amtm menu;};;
				esac
			fi
		fi
	done
	set +f
	unset IFS

	if [ "$tpu" ]; then
		[ -f /tmp/amtm-tpu-check ] && [ ! -s /tmp/amtm-tpu-check ] && rm /tmp/amtm-tpu-check
		exit 0
	fi

	if [ -f "${add}"/disk-check ] || [ -f /jffs/scripts/disk-check ] && grep -q "/disk-check # Added by" /jffs/scripts/pre-mount; then
		g_m disk-check.mod include
		case_dc(){
			[ -f "${add}"/disk-check.mod ] && disk_check manage
			show_amtm menu
		}
		[ -f "${add}"/disk-check.mod ] && disk_check_installed || show_amtm menu
	else
		[ "$ss" ] && [ -z "$su" ] && printf "${E_BG} dc${NC} %-9s%s\\n" "install" "Disk check script"
		r_m disk-check.mod
		case_dc(){
			g_m disk-check.mod include
			[ -f "${add}"/disk-check.mod ] && install_disk_check || show_amtm menu
		}
	fi

	if [ -f "${add}"/amtm-format-disk.log ]; then
		atii=1
		[ "$su" ] || printf "${GN_BG} fd${NC} %-9s%s\\n" "run" "Format disk         ${GN_BG}fdl${NC} show log"
	else
		[ "$ss" ] && [ -z "$su" ] && printf "${GN_BG} fd${NC} %-9s%s\\n" "run" "Format disk"
		r_m format_disk.mod
	fi
	case_fd(){
		g_m format_disk.mod include
		[ -f "${add}"/format_disk.mod ] && format_disk || show_amtm menu
	}

	if [ -f /jffs/scripts/init-start ] && grep -qE "amtm_RebootScheduler" /jffs/scripts/init-start; then
		g_m reboot_scheduler.mod include
		[ -f "${add}"/reboot_scheduler.mod ] && reboot_scheduler_installed || show_amtm menu
	else
		[ "$ss" ] && [ -z "$su" ] && printf "${E_BG} rs${NC} %-9s%s\\n" "enable" "Reboot scheduler"
		r_m reboot_scheduler.mod
		case_rs(){
			g_m reboot_scheduler.mod include
			[ -f "${add}"/reboot_scheduler.mod ] && install_reboot_scheduler || show_amtm menu
		}
	fi

	unset swl swsize swpsize swtxt mpsw
	gms(){ g_m swap.mod include;[ "$dlok" = 0 ] && show_amtm menu;}
	[ -f /jffs/scripts/post-mount ] && swl="$(grep -E "^swapon " /jffs/scripts/post-mount | awk '{print $2}')"
	if [ "$(wc -l < /proc/swaps)" -eq 2 ]; then
		if [ -f "$swl" ] && [ "$swl" = "$(sed -n '2p' /proc/swaps | awk '{print $1}')" ]; then
			if grep -qE "^swapon $swl" /jffs/scripts/post-mount; then
				swsize=$(du -h "$swl" | awk '{print $1}')
			else
				gms;check_swap
			fi
		else
			gms;check_swap
		fi
	elif [ -f /jffs/configs/fstab ] && grep -qF "swap" /jffs/configs/fstab; then
		gms;check_swap
	elif [ "$swl" ] && [ ! -f "$swl" ]; then
		gms;check_swap
	fi
	if [ "$swtxt" ] && ! grep -q 'do-not-check-swap' /jffs/scripts/post-mount; then
		a_m "$swtxt"
	fi
	if [ -f "$swl" ]; then
		atii=1
		[ "$su" ] || printf "${GN_BG} sw${NC} %-9s%s ${GN_BG}%s${NC} $swsize\\n" "manage" "Swap file" "$(echo "${swl#/tmp}" | sed 's|/myswap.swp||')"
		case_swp(){
			gms;manage_swap delete
		}
	elif [ "$swl" ] && [ "$swpsize" ]; then
		atii=1
		[ "$su" ] || printf "${GN_BG}   ${NC} %-9s%s ${GN_BG}%s${NC}\\n" "Swap" "Partition" "${GN_BG}$swl${NC} ${swpsize}M"
		case_swp(){
			show_amtm " amtm does not manage swap partitions"
		}
	elif [ "$mpsw" ]; then
		atii=1
		[ "$su" ] || printf "${GN_BG} sw${NC} %-9s%s ${GN_BG}%s${NC}\\n" "delete" "Swap files"
		case_swp(){
			gms;manage_swap multidelete
		}
	else
		[ "$ss" ] && [ -z "$su" ] && printf "${E_BG} sw${NC} %-9s%s\\n" "create" "Swap file"
		case_swp(){
			gms;manage_swap create
		}
	fi

	[ "$atii" ] || [ "$ss" ] && [ -z "$su" ] && echo
	atii=

	if [ "$ss" ]; then
		[ "$su" ] || printf "${GN_BG} i ${NC} %-9s%s\\n" "hide" "inactive scripts or tools"
	else
		[ "$su" ] || printf "${E_BG} i ${NC} %-9s%s\\n" "show" "all available scripts or tools"
	fi

	if [ "$su" = 1 ]; then
		update_amtm
		corr1=
		if [ "$amtmUpd" = 0 ]; then
			vversion="${GN_BG} uu ${NC} force update"
			corr1=-2
		else
			vversion="        v$version"
		fi
		printf "${GN_BG} m ${NC} %-9s%-21s%$((COR$corr1))s\\n" "menu" "amtm  $vversion" "$thisrem"
	else
		[ "$ss" ] || printf "${GN_BG} u ${NC} %-9s%s\\n" "check" "for script updates"
		echo;echo "    amtm options"
		echo "${GN_BG} e ${NC} exit     ${GN_BG} t ${NC} theme  ${GN_BG} r ${NC} reset  ${GN_BG} a ${NC} about"
	fi

	[ "$ss" ] && ssi=1 || ssi=
	unset ss atii upd
	if [ "$su" = 1 ]; then
		su=
		if [ "$suUpd" = 1 ] || [ "$amtmUpd" -gt 0 ]; then
			if [ "$amtmUpd" -gt 0 ]; then
				p_e_l
				if [ "$suUpd" = 1 ]; then
					printf " Script update(s) available!\\n"
					p_e_l
				fi
				amtmUpdText=" amtm updated from v$version to v$amtmRemotever"
				[ "$amtmUpd" = 1 ] && printf " ${R}amtm $amtmRemotever is now available!${NC}\\n See https://diversion.ch for what's new.\\n\\n"
				if [ "$amtmUpd" = 2 ]; then
					printf " ${R}A minor amtm update is available!${NC}\\n\\n"
					amtmUpdText=" minor version update applied"
				fi
				echo " Do you want to update amtm now?"
				c_d
				a_m "$amtmUpdText"
				g_i_m "${add}"
				exec "$0" "$am"
			else
				a_m " Script update(s) available!"
			fi
		else
			if [ "$updErr" = 1 ]; then
				a_m " Update aborted, could not retrieve version"
			else
				a_m " All scripts are up to date"
			fi
		fi
	fi
	[ "$sfp" = 1 ] && s_p "${add}"
	unset sfp dfc
	rm -f /tmp/amtm-dl

	if [ "$1" = menu ] && [ -z "$am" ]; then
		p_e_l
	else
		p_e_l
		if [ "$am" ]; then
			[ "$1" = menu ] && printf "$(echo "$am" | sed 's/^\\n//')\\n" || printf "$1\\n$am\\n"
			am=
		else
			printf "$1\\n"
		fi
		p_e_l
	fi

	while true; do
		printf "${R_BG} Enter option ${NC} ";read -r selection
		s_d_u
		case "$selection" in
			1)					case_1;break;;
			2)					case_2;break;;
			3)					case_3;break;;
			4)					case_4;break;;
			5)					case_5;break;;
			6)					case_6;break;;
			7)					case_7;break;;
			8)					case_8;break;;
			[Jj]1)				case_j1;break;;
			[Jj]2)				case_j2;break;;
			[Jj]3)				case_j3;break;;
			[Jj]4)				case_j4;break;;
			[Jj]5)				case_j5;break;;
			[Jj]6)				case_j6;break;;
			[Ii])				[ "$ssi" ] && ss= || ss=1;show_amtm menu;break;;
			[Ss][Dd])			case_sd;break;;
			[Dd][Ii])			case_di;break;;
			[Ee][Pp])			case_ep;break;;
			[Pp][Ss])			case_ps;break;;
			[Uu])				su=1;suUpd=0;updErr=;show_amtm menu;break;;
			[Dd][Cc])			case_dc;break;;
			dcl|DCL)			s_l_f amtm-disk-check.log;break;;
			[Ff][Dd])			case_fd;break;;
			fdl|FDL)			s_l_f amtm-format-disk.log;break;;
			[Rr][Ss])			case_rs;break;;
			[Ss][Ww])			case_swp;break;;
			[Tt]|[Cc][Tt])		theme_amtm;break;;
			[Mm])				show_amtm menu;break;;
			[Uu][Uu])			update_amtm;break;;
			[Rr])				reset_amtm;break;;
			[Aa])				about_amtm;break;;
			[Ee])				clear
								ascii_logo '  Goodbye'
								echo
								exit 0;break;;
			reboot)				p_e_l   # hidden, reboot router
								echo " OK then, rebooting this router, are you sure?"
								c_d
								clear
								ascii_logo '  Goodbye!'
								echo
								printf " amtm reboots this router now\\n\\n"
								sleep 1
								service reboot >/dev/null 2>&1 &
								exit 0
								break;;
			*)					printf "\\n               input is not an option\\n\\n";;
		esac
	done
}

s_l_f(){
	if [ -f "${add}/$1" ]; then
		echo
		echo " ---------------------------------------------------"
		printf " $1 has this content:\\n\\n"
		echo " START FILE, --- lines are not part of file"
		echo " ---------------------------------------------------"
		sed -e 's/^/ /' "${add}/$1"
		echo " ---------------------------------------------------"
		echo " END FILE"
		echo
		p_e_l
		while true; do
			printf " Delete log file now? [1=Yes e=Exit] ";read -r continue
			case "$continue" in
				1)		rm "${add}/$1"
						show_amtm " $1 deleted"
						break;;
				[Ee])	show_amtm menu;break;;
				*)		printf "\\n input is not an option\\n\\n";;
			esac
		done
	else
		show_amtm " No $1 found"
	fi
}

script_check(){
	atii=1
	[ "$localVother" ] && localver=$localVother || localver="$(grep "$scriptgrep" "$scriptloc" | grep -m1 -oE 'v[0-9]{1,2}([.][0-9]{1,2})([.][0-9]{1,2})')"
	upd="${E_BG}${NC}$localver"
	if [ "$su" = 1 ]; then
		if c_url "$remoteurl" | grep -qF -m1 "$grepcheck"; then
			[ "$remoteVother" ] && remotever=$remoteVother || remotever="$(c_url "$remoteurl" | grep -m1 "$scriptgrep" | grep -oE 'v[0-9]{1,2}([.][0-9]{1,2})([.][0-9]{1,2})')"
			upd="${GN_BG}no upd${NC}"
			bareLocalver=$(echo $localver | sed 's/[^0-9]*//g')
			bareRemotever=$(echo $remotever | sed 's/[^0-9]*//g')
			upd="${GN_BG}$localver${NC}"
			if [ "$bareLocalver" -gt "$bareRemotever" ]; then
				upd="${E_BG}<- $remotever${NC}"
				[ "$tpu" ] && echo "- $scriptname $localver <- $remotever <br>" >>/tmp/amtm-tpu-check
				suUpd=1
			elif [ "$bareLocalver" -lt "$bareRemotever" ]; then
				upd="${E_BG}-> $remotever${NC}"
				[ "$tpu" ] && echo "- $scriptname $localver -> $remotever <br>" >>/tmp/amtm-tpu-check
				suUpd=1
			else
				localmd5="$(md5sum "$scriptloc" | awk '{print $1}')"
				remotemd5="$(c_url "$remoteurl" | md5sum | awk '{print $1}')"
				if [ "$localmd5" != "$remotemd5" ]; then
					upd="${E_BG}-> min upd${NC}"
					[ "$tpu" ] && echo "- $scriptname $localver minor update available <br>" >>/tmp/amtm-tpu-check
					suUpd=1
				else
					localver=
				fi
			fi
		else
			upd=" ${E_BG}upd err${NC}"
			updErr=1
		fi
	else
		localver=
	fi
	unset localVother remoteVother bareLocalver bareRemotever localmd5 remotemd5
}

reset_amtm(){
	p_e_l
	echo " Do you want to reset amtm settings now?"
	echo
	echo " Note that resetting amtm will not remove or"
	echo " uninstall any installed SNBForum scripts."
	echo
	echo " However, it will remove the Disk check"
	echo " script and log, the Format disk log and the"
	echo " reboot scheduler when found."
	c_d
	if [ -f "${add}"/disk-check ]; then
		sed -i '\~disk-check ~d' /jffs/scripts/pre-mount
		r_w_e /jffs/scripts/pre-mount
	fi
	if [ -f /jffs/scripts/init-start ] && grep -qE "amtm_RebootScheduler" /jffs/scripts/init-start; then
		sed -i '\~amtm_RebootScheduler~d' /jffs/scripts/init-start
		r_w_e /jffs/scripts/init-start
		cru d amtm_RebootScheduler
	fi
	rm -rf "${add}"
	clear
	ascii_logo "  amtm settings reset"
	echo
	echo "   Goodbye!"
	echo
	exit 0
}

update_amtm(){
	urlNOK=
	if ! c_url "$amtmURL/amtm.mod" | grep -q "^version="; then
		urlNOK=1
		f_b_url
	fi
	if [ "$urlNOK" ] && ! c_url "$amtmURL/amtm.mod" | grep -q "^version="; then
		if [ "$su" = 1 ]; then
			updErr=1
			thisrem=" ${E_BG}upd err${NC}"
			amtmUpd=0
		else
			a_m " Update aborted, could not retrieve version"
			show_amtm menu
		fi
	else
		urlNOK=
	fi
	dfc=
	if [ -z "$urlNOK" ]; then
		amtmRemotever="$(c_url "$amtmURL/amtm.mod" | grep "^version=" | sed -e 's/version=//')"
		localmd5="$(md5sum "${add}"/a_fw/amtm.mod | awk '{print $1}')"
		remotemd5="$(c_url "$amtmURL/amtm.mod" | md5sum | awk '{print $1}')"

		if [ "$su" = 1 ]; then
			if [ "$version" != "$amtmRemotever" ]; then
				thisrem="${E_BG}-> v$amtmRemotever${NC}"
				amtmUpd=1
			elif [ "$localmd5" != "$remotemd5" ]; then
				thisrem="${E_BG}-> min upd${NC}"
				amtmUpd=2
			else
				thisrem="${GN_BG}v$version${NC}"
				amtmUpd=0
			fi
		else
			if [ "$version" != "$amtmRemotever" ]; then
				a_m " amtm updated from v$version to v$amtmRemotever"
			elif [ "$localmd5" != "$remotemd5" ]; then
				a_m " amtm minor version update applied"
			else
				a_m " amtm force updated to v$amtmRemotever"
			fi
			g_i_m "${add}"
			exec "$0" "$am"
		fi
	fi
}
#eof
