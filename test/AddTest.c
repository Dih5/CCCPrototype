#include <stdlib.h>
#include <stdio.h>

#include "CuTest.h"

#include "../src/add.h"

#define eps 0.00001

/*-------------------------------------------------------------------------*
 * Add Test
 *-------------------------------------------------------------------------*/

void Test2plus2(CuTest* tc) {
	float a[1] = { 2.0 };
	float b[1] = { 2.0 };
	float c[1] = { 0.0 };
	Add(a, b, c, 1);
	CuAssertDblEquals(tc, 4.0, c[0], eps);
}

void TestAdd100(CuTest* tc) {
	float a[100];
	float b[100];
	float c[100];
	for (int i = 0; i < 100; ++i) {
		a[i]=i;
		b[i]=100-i;
	}
	Add(a, b, c, 100);
	for (int i = 0; i < 100; ++i) {
		CuAssertDblEquals(tc, 100.0, c[i], eps);
	}
}

CuSuite* AddGetSuite(void) {
	CuSuite* suite = CuSuiteNew();

	SUITE_ADD_TEST(suite, Test2plus2);
	SUITE_ADD_TEST(suite, TestAdd100);

	return suite;
}
