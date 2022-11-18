/*
 * Copyright (c) 2022 Harvest Technology Group Pty Ltd. All Rights Reserved.
 * @file InterfaceExample.hpp
 * @brief
 * @date 01/03/2022
 * @author Olesia Kochergina
 * @version
 * See the COPYRIGHT file at the top-level directory of this distribution for details of code ownership.
 * -----
 * Last Modified:
 * Modified By:
 * -----
 */


#ifndef PROJ3_INTERFACE_HPP
#define PROJ3_INTERFACE_HPP
#include <memory>
#include <string>

namespace PROJ3 {
class Proj3Interface {
 public:
    Proj3Interface();
    ~Proj3Interface();

    std::string GetHelloWorld() const;

 private:
    class Proj3Impl;
    std::unique_ptr<Proj3Impl> _impl;
};
}  // namespace PROJ3
#endif