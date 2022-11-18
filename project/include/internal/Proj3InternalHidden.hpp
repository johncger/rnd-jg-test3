/*
 * Copyright (c) 2022 Harvest Technology Group Pty Ltd. All Rights Reserved.
 * @file InternalExample.hpp
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


#ifndef PROJ3_INTERNAL_HIDDEN_HPP
#define PROJ3_INTERNAL_HIDDEN_HPP
#include <string>

namespace PROJ3 {
class Proj3InternalHidden {
 public:
    Proj3InternalHidden();

    ~Proj3InternalHidden();

    std::string GetName() const;

 private:
    std::string _name = "I come from Proj3InternalHidden";
};

}  // namespace PROJ3
#endif