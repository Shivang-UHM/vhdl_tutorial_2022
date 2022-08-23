#pragma once


#include <exception>
#include <stdexcept>

#include <string>

#define HMB_EXCEPTION(message) std::runtime_error( std::string(message) + std::string("\r\nfrom file: ") + std::string( __FILE__) +std::string("\r\nLine: ") + std::to_string(__LINE__) + std::string("\r\nEnd Error.\r\n") )

#define throw_if(x) if (x) throw
