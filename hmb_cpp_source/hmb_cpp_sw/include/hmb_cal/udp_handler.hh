#pragma once

#include "lwip/udp.h"
#include "netif/xadapter.h"
#include <exception>
#include "lwip/init.h"


typedef void (*udp_cmd_recv_function)(void *arg, struct udp_pcb *pcb, struct pbuf *p, const ip_addr_t *addr, u16_t port);

netif *get_netif() {
    static netif ret;
    return &ret;
}

struct ip_address_t{
	int addr0,addr1,addr2,addr3;
};


class udp_handler{
	udp_pcb *pcb_cmd;

public:
	udp_handler(ip_address_t board_ip , ip_address_t pc_ipaddr_in , uint16_t port, udp_cmd_recv_function fun){
		 ip_addr_t ipaddr, netmask, gw;
		unsigned char mac_ethernet_address[] = {0x00, 0x0a, 0x35, 0x00, 0x01, 0x02};
		ipaddr.addr = 0;
		gw.addr = 0;
		netmask.addr = 0;
		auto r = ::xemac_add(get_netif(), &ipaddr, &netmask, &gw, mac_ethernet_address, XPAR_XEMACPS_0_BASEADDR);
		if (!r) {
			throw  std::runtime_error("Error adding N/W interface");

		}

		::netif_set_default(get_netif());
		::netif_set_up(get_netif());
		IP4_ADDR(&(get_netif()->ip_addr), board_ip.addr0, board_ip.addr1, board_ip.addr2, board_ip.addr3);
		IP4_ADDR(&(get_netif()->netmask), 255, 255, 255, 0);
		IP4_ADDR(&(get_netif()->netmask), 192, 168, 1, 1);



		ip_addr_t pc_ipaddr{};
        IP4_ADDR(&pc_ipaddr, pc_ipaddr_in.addr0, pc_ipaddr_in.addr1, pc_ipaddr_in.addr2, pc_ipaddr_in.addr3);
    	lwip_init();


		pcb_cmd = udp_new_ip_type(IPADDR_TYPE_ANY);
		if (!pcb_cmd) {
		    throw std::runtime_error("Error creating PCB. Out of Memory\n\r");

		}

		auto err = udp_bind(pcb_cmd, IP_ANY_TYPE, port);
		if (err != ERR_OK) {
			throw std::runtime_error("Unable to bind port:\n\r");
		}

		err = udp_connect(pcb_cmd, &pc_ipaddr, port);
		if (err != ERR_OK) {
			throw std::runtime_error("Unable to bind IP address:\n\r");
		}

		udp_recv(pcb_cmd, fun, NULL);

	}


};
