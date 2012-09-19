/*
 * CC Bootloader - Hardware Abstraction Layer 
 *
 * Fergus Noble (c) 2011
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 2 of the License.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
 */

#ifndef _HAL_H_
#define _HAL_H_

// enable RFCAT and dongle version to build custom RFCAT version
// http://code.google.com/p/rfcat/
// this would normally be done in the Makefile
//#define RFCAT
//#define RFCAT_DONSDONGLE
//#define RFCAT_CHRONOS

#ifdef RFCAT_CHRONOS
  #define LED 		P1_0
  #define LED_MASK	1
  #define USB_ENABLE	P1_1
  #define USB_MASK	2
#else
  #define LED 		P1_1
  #define LED_MASK	2
  #define USB_ENABLE	P1_0
  #define USB_MASK	1
#endif

void setup_led();
void led_on();
void led_off();
void setup_button();

void usb_up();
void usb_down();

#define CC1111EM_BUTTON 	P1_2
#define CC1111CHRONOS_PIN_DC 	P2_2
#define BUTTON_PRESSED  	0
#define GROUNDED		0
#endif // _HAL_H_
