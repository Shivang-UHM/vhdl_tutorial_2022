#pragma once



class targetc{

public:
	targetc(int* reg);
	void ControlRegisterWrite(int mask, int actionID);
	void get_status();
	void initTARGETregisters();
	void testPattern();


	void PS_disable_busy_mask();
	void PS_enable_busy_mask();

	void set_sample_mode(bool  status);
	void Testpattern_mode_disable();
	void Testpattern_mode_enable();

	void set_Running_mode_to_user_mode();
	void set_Running_mode_to_trigger_mode();

	void reset();
	int * m_reg = nullptr;

};
