#!/usr/bin/env bats
source ../tests_lib

#-----------------------------------------------------
# 	ТЕСТЫ из библиотеки kvas_lib_vpn ОБЩИЕ
#-----------------------------------------------------
TEST_NoN_IPv6_INTERFACE=Wireguard0
TEST_IPv6_INTERFACE=OpenVPN0
TEST_NOT_EXIST_INTERFACE=Wireguard8
TEST_EXIST_INTERFACE=OpenVPN0

@test "Проверка наличия файла справки [cmd_help]" {
	cmd="cmd_help"
	run on_server "${lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 0 ]

	#	Блок проверок то, что точно должно быть при нормальной работе скрипта
	[ "$(echo "${output}" | grep -c "")" -gt 1 ]

}

@test "Проверка верности получения данных по заданному интерфейсу [get_value_interface_field]" {
	cmd="get_value_interface_field Wireguard0 connected"
	run on_server "${lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 0 ]

	#	Блок проверок то, что точно должно быть при нормальной работе скрипта
	echo "${output}" | grep -qE "(no|yes)"

}
@test "Проверка получения интерфейса по умолчанию через который идут в инетернет [get_defaultgw_interface]" {
	cmd="get_defaultgw_interface"
	run on_server "${lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 0 ]

	#	Блок проверок то, что точно должно быть при нормальной работе скрипта
	[ -n "${output}" ]
}


@test "Проверка исполнения команды по подключению IPv6 интерфейса [ipv6_inface_on]" {
	cmd="ipv6_inface_on ${TEST_IPv6_INTERFACE}"
	run on_server "${lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 0 ]

	#	Блок проверок то, что точно должно быть при нормальной работе скрипта
	echo "${output}" | grep -q "УСПЕШНО"

}

@test "Проверка исполнения команды по отключению IPv6 интерфейса [ipv6_inface_off]" {
	cmd="ipv6_inface_off ${TEST_IPv6_INTERFACE}"
	run on_server "${lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 0 ]

	#	Блок проверок то, что точно должно быть при нормальной работе скрипта
	echo "${output}" | grep -q "УСПЕШНО"

}

@test "Проверка статуса IPv6 интерфейса: ON [ipv6_inface_on]" {
	cmd="ipv6_inface_on ${TEST_IPv6_INTERFACE}"
	run on_server "${lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
	cmd="ipv6_status ${TEST_IPv6_INTERFACE}"
	run on_server "${lib_load} && ${cmd}"
	print_on_error "${status}" "${output}"
	#	Блок проверок то, что точно должно быть при нормальной работе скрипта
	echo "${output}" | grep -q "0"
}
@test "Проверка статуса IPv6 интерфейса: OFF [ipv6_inface_on]" {

	cmd="ipv6_inface_off ${TEST_NoN_IPv6_INTERFACE}"
	run on_server "${lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
	cmd="ipv6_status ${TEST_NoN_IPv6_INTERFACE}"
	run on_server "${lib_load} && ${cmd}"
	print_on_error "${status}" "${output}"
	#	Блок проверок то, что точно должно быть при нормальной работе скрипта
	echo "${output}" | grep -q "1"

}

@test "Проверка статуса IPv6 интерфейса: НЕ СОВМЕСТИМ [ipv6_inface_on]" {

	cmd="ipv6_inface_off ${TEST_NoN_IPv6_INTERFACE}"
	run on_server "${lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
	cmd="ipv6_status ${TEST_NoN_IPv6_INTERFACE}"
	run on_server "${lib_load} && ${cmd}"
	print_on_error "${status}" "${output}"
	#	Блок проверок то, что точно должно быть при нормальной работе скрипта
	echo "${output}" | grep -q "2"

}
@test "Проверка статуса IPv6 интерфейса: НЕ ЗАДАН ИНТЕРФЕЙС [ipv6_inface_on]" {

	cmd="ipv6_status"
	run on_server "${lib_load} && ${cmd}"
	print_on_error "${status}" "${output}"
	#	Блок проверок то, что точно должно быть при нормальной работе скрипта
	echo "${output}" | grep -q "Не задан интерфейс"

}
TEST_NOT_EXIST_INTERFACE=Wireguard8
TEST_EXIST_INTERFACE=OpenVPN0

@test "Проверка наличия интерфейса ${TEST_EXIST_INTERFACE} CLI в системе [is_cli_inface_present]" {
	cmd="is_cli_inface_present ${TEST_EXIST_INTERFACE}"
	run on_server "${lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 0 ]

}
@test "Проверка отсуствия интерфейса ${TEST_NOT_EXIST_INTERFACE} CLI в системе [is_cli_inface_present]" {
	cmd="is_cli_inface_present ${TEST_NOT_EXIST_INTERFACE}"
	run on_server "${lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 1 ]

}
@test "Проверка отсуствия интерфейса в качастве аргумента [is_cli_inface_present]" {
	cmd="is_cli_inface_present"
	run on_server "${lib_load} && ${cmd}"
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 0 ]
	echo "${output}" | grep -q "Не задан интерфейс"

}
