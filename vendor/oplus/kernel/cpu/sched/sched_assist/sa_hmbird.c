// SPDX-License-Identifier: GPL-2.0-only
/*
 * Copyright (C) 2025 Oplus. All rights reserved.
 */

#include <linux/sched.h>
#include <linux/sched/cputime.h>
#include <kernel/sched/sched.h>

#include "sa_common.h"
#include "sa_hmbird.h"


bool test_task_is_hmbird(struct task_struct *p)
{
	return false;
}
EXPORT_SYMBOL(test_task_is_hmbird);

void hmbird_sched_ops_init(void)
{
}

bool is_hmbird_enable(void)
{
	return false;
}

void set_ux_task_dsq_id(struct task_struct *task)
{
}


