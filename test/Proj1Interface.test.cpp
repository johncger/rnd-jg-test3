/*
 * Copyright (c) 2022 Harvest Technology Group Pty Ltd. All Rights Reserved.
 * @file InterfaceExample.test.cpp
 * @brief
 * @date 10/06/2022
 * @author Olesia Kochergina
 * @version
 * See the COPYRIGHT file at the top-level directory of this distribution for details of code ownership.
 * -----
 * Last Modified: 10/06/2022
 * Modified By: Olesia Kochergina
 * -----
 * HISTORY:
 */


#include "Proj1Interface.hpp"
#include "Dog.hpp"

#include <gtest/gtest.h>

TEST(InterfaceExample, ValidateHelloWorld) {
    PROJ1::Proj1Interface interface;
    EXPECT_EQ(interface.GetHelloWorld(), "Hello World! I come from InternalExample");
    PROJ1::Dog d;
    ASSERT_EQ(d.Type(), "Dog");
}
