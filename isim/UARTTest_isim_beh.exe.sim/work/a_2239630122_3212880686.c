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
static const char *ng0 = "D:/IS/CNC/UART.vhd";



static void work_a_2239630122_3212880686_p_0(char *t0)
{
    unsigned char t1;
    unsigned char t2;
    char *t3;
    unsigned char t4;
    char *t5;
    char *t6;
    unsigned char t7;
    unsigned char t8;
    char *t9;
    unsigned char t10;
    unsigned char t11;
    char *t12;
    int t13;
    unsigned char t14;
    char *t15;
    unsigned char t16;
    char *t17;
    char *t18;
    unsigned char t19;
    unsigned char t20;
    char *t21;
    char *t22;
    char *t23;
    char *t24;
    int t25;
    int t26;
    unsigned int t27;
    unsigned int t28;
    unsigned int t29;
    static char *nl0[] = {&&LAB15, &&LAB16, &&LAB17};

LAB0:    xsi_set_current_line(58, ng0);
    t3 = (t0 + 752U);
    t4 = xsi_signal_has_event(t3);
    if (t4 == 1)
        goto LAB8;

LAB9:    t2 = (unsigned char)0;

LAB10:    if (t2 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB2;

LAB4:
LAB3:    t3 = (t0 + 2832);
    *((int *)t3) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(59, ng0);
    t5 = (t0 + 1868U);
    t12 = *((char **)t5);
    t13 = *((int *)t12);
    t14 = (t13 == 5208);
    if (t14 != 0)
        goto LAB11;

LAB13:    xsi_set_current_line(83, ng0);
    t3 = (t0 + 1868U);
    t5 = *((char **)t3);
    t13 = *((int *)t5);
    t25 = (t13 + 1);
    t3 = (t0 + 1868U);
    t6 = *((char **)t3);
    t3 = (t6 + 0);
    *((int *)t3) = t25;

LAB12:    goto LAB3;

LAB5:    t5 = (t0 + 1696U);
    t9 = *((char **)t5);
    t10 = *((unsigned char *)t9);
    t11 = (!(t10));
    t1 = t11;
    goto LAB7;

LAB8:    t5 = (t0 + 776U);
    t6 = *((char **)t5);
    t7 = *((unsigned char *)t6);
    t8 = (t7 == (unsigned char)2);
    t2 = t8;
    goto LAB10;

LAB11:    xsi_set_current_line(60, ng0);
    t5 = (t0 + 1512U);
    t15 = *((char **)t5);
    t16 = *((unsigned char *)t15);
    t5 = (char *)((nl0) + t16);
    goto **((char **)t5);

LAB14:    xsi_set_current_line(81, ng0);
    t3 = (t0 + 1868U);
    t5 = *((char **)t3);
    t3 = (t5 + 0);
    *((int *)t3) = 0;
    goto LAB12;

LAB15:    xsi_set_current_line(62, ng0);
    t17 = (t0 + 592U);
    t18 = *((char **)t17);
    t19 = *((unsigned char *)t18);
    t20 = (t19 == (unsigned char)2);
    if (t20 != 0)
        goto LAB18;

LAB20:
LAB19:    goto LAB14;

LAB16:    xsi_set_current_line(67, ng0);
    t3 = (t0 + 1936U);
    t5 = *((char **)t3);
    t13 = *((int *)t5);
    t1 = (t13 < 8);
    if (t1 != 0)
        goto LAB21;

LAB23:    t3 = (t0 + 592U);
    t5 = *((char **)t3);
    t1 = *((unsigned char *)t5);
    t2 = (t1 == (unsigned char)3);
    if (t2 != 0)
        goto LAB24;

LAB25:
LAB22:    goto LAB14;

LAB17:    xsi_set_current_line(75, ng0);
    t3 = (t0 + 592U);
    t5 = *((char **)t3);
    t1 = *((unsigned char *)t5);
    t2 = (t1 == (unsigned char)3);
    if (t2 != 0)
        goto LAB26;

LAB28:
LAB27:    xsi_set_current_line(78, ng0);
    t3 = (t0 + 2884);
    t5 = (t3 + 32U);
    t6 = *((char **)t5);
    t9 = (t6 + 40U);
    t12 = *((char **)t9);
    *((unsigned char *)t12) = (unsigned char)0;
    xsi_driver_first_trans_fast(t3);
    xsi_set_current_line(79, ng0);
    t3 = (t0 + 2920);
    t5 = (t3 + 32U);
    t6 = *((char **)t5);
    t9 = (t6 + 40U);
    t12 = *((char **)t9);
    *((unsigned char *)t12) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t3);
    goto LAB14;

LAB18:    xsi_set_current_line(63, ng0);
    t17 = (t0 + 2884);
    t21 = (t17 + 32U);
    t22 = *((char **)t21);
    t23 = (t22 + 40U);
    t24 = *((char **)t23);
    *((unsigned char *)t24) = (unsigned char)1;
    xsi_driver_first_trans_fast(t17);
    xsi_set_current_line(64, ng0);
    t3 = (t0 + 2920);
    t5 = (t3 + 32U);
    t6 = *((char **)t5);
    t9 = (t6 + 40U);
    t12 = *((char **)t9);
    *((unsigned char *)t12) = (unsigned char)3;
    xsi_driver_first_trans_fast_port(t3);
    goto LAB19;

LAB21:    xsi_set_current_line(68, ng0);
    t3 = (t0 + 592U);
    t6 = *((char **)t3);
    t2 = *((unsigned char *)t6);
    t3 = (t0 + 1936U);
    t9 = *((char **)t3);
    t25 = *((int *)t9);
    t26 = (t25 - 7);
    t27 = (t26 * -1);
    t28 = (1 * t27);
    t29 = (0U + t28);
    t3 = (t0 + 2956);
    t12 = (t3 + 32U);
    t15 = *((char **)t12);
    t17 = (t15 + 40U);
    t18 = *((char **)t17);
    *((unsigned char *)t18) = t2;
    xsi_driver_first_trans_delta(t3, t29, 1, 0LL);
    xsi_set_current_line(69, ng0);
    t3 = (t0 + 1936U);
    t5 = *((char **)t3);
    t13 = *((int *)t5);
    t25 = (t13 + 1);
    t3 = (t0 + 1936U);
    t6 = *((char **)t3);
    t3 = (t6 + 0);
    *((int *)t3) = t25;
    goto LAB22;

LAB24:    xsi_set_current_line(71, ng0);
    t3 = (t0 + 2884);
    t6 = (t3 + 32U);
    t9 = *((char **)t6);
    t12 = (t9 + 40U);
    t15 = *((char **)t12);
    *((unsigned char *)t15) = (unsigned char)2;
    xsi_driver_first_trans_fast(t3);
    xsi_set_current_line(72, ng0);
    t3 = (t0 + 1936U);
    t5 = *((char **)t3);
    t3 = (t5 + 0);
    *((int *)t3) = 0;
    goto LAB22;

LAB26:    xsi_set_current_line(76, ng0);
    t3 = (t0 + 1604U);
    t6 = *((char **)t3);
    t3 = (t0 + 2992);
    t9 = (t3 + 32U);
    t12 = *((char **)t9);
    t15 = (t12 + 40U);
    t17 = *((char **)t15);
    memcpy(t17, t6, 8U);
    xsi_driver_first_trans_fast_port(t3);
    goto LAB27;

}

static void a_2239630122_3212880686clk_implicit_stable_0(char *t0)
{
    char *t1;
    char *t2;

LAB0:    t1 = (t0 + 3028);
    xsi_driver_trans_implicit_signal_stable_or_quiet(t1, 0LL);
    t2 = (t0 + 2840);
    *((int *)t2) = 1;

LAB1:    return;
}


extern void work_a_2239630122_3212880686_init()
{
	static char *pe[] = {(void *)work_a_2239630122_3212880686_p_0,(void *)a_2239630122_3212880686clk_implicit_stable_0};
	xsi_register_didat("work_a_2239630122_3212880686", "isim/UARTTest_isim_beh.exe.sim/work/a_2239630122_3212880686.didat");
	xsi_register_executes(pe);
}
