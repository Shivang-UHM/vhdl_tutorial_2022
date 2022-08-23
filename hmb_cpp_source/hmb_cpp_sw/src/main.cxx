

#include <hmb_cal/platform_config.hh>
#include <iostream>
#include <string>
#include "xparameters.h"
#include "xscugic.h"
#include "hmb_cal/udp_handler.hh"
#include "lwip/init.h"
#include "hmb_cal/platform_config.hh"
#include <future>
#include<thread>









#include "xparameters.h"
#include "xparameters_ps.h"	/* defines XPAR values */
#include "xil_cache.h"
#include "xscugic.h"
#include "lwip/tcp.h"
#include "lwip/priv/tcp_priv.h"
#include "xil_printf.h"

#include "netif/xadapter.h"
#include "xparameters.h"
#include "xscutimer.h"
#include "xttcps.h"

#include "xscuwdt.h"


#include "xtime_l.h"

#include <stdio.h>

#include "xparameters.h"

#include "netif/xadapter.h"



#if defined (__arm__) || defined(__aarch64__)
#include "xil_printf.h"
#endif

#include "lwip/tcp.h"
#include "xil_cache.h"



//XPAR_MY_AXI4_LITE_EXPORTER_0_S00_AXI_BASEADDR
//XPAR_AXI4LITE_TO_GPIO_0_S00_AXI_BASEADDR

//my_axi4_lite_exporter axi_lite_exp = my_axi4_lite_exporter(XPAR_MY_AXI4_LITE_EXPORTER_0_S00_AXI_BASEADDR);
/** @brief Port used for the data packet transmission */
#define PORT_DATA		10022
/*
#ifndef USE_SOFTETH_ON_ZYNQ
static int ResetRxCntr = 0;
#endif


static XScuTimer TimerScuInstance;
struct netif *echo_netif;
/****************************************************************************/
/**
* @brief	Callback for the timer scu
*
* @param	TimerInstance: pointer on the timer's instance
*
* @return	None
*
* @note		This callback is called every 250ms
*
****************************************************************************/
//void timer_scu_callback(XScuTimer * TimerInstance)
//{
//	count_scu_timer++;
//	flag_scu_timer = true;
//
//#ifndef USE_SOFTETH_ON_ZYNQ
//	/* For providing an SW alternative for the SI #692601. Under heavy
//	 * Rx traffic if at some point the Rx path becomes unresponsive, the
//	 * following API call will ensures a SW reset of the Rx path. The
//	 * API xemacpsif_resetrx_on_no_rxdata is called every 100 milliseconds.
//	 * This ensures that if the above HW bug is hit, in the worst case,
//	 * the Rx path cannot become unresponsive for more than 100
//	 * milliseconds.
//	 *
//	 * PROBLEM : this function should be called every 100ms, but in fact with a counter
//	 * of 400, it is called every 100s (original soft)
//	 */
//	ResetRxCntr++;
//	if (ResetRxCntr >= RESET_RX_CNTR_LIMIT) {
//		xemacpsif_resetrx_on_no_rxdata(echo_netif);
//		ResetRxCntr = 0;
//	}
//	//xemacpsif_resetrx_on_no_rxdata(echo_netif); // Now the function is called every 250ms
//#endif
//
//	// Need to call this function every 250ms, but not before the network is set
//	if(flag_while_loop) xemacif_input(echo_netif);
//	if(!flag_while_loop) XScuWdt_RestartWdt(&WdtScuInstance);	// Reload the counter for the wdt
//
//	// Clear timer's interrupt
//	XScuTimer_ClearInterruptStatus(TimerInstance);
//}
//


int count_scu_timer =0;
bool flag_scu_timer = false;
int ResetRxCntr = 0;
bool flag_while_loop = false;


void timer_scu_callback(XScuTimer * TimerInstance)
{
	count_scu_timer++;
	flag_scu_timer = true;



	// Need to call this function every 250ms, but not before the network is set
	if(flag_while_loop) xemacif_input(get_netif());
	//if(!flag_while_loop) XScuWdt_RestartWdt(&WdtScuInstance);	// Reload the counter for the wdt

	// Clear timer's interrupt
	XScuTimer_ClearInterruptStatus(TimerInstance);
}
#define INTC_BASE_ADDR		XPAR_SCUGIC_0_CPU_BASEADDR
#define TIMER_IRPT_INTR		XPAR_SCUTIMER_INTR
static XScuTimer TimerScuInstance;


#define TIMER_DEVICE_ID		XPAR_SCUTIMER_DEVICE_ID
void platform_setup_timer(void)
{
	int Status = XST_SUCCESS;
	XScuTimer_Config *ConfigPtr;
	int TimerLoadValue = 0;

	ConfigPtr = XScuTimer_LookupConfig(TIMER_DEVICE_ID);
	Status = XScuTimer_CfgInitialize(&TimerScuInstance, ConfigPtr,
			ConfigPtr->BaseAddr);
	if (Status != XST_SUCCESS) {

		xil_printf("In %s: Scutimer Cfg initialization failed...\r\n",
		__func__);
		return;
	}

	Status = XScuTimer_SelfTest(&TimerScuInstance);
	if (Status != XST_SUCCESS) {
		xil_printf("In %s: Scutimer Self test failed...\r\n",
		__func__);
		return;

	}

	XScuTimer_EnableAutoReload(&TimerScuInstance);
	/*
	 * Set for 250 milli seconds timeout.
	 */
	TimerLoadValue = XPAR_CPU_CORTEXA9_0_CPU_CLK_FREQ_HZ / 8;

	XScuTimer_LoadTimer(&TimerScuInstance, TimerLoadValue);
	return;
}
#define XIL_EXCEPTION_ID_IRQ_INT		5U
#define INTC_DEVICE_ID		XPAR_SCUGIC_SINGLE_DEVICE_ID
#define INTC_BASE_ADDR		XPAR_SCUGIC_0_CPU_BASEADDR
#define TIMER_IRPT_INTR		XPAR_SCUTIMER_INTR
#define RESET_RX_CNTR_LIMIT	400

#define INTC_DIST_BASE_ADDR	XPAR_SCUGIC_0_DIST_BASEADDR
volatile int TcpFastTmrFlag = 0;
volatile int TcpSlowTmrFlag = 0;

void
timer_callback(XScuTimer * TimerInstance)
{
	/* we need to call tcp_fasttmr & tcp_slowtmr at intervals specified
	 * by lwIP. It is not important that the timing is absoluetly accurate.
	 */
	static int odd = 1;
	 TcpFastTmrFlag = 1;

	odd = !odd;


	ResetRxCntr++;

	if (odd) {
		TcpSlowTmrFlag = 1;
	}

	/* For providing an SW alternative for the SI #692601. Under heavy
	 * Rx traffic if at some point the Rx path becomes unresponsive, the
	 * following API call will ensures a SW reset of the Rx path. The
	 * API xemacpsif_resetrx_on_no_rxdata is called every 100 milliseconds.
	 * This ensures that if the above HW bug is hit, in the worst case,
	 * the Rx path cannot become unresponsive for more than 100
	 * milliseconds.
	 */


	if (ResetRxCntr >= RESET_RX_CNTR_LIMIT) {
		xemacpsif_resetrx_on_no_rxdata(get_netif());
		ResetRxCntr = 0;
	}

	XScuTimer_ClearInterruptStatus(TimerInstance);
}

void platform_setup_interrupts(void)
{
	Xil_ExceptionInit();

	XScuGic_DeviceInitialize(INTC_DEVICE_ID);

	/*
	 * Connect the interrupt controller interrupt handler to the hardware
	 * interrupt handling logic in the processor.
	 */
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_IRQ_INT,
			(Xil_ExceptionHandler)XScuGic_DeviceInterruptHandler,
			(void *)INTC_DEVICE_ID);
	/*
	 * Connect the device driver handler that will be called when an
	 * interrupt for the device occurs, the handler defined above performs
	 * the specific interrupt processing for the device.
	 */
	XScuGic_RegisterHandler(INTC_BASE_ADDR, TIMER_IRPT_INTR,
					(Xil_ExceptionHandler)timer_callback,
					(void *)&TimerScuInstance);
	/*
	 * Enable the interrupt for scu timer.
	 */
	XScuGic_EnableIntr(INTC_DIST_BASE_ADDR, TIMER_IRPT_INTR);

	return;
}

void init_platform()
{
	platform_setup_timer();
	platform_setup_interrupts();

	return;
}
void print_app_header()
{
#if (LWIP_IPV6==0)
	xil_printf("\n\r\n\r-----lwIP TCP echo server ------\n\r");
#else
	xil_printf("\n\r\n\r-----lwIPv6 TCP echo server ------\n\r");
#endif
	xil_printf("TCP packets sent to port 6001 will be echoed back\n\r");
}


void platform_enable_interrupts()
{
	/*
	 * Enable non-critical exceptions.
	 */
	Xil_ExceptionEnableMask(XIL_EXCEPTION_IRQ);
	XScuTimer_EnableInterrupt(&TimerScuInstance);
	XScuTimer_Start(&TimerScuInstance);
	return;
}


void
print_ip(char *msg, ip_addr_t *ip)
{
	print(msg);
	xil_printf("%d.%d.%d.%d\n\r", ip4_addr1(ip), ip4_addr2(ip),
			ip4_addr3(ip), ip4_addr4(ip));
}


void
print_ip_settings(ip_addr_t *ip, ip_addr_t *mask, ip_addr_t *gw)
{

	print_ip("Board IP: ", ip);
	print_ip("Netmask : ", mask);
	print_ip("Gateway : ", gw);
}
err_t recv_callback(void *arg, struct tcp_pcb *tpcb,
                               struct pbuf *p, err_t err)
{
	xil_printf("recv_callback\n\r");
	/* do not read the packet if we are not in ESTABLISHED state */
	if (!p) {
		tcp_close(tpcb);
		tcp_recv(tpcb, NULL);
		return ERR_OK;
	}

	/* indicate that the packet has been received */
	tcp_recved(tpcb, p->len);

	/* echo back the payload */
	/* in this case, we assume that the payload is < TCP_SND_BUF */
	if (tcp_sndbuf(tpcb) > p->len) {
		err = tcp_write(tpcb, p->payload, p->len, 1);
	} else
		xil_printf("no space in tcp_sndbuf\n\r");

	/* free the received pbuf */
	pbuf_free(p);

	return ERR_OK;
}

err_t accept_callback(void *arg, struct tcp_pcb *newpcb, err_t err)
{
	static int connection = 1;
	xil_printf("accept_callback\n\r");

	/* set the receive callback for this connection */
	tcp_recv(newpcb, recv_callback);

	/* just use an integer number indicating the connection id as the
	   callback argument */
	tcp_arg(newpcb, (void*)(UINTPTR)connection);

	/* increment for subsequent accepted connections */
	connection++;

	return ERR_OK;
}

int start_application()
{
	struct tcp_pcb *pcb;
	err_t err;
	unsigned port = 7;

	/* create new TCP PCB structure */
	pcb = tcp_new_ip_type(IPADDR_TYPE_ANY);
	if (!pcb) {
		xil_printf("Error creating PCB. Out of Memory\n\r");
		return -1;
	}

	/* bind to specified @port */
	err = tcp_bind(pcb, IP_ANY_TYPE, port);
	if (err != ERR_OK) {
		xil_printf("Unable to bind to port %d: err = %d\n\r", port, err);
		return -2;
	}

	/* we do not need any arguments to callback functions */
	tcp_arg(pcb, NULL);

	/* listen for connections */
	pcb = tcp_listen(pcb);
	if (!pcb) {
		xil_printf("Out of memory while tcp_listen\n\r");
		return -3;
	}

	/* specify callback to use for incoming connections */
	tcp_accept(pcb, accept_callback);

	xil_printf("TCP echo server started @ port %d\n\r", port);

	return 0;
}

int echo_server() {
	ip_addr_t ipaddr, netmask, gw;
		/* the mac address of the board. this should be unique per board */
		unsigned char mac_ethernet_address[] =
		{ 0x00, 0x0a, 0x35, 0x00, 0x01, 0x02 };
		struct netif *echo_netif;
		echo_netif = get_netif();

		init_platform();


		/* initialize IP addresses to be used */
		IP4_ADDR(&ipaddr,  192, 168,   1, 10);
		IP4_ADDR(&netmask, 255, 255, 255,  0);
		IP4_ADDR(&gw,      192, 168,   1,  1);

		print_app_header();

		lwip_init();


		/* Add network interface to the netif_list, and set it as default */
		if (!xemac_add(echo_netif, &ipaddr, &netmask,
							&gw, mac_ethernet_address,
							PLATFORM_EMAC_BASEADDR)) {
			xil_printf("Error adding N/W interface\n\r");
			return -1;
		}

		netif_set_default(echo_netif);

		/* now enable interrupts */
		platform_enable_interrupts();

		/* specify that the network if is up */
		netif_set_up(echo_netif);



		print_ip_settings(&ipaddr, &netmask, &gw);


		/* start the application (web server, rxtest, txtest, etc..) */
		start_application();

		/* receive and process packets */
		while (1) {
			if (TcpFastTmrFlag) {
				tcp_fasttmr();
				TcpFastTmrFlag = 0;
			}
			if (TcpSlowTmrFlag) {
				tcp_slowtmr();
				TcpSlowTmrFlag = 0;
			}
			xemacif_input(echo_netif);
	//		transfer_data();
		}


}
int main(){

	xil_printf("echo_server\n\r");
	echo_server();

	lwip_init();
	platform_setup_timer();
	platform_setup_interrupts();
	XScuGic_RegisterHandler(INTC_BASE_ADDR, TIMER_IRPT_INTR,
					(Xil_ExceptionHandler)timer_scu_callback,
					(void *)&TimerScuInstance);


	auto udp_h = udp_handler(
			{192, 168, 1, 10},
			{192, 168, 1, 11},
			PORT_DATA,
			[](void *arg, struct udp_pcb *pcb, struct pbuf *p, const ip_addr_t *addr, u16_t port){
				std::cout <<"receiving data" << std::endl;
				char *payload = (char *)p->payload;
			    uint16_t length = p->len;

			    for (int i = 0 ; i < length ; ++i){
			    	std::cout << payload[i] << std::endl;
			    }

	} );

	flag_while_loop = true;

	int buffer;
	int addr =0;
	while(1){
		std::cout <<  "what addr?\n" ;
		std::cin >> addr;
		std::cout << "addr: " << addr <<"\n";
		if (addr == 1000){
			for (int i =0; i <4000 ;++i){
				Xil_Out32(XPAR_MY_AXI4_LITE_EXPORTER_0_S00_AXI_BASEADDR +4, i);
				auto data_out  =  Xil_In32( XPAR_MY_AXI4_LITE_EXPORTER_0_S00_AXI_BASEADDR + 8);
				std::cout << i << "  " << data_out <<"\n";
			}
		}else {


			addr <<= 16;

			std::cout << "what value:?\n";
			std::cin >> buffer;

			std::cout << "value: " << buffer <<"\n ";


			Xil_Out32(XPAR_MY_AXI4_LITE_EXPORTER_0_S00_AXI_BASEADDR, addr + buffer);

			//std::cout << "Command Read back: "<< Xil_In32( XPAR_MY_AXI4_LITE_EXPORTER_0_S00_AXI_BASEADDR + addr) << "\n";
		}

	}
	return 0;
}

