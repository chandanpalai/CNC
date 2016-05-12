/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0x8ef4fb42 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "E:/IS/CNC/UART.vhd";



static void work_a_2239630122_3212880686_p_0(char *t0)
{
    unsigned char t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    unsigned char t6;
    unsigned char t7;
    char *t8;
    int t9;
    unsigned char t10;
    char *t11;
    unsigned char t12;
    char *t13;
    char *t14;
    unsigned char t15;
    unsigned char t16;
    char *t17;
    char *t18;
    char *t19;
    char *t20;
    int t21;
    int t22;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    static char *nl0[] = {&&LAB12, &&LAB13, &&LAB14};

LAB0:    xsi_set_current_line(58, ng0);
    t2 = (t0 + 752U);
    t3 = xsi_signal_has_event(t2);
    if (t3 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB2;

LAB4:
LAB3:    t2 = (t0 + 2596);
    *((int *)t2) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(59, ng0);
    t4 = (t0 + 1776U);
    t8 = *((char **)t4);
    t9 = *((int *)t8);
    t10 = (t9 == 5208);
    if (t10 != 0)
        goto LAB8;

LAB10:    xsi_set_current_line(83, ng0);
    t2 = (t0 + 1776U);
    t4 = *((char **)t2);
    t9 = *((int *)t4);
    t21 = (t9 + 1);
    t2 = (t0 + 1776U);
    t5 = *((char **)t2);
    t2 = (t5 + 0);
    *((int *)t2) = t21;

LAB9:    goto LAB3;

LAB5:    t4 = (t0 + 776U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)2);
    t1 = t7;
    goto LAB7;

LAB8:    xsi_set_current_line(60, ng0);
    t4 = (t0 + 1512U);
    t11 = *((char **)t4);
    t12 = *((unsigned char *)t11);
    t4 = (char *)((nl0) + t12);
    goto **((char **)t4);

LAB11:    xsi_set_current_line(81, ng0);
    t2 = (t0 + 1776U);
    t4 = *((char **)t2);
    t2 = (t4 + 0);
    *((int *)t2) = 0;
    goto LAB9;

LAB12:    xsi_set_current_line(62, ng0);
    t13 = (t0 + 592U);
    t14 = *((char **)t13);
    t15 = *((unsigned char *)t14);
    t16 = (t15 == (unsigned char)2);
    if (t16 != 0)
        goto LAB15;

LAB17:
LAB16:    goto LAB11;

LAB13:    xsi_set_current_line(67, ng0);
    t2 = (t0 + 1844U);
    t4 = *((char **)t2);
    t9 = *((int *)t4);
    t1 = (t9 < 8);
    if (t1 != 0)
        goto LAB18;

LAB20:    t2 = (t0 + 592U);
    t4 = *((char **)t2);
    t1 = *((unsigned char *)t4);
    t3 = (t1 == (unsigned char)3);
    if (t3 != 0)
        goto LAB21;

LAB22:
LAB19:    goto LAB11;

LAB14:    xsi_set_current_line(75, ng0);
    t2 = (t0 + 592U);
    t4 = *((char **)t2);
    t1 = *((unsigned char *)t4);
    t3 = (t1 == (unsigned char)3);
    if (t3 != 0)
        goto LAB23;

LAB25:
LAB24:    xsi_set_current_line(78, ng0);
    t2 = (t0 + 2640);
    t4 = (t2 + 32U);
    t5 = *((char **)t4);
    t8 = (t5 + 40U);
    t11 = *((char **)t8);
    *((unsigned char *)t11) = (unsigned char)0;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(79, ng0);
    t2 = (t0 + 2676);
    t4 = (t2 + 32U);
    t5 = *((char **)t4);
    t8 = (t5 + 40U);
    t11 = *((char **)t8);
    *((unsigned char *)t11) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t2);
    goto LAB11;

LAB15:    xsi_set_current_line(63, ng0);
    t13 = (t0 + 2640);
    t17 = (t13 + 32U);
    t18 = *((char **)t17);
    t19 = (t18 + 40U);
    t20 = *((char **)t19);
    *((unsigned char *)t20) = (unsigned char)1;
    xsi_driver_first_trans_fast(t13);
    xsi_set_current_line(64, ng0);
    t2 = (t0 + 2676);
    t4 = (t2 + 32U);
    t5 = *((char **)t4);
    t8 = (t5 + 40U);
    t11 = *((char **)t8);
    *((unsigned char *)t11) = (unsigned char)3;
    xsi_driver_first_trans_fast_port(t2);
    goto LAB16;

LAB18:    xsi_set_current_line(68, ng0);
    t2 = (t0 + 592U);
    t5 = *((char **)t2);
    t3 = *((unsigned char *)t5);
    t2 = (t0 + 1844U);
    t8 = *((char **)t2);
    t21 = *((int *)t8);
    t22 = (t21 - 7);
    t23 = (t22 * -1);
    t24 = (1 * t23);
    t25 = (0U + t24);
    t2 = (t0 + 2712);
    t11 = (t2 + 32U);
    t13 = *((char **)t11);
    t14 = (t13 + 40U);
    t17 = *((char **)t14);
    *((unsigned char *)t17) = t3;
    xsi_driver_first_trans_delta(t2, t25, 1, 0LL);
    xsi_set_current_line(69, ng0);
    t2 = (t0 + 1844U);
    t4 = *((char **)t2);
    t9 = *((int *)t4);
    t21 = (t9 + 1);
    t2 = (t0 + 1844U);
    t5 = *((char **)t2);
    t2 = (t5 + 0);
    *((int *)t2) = t21;
    goto LAB19;

LAB21:    xsi_set_current_line(71, ng0);
    t2 = (t0 + 2640);
    t5 = (t2 + 32U);
    t8 = *((char **)t5);
    t11 = (t8 + 40U);
    t13 = *((char **)t11);
    *((unsigned char *)t13) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(72, ng0);
    t2 = (t0 + 1844U);
    t4 = *((char **)t2);
    t2 = (t4 + 0);
    *((int *)t2) = 0;
    goto LAB19;

LAB23:    xsi_set_current_line(76, ng0);
    t2 = (t0 + 1604U);
    t5 = *((char **)t2);
    t2 = (t0 + 2748);
    t8 = (t2 + 32U);
    t11 = *((char **)t8);
    t13 = (t11 + 40U);
    t14 = *((char **)t13);
    memcpy(t14, t5, 8U);
    xsi_driver_first_trans_fast_port(t2);
    goto LAB24;

}


extern void work_a_2239630122_3212880686_init()
{
	static char *pe[] = {(void *)work_a_2239630122_3212880686_p_0};
	xsi_register_didat("work_a_2239630122_3212880686", "isim/UARTTest_isim_beh.exe.sim/work/a_2239630122_3212880686.didat");
	xsi_register_executes(pe);
}
