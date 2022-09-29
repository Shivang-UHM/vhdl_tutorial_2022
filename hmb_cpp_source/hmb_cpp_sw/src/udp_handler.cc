
#include "/home1/shivang/github/HMB_CalRDout/hmb_cpp_source/hmb_cpp_sw/include/hmb_cal/udp_handler.hh"
#include </home1/shivang/github/HMB_CalRDout/hmb_cpp_source/hmb_cpp_sw/include/hmb_cal/platform_config.hh>
#include "lwip/init.h"
#include <iostream>
#include "xscugic.h"
#include "lwip/priv/tcp_priv.h"
#include "xscutimer.h"

#define TIMER_IRPT_INTR				XPAR_SCUTIMER_INTR
#define TIMER_DEVICE_ID				XPAR_SCUTIMER_DEVICE_ID
#define INTC_BASE_ADDR				XPAR_SCUGIC_0_CPU_BASEADDR
#define INTC_DIST_BASE_ADDR			XPAR_SCUGIC_0_DIST_BASEADDR
#define INTC_DEVICE_ID				XPAR_SCUGIC_SINGLE_DEVICE_ID

#define RESET_RX_CNTR_LIMIT			400
#define XIL_EXCEPTION_ID_IRQ_INT	5U

static XScuTimer TimerScuInstance;
volatile int TcpFastTmrFlag = 0;
volatile int TcpSlowTmrFlag = 0;


int ResetRxCntr = 0;

tcp_recv_fn1 g_fun;

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


void timer_callback(XScuTimer * TimerInstance)
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

netif *get_netif() {
    static netif ret;
    return &ret;
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

	auto handler  = (udp_handler*)arg;
	handler->err = err;
	handler->p = p;
	handler->tpcb = tpcb;

    if (p->len > handler->Max_length){
    	return ERR_OK;
    }
	handler->m_fun(*handler, {(char *)p->payload, p->len});
	/* indicate that the packet has been received */
	tcp_recved(tpcb, p->len);

	/* echo back the payload */
	/* in this case, we assume that the payload is < TCP_SND_BUF */


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
	tcp_arg(newpcb, (void*)arg);

	/* increment for subsequent accepted connections */
	connection++;

	return ERR_OK;
}

int start_application(udp_handler* handler)
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
	tcp_arg(pcb, (void*)handler);

	/* listen for connections */
	pcb = tcp_listen(pcb);
	if (!pcb) {
		xil_printf("Out of memory while tcp_listen\n\r");
		return -3;
	}

	/* specify callback to use for incoming connections */
	tcp_accept(pcb, accept_callback);

	xil_printf("TCP server started @ port %d\n\r", port);

	return 0;
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

udp_handler::udp_handler(ip_address_t board_ip,  uint16_t port, receiver_handler_f fun):
m_fun(std::move(fun))
{

	ip_addr_t ipaddr, netmask, gw;

	unsigned char mac_ethernet_address[] =
	{ 0x00, 0x0a, 0x35, 0x00, 0x01, 0x02 };
	struct netif *echo_netif;
	echo_netif = get_netif();

	init_platform();


	/* initialize IP addresses to be used */
	IP4_ADDR(&ipaddr, board_ip.addr0, board_ip.addr1, board_ip.addr2, board_ip.addr3);
	IP4_ADDR(&netmask, 255, 255, 255,  0);
	IP4_ADDR(&gw,      192, 168,   1,  1);



	lwip_init();


	/* Add network interface to the netif_list, and set it as default */
	if (!xemac_add(echo_netif, &ipaddr, &netmask,
						&gw, mac_ethernet_address,
						PLATFORM_EMAC_BASEADDR)) {
		xil_printf("Error adding N/W interface\n\r");
		return ;
	}

	netif_set_default(echo_netif);

	/* now enable interrupts */
	platform_enable_interrupts();

	/* specify that the network if is up */
	netif_set_up(echo_netif);


	start_application(this);

	}

void udp_handler::run(){

	while (1) {
		if (TcpFastTmrFlag) {
			tcp_fasttmr();
			TcpFastTmrFlag = 0;
		}
		if (TcpSlowTmrFlag) {
			tcp_slowtmr();
			TcpSlowTmrFlag = 0;
		}
		xemacif_input(get_netif());
//		transfer_data();
	}

}

void  udp_handler::write( cstring_r data ){
	std::cout << "max length: "<< tcp_sndbuf(tpcb) << std::endl;
	if (tcp_sndbuf(tpcb) > data.size()) {
		err = tcp_write(tpcb, data.data(), data.size(), 1);
	} else
		xil_printf("no space in tcp_sndbuf\n\r");
}
