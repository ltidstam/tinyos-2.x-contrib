
/*
 * Copyright (c) 2007, Vanderbilt University
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the copyright holder nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL
 * THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */
 
 /**
 * @author Miklos Maroti
 * @author Martin Cerveny
 */

#include <RadioConfig.h>

configuration HplRF230C
{
	provides
	{
		interface GeneralIO as SELN;
		interface Resource as SpiResource;
		interface FastSpiByte;

		interface GeneralIO as SLP_TR;
		interface GeneralIO as RSTN;

		interface GpioCapture as IRQ;
		interface Alarm<TRadio, uint16_t> as Alarm;
		interface LocalTime<TRadio> as LocalTimeRadio;
	}
}

implementation
{
	components HplRF230P;
	IRQ = HplRF230P.IRQ;

	HplRF230P.PortTST -> IO.PortB0;
	HplRF230P.PortIRQ -> IO.PortD6;
	
	components Atm128SpiC as SpiC;
	SpiResource = SpiC.Resource[unique("Atm128SpiC.Resource")];
	FastSpiByte = SpiC;

	components HplAtm128GeneralIOC as IO;
	SLP_TR = IO.PortB3;
	RSTN = IO.PortB1;
	SELN = IO.PortB4;

	components HplAtm128Timer1C as TimerC;
	HplRF230P.Capture -> TimerC.Capture;

	components new AlarmOne16C() as AlarmC;
	Alarm = AlarmC;

	components RealMainP;
	RealMainP.PlatformInit -> HplRF230P.PlatformInit;

	components LocalTimeMicroC;
	LocalTimeRadio = LocalTimeMicroC;
}