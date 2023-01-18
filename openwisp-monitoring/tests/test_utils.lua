package.path = package.path .. ";../files/lib/openwisp-monitoring/?.lua"

local luaunit = require('luaunit')

local utils = require('utils')

TestUtils = {}

function TestUtils.testSplitFunction()
  -- When pattern is present
  luaunit.assertEquals(utils.split("OpenWISP", "n"), {"Ope", "WISP"})
  luaunit.assertEquals(utils.split("OpenWISP", "WISP"), {"Open"})

  -- When pattern is not available
  luaunit.assertEquals(utils.split("OpenWISP", "a"), {"OpenWISP"})
end

function TestUtils.testHasValue()
  -- When value is present
  luaunit.assertEquals(utils.has_value({2, 4, 5}, 4), true)
  luaunit.assertEquals(utils.has_value({1, 2, 3, 7, 9}, 9), true)

  -- When value is not present
  luaunit.assertEquals(utils.has_value({2, 4, 5}, 3), false)
  luaunit.assertEquals(utils.has_value({1, 2, 3, 7, 9}, 8), false)

end

function TestUtils.testStartsWith()
  -- When string starts with the substring given
  luaunit.assertEquals(utils.starts_with("OpenWISP", "Open"), true)
  luaunit.assertEquals(utils.starts_with("NetJSON", "Net"), true)

  -- when string doesn't starts with the substring given
  luaunit.assertEquals(utils.starts_with("OpenWISP", "Ov"), false)
end

function TestUtils.testTableEmpty()
  -- When table is empty
  luaunit.assertEquals(utils.is_table_empty(nil), true)
  luaunit.assertEquals(utils.is_table_empty({}), true)

  -- When table is not empty
  luaunit.assertEquals(utils.is_table_empty({1, 2, 3, 4}), false)
  luaunit.assertEquals(utils.is_table_empty({"wireless", "wired", "system"}), false)
end

function TestUtils.testArrayConcat()
  luaunit.assertEquals(utils.array_concat({4, 5, 6}, {1, 2, 3}), {1, 2, 3, 4, 5, 6})
  luaunit.assertEquals(utils.array_concat({"wireless"}, {"wired"}),
    {"wired", "wireless"})
  luaunit.assertEquals(utils.array_concat({"system", "network"}, {"firewall"}),
    {"firewall", "system", "network"})
end

function TestUtils.testDictMerge()
  luaunit.assertEquals(utils.dict_merge({['1'] = 'OpenWISP'}, {['3'] = 'NetJSON'}),
    {["1"] = "OpenWISP", ["3"] = "NetJSON"})
  luaunit.assertEquals(utils.dict_merge({['1'] = 'OpenWISP'}, {['1'] = 'NetJSON'}),
    {["1"] = "OpenWISP"})
end

function TestUtils.testIsExcluded()
  luaunit.assertTrue(utils.is_excluded('lo'))
  luaunit.assertFalse(utils.is_excluded('wlo1'))
end

function TestUtils.testIsEmpty()
  luaunit.assertTrue(utils.is_empty(''))
  luaunit.assertTrue(utils.is_empty(nil))
  luaunit.assertTrue(utils.is_empty(false))
  luaunit.assertFalse(utils.is_empty('-12'))
  luaunit.assertFalse(utils.is_empty(12))
  luaunit.assertFalse(utils.is_empty(-12))
end

os.exit(luaunit.LuaUnit.run())
