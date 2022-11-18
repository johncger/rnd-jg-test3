/*
 * Copyright (c) 2022 Harvest Technology Group Pty Ltd. All Rights Reserved.
 * @file InterfaceExample.cpp
 * @brief
 * @date 10/06/2022
 * @author Olesia Kochergina
 * @version
 * See the COPYRIGHT file at the top-level directory of this distribution for details of code ownership.
 * -----
 * Last Modified:
 * Modified By:
 * -----
 */


#include "Proj3Interface.hpp"
#include "Proj3InternalHidden.hpp"

namespace PROJ3 {

class Proj3Interface::Proj3Impl {
 public:
    std::string GetMessage() { return _hello.append(_example.GetName()); }

 private:
    std::string _hello = "Hello World! ";

    Proj3InternalHidden _example;
};

Proj3Interface::Proj3Interface() : _impl(new Proj3Interface::Proj3Impl()) {}

Proj3Interface::~Proj3Interface() = default;

std::string Proj3Interface::GetHelloWorld() const { return _impl->GetMessage(); }

}  // namespace PROJ3