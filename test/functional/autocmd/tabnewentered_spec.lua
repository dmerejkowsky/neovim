local helpers = require('test.functional.helpers')(after_each)
local clear, nvim, eq = helpers.clear, helpers.nvim, helpers.eq

describe('TabNewEntered', function()
  describe('au TabNewEntered', function()
    describe('with * as <afile>', function()
      it('matches when entering any new tab', function()
        clear()
        nvim('command', 'au! TabNewEntered * echom "tabnewentered:".tabpagenr().":".bufnr("")')
        eq("\ntabnewentered:2:2", nvim('command_output', 'tabnew'))
        eq("\n\"test.x2\" [New File]\ntabnewentered:3:3", nvim('command_output', 'tabnew test.x2'))
     end)
    end)
    describe('with FILE as <afile>', function()
      it('matches when opening a new tab for FILE', function()
        local tmp_path = nvim('eval', 'tempname()')
        nvim('command', 'au! TabNewEntered '..tmp_path..' echom "tabnewentered:match"')
        eq("\n\""..tmp_path.."\" [New File]\ntabnewentered:4:4\ntabnewentered:match", nvim('command_output', 'tabnew '..tmp_path))
     end)
    end)
    describe('with CTRL-W T', function()
      it('works when opening a new tab with CTRL-W T', function()
        clear()
        nvim('command', 'au! TabNewEntered * echom "entered"')
        nvim('command', 'tabnew test.x2')
        nvim('command', 'split')
        eq('\nentered', nvim('command_output', 'execute "normal \\<C-W>T"'))
      end)
    end)
    describe('with :tab split', function()
      it('works when using :tab split', function()
        clear()
        nvim('command', 'au! TabNewEntered * echom "entered"')
        nvim('command', 'edit test.x2')
        eq('\nentered', nvim('command_output', 'tab split'))
      end)
    end)
  end)
end)
