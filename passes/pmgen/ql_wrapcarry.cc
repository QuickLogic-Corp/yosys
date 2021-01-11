/*
 *  yosys -- Yosys Open SYnthesis Suite
 *
 *  Copyright (C) 2020 QuickLogic Corp.
 *
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */

#include "kernel/yosys.h"
#include "kernel/sigtools.h"

USING_YOSYS_NAMESPACE
PRIVATE_NAMESPACE_BEGIN

#include "passes/pmgen/ql_wrapcarry_pm.h"

void create_ql_wrapcarry(ql_wrapcarry_pm &pm)
{
    auto &st = pm.st_ql_wrapcarry;

#if 0
    log("\n");
    log("carry: %s\n", log_id(st.carry, "--"));
    log("lut:   %s\n", log_id(st.lut, "--"));
#endif

    log("  replacing LUT4 + carry_follower with soft_adder cell.\n");

    Cell *cell = pm.module->addCell(NEW_ID, ID(soft_adder));
    pm.module->swap_names(cell, st.carry);

    cell->setPort(ID::A, st.carry->getPort(ID(A)));
    cell->setPort(ID::B, st.carry->getPort(ID(B)));
    auto CI = st.carry->getPort(ID::CI);
    cell->setPort(ID::CI, CI);
    cell->setPort(ID::CO, st.carry->getPort(ID::CO));

    auto I2 = st.lut->getPort(ID(I2));
    if (pm.sigmap(CI) == pm.sigmap(I2)) {
        cell->setParam(ID(I2_IS_CI), State::S1);
        I2 = State::Sx;
    }
    else
        cell->setParam(ID(I2_IS_CI), State::S0);
    cell->setPort(ID(I2), I2);
    cell->setPort(ID(I3), st.lut->getPort(ID(I3)));
    cell->setPort(ID::O, st.lut->getPort(ID::O));

    if (!st.lut->hasParam(ID(INIT))) {
        log_error("Cell '%s' of type '%s' has no 'INIT' parameter!\n",
            st.lut->name.c_str(), st.lut->type.c_str());
    }
    cell->setParam(ID::LUT, st.lut->getParam(ID(INIT)));

    for (const auto &a : st.carry->attributes)
        cell->attributes[stringf("\\carry_follower.%s", a.first.c_str())] = a.second;
    for (const auto &a : st.lut->attributes)
        cell->attributes[stringf("\\LUT4.%s", a.first.c_str())] = a.second;
    cell->attributes[ID(LUT4.name)] = Const(st.lut->name.str());
    if (st.carry->get_bool_attribute(ID::keep) || st.lut->get_bool_attribute(ID::keep))
        cell->attributes[ID::keep] = true;

    pm.autoremove(st.carry);
    pm.autoremove(st.lut);
}

struct QLWrapCarryPass : public Pass {
    QLWrapCarryPass() : Pass("ql_wrapcarry", "QL: wrap carries") { }
    void help() YS_OVERRIDE
    {
        //   |---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|
        log("\n");
        log("    ql_wrapcarry [selection]\n");
        log("\n");
        log("Wrap manually instantiated carry_follower cells, along with their associated LUT4s,\n");
        log("into an internal soft_adder cell for preservation across technology\n");
        log("mapping.\n");
        log("\n");
        log("Attributes on both cells will have their names prefixed with 'carry_follower.' or\n");
        log("'LUT4.' and attached to the wrapping cell.\n");
        log("A (* keep *) attribute on either cell will be logically OR-ed together.\n");
        log("\n");
        log("    -unwrap\n");
        log("        unwrap soft_adder cells back into carry_followers and LUT4s,\n");
        log("        including restoring their attributes.\n");
        log("\n");
    }
    void execute(std::vector<std::string> args, RTLIL::Design *design) YS_OVERRIDE
    {
        bool unwrap = false;

        log_header(design, "Executing ql_wrapcarry pass (wrap carries).\n");

        size_t argidx;
        for (argidx = 1; argidx < args.size(); argidx++)
        {
            if (args[argidx] == "-unwrap") {
                unwrap = true;
                continue;
            }
            break;
        }
        extra_args(args, argidx, design);

        for (auto module : design->selected_modules()) {
            if (!unwrap) {
                ql_wrapcarry_pm(module, module->selected_cells()).run_ql_wrapcarry(create_ql_wrapcarry);
            } else {
                for (auto cell : module->selected_cells()) {
                    if (cell->type != ID(soft_adder))
                        continue;

                    auto carry = module->addCell(NEW_ID, ID(carry_follower));
                    carry->setPort(ID(A), cell->getPort(ID::A));
                    carry->setPort(ID(B), cell->getPort(ID::B));
                    auto CI = cell->getPort(ID::CI);
                    carry->setPort(ID::CI, (CI.empty()) ? RTLIL::Const(RTLIL::State::Sx) : CI);
                    carry->setPort(ID::CO, cell->getPort(ID::CO));
                    module->swap_names(carry, cell);
                    auto lut_name = cell->attributes.at(ID(LUT4.name), Const(NEW_ID.str())).decode_string();
                    auto lut = module->addCell(lut_name, ID($lut));

                    lut->setParam(ID::WIDTH, 4);

                    if (!cell->hasParam(ID::LUT))
                        log_error("Cell '%s' of type '%s' has no 'LUT' parameter!\n",
                            cell->name.c_str(), cell->type.c_str());
                    lut->setParam(ID::LUT, cell->getParam(ID::LUT));

                    if (!cell->hasParam(ID(I2_IS_CI)))
                        log_error("Cell '%s' of type '%s' has no 'I2_IS_CI' parameter!\n",
                            cell->name.c_str(), cell->type.c_str());
                    auto I2 = cell->getPort(cell->getParam(ID(I2_IS_CI)).as_bool() ? ID::CI : ID(I2));

                    // Build new connection to the $lut.A port
                    std::vector<RTLIL::SigSpec> parts = {
                        cell->getPort(ID::A),
                        cell->getPort(ID::B),
                        I2,
                        cell->getPort(ID(I3))
                    };

                    RTLIL::SigSpec signal(RTLIL::State::Sx, 4);
                    for (size_t i=0; i<4; ++i) {
                        if (!parts[i].empty()) {

                            // Sanity check
                            if (parts[i].size() != 1) {
                                log_error("Port I%zu connected to a vector %s",
                                    i, log_signal(parts[i]));
                            }

                            signal.replace(i, parts[i]);
                        }
                    }

                    lut->setPort(ID::A, signal);
                    lut->setPort(ID::Y, cell->getPort(ID::O));

                    Const src;
                    for (const auto &a : cell->attributes)
                        if (a.first.begins_with("\\carry_follower.\\"))
                            carry->attributes[a.first.c_str() + strlen("\\carry_follower.")] = a.second;
                        else if (a.first.begins_with("\\LUT4.\\"))
                            lut->attributes[a.first.c_str() + strlen("\\LUT4.")] = a.second;
                        else if (a.first == ID::src)
                            src = a.second;
                        else if (a.first.in(ID(LUT4.name), ID::keep, ID::module_not_derived))
                            continue;
                        else
                            log_abort();

                    if (!src.empty()) {
                        carry->attributes.insert(std::make_pair(ID::src, src));
                        lut->attributes.insert(std::make_pair(ID::src, src));
                    }

                    module->remove(cell);
                }
            }
        }
    }
} QLWrapCarryPass;

PRIVATE_NAMESPACE_END
