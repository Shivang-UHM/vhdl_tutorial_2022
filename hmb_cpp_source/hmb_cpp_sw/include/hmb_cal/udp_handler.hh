#pragma once

#include "lwip/err.h"
#include "lwip/udp.h"
#include "netif/xadapter.h"
#include <exception>
#include <functional>
#include <string>

#define LWIP_UDP   1


typedef err_t (*tcp_recv_fn1)         (void *arg, struct tcp_pcb *tpcb, struct pbuf *p, err_t err);
typedef void (*udp_cmd_recv_function)(void *arg, struct udp_pcb *pcb, struct pbuf *p, const ip_addr_t *addr, u16_t port);

netif *get_netif();


struct ip_address_t{
	int addr0,addr1,addr2,addr3;
};
class udp_handler;
class tcp_pcb;

using cstring_r = const std::string&;
using receiver_handler_f = std::function<void (udp_handler&, cstring_r)>;

class udp_handler{
	udp_pcb *pcb_cmd;
	udp_pcb *pcb_data;
	pbuf *buf_data;
	pbuf *buf_cmd;

public:
	size_t Max_length=100;
	tcp_pcb *tpcb;
	pbuf *p;
	err_t err;

	void  write( cstring_r data );
	receiver_handler_f m_fun;
	udp_handler(ip_address_t board_ip , uint16_t port, receiver_handler_f fun);

	void run();


};
