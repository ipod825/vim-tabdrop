import vim


def tabdrop(path):
    for tab in vim.tabpages:
        for window in tab.windows:
            if window.buffer.name == path:
                vim.command("tabnext {}".format(tab.number))
                return
    vim.command("tabedit {}".format(path))


tags = []


def tabdrop_push_tag():
    tags.append((vim.current.buffer.name, vim.eval('line(".")'),
                 vim.eval('col(".")')))


def tabdrop_pop_tag():
    if len(tags) == 0:
        return
    path, line, col = tags.pop()

    for tab in vim.tabpages:
        for window in tab.windows:
            if window.buffer.name == path:
                if vim.eval(
                        'g:tabdrop_close_on_poptag'
                ) == '1' and tab.number != vim.current.tabpage.number:
                    vim.command('close')

                vim.command("tabnext {}".format(tab.number))
                vim.command('normal! {}G'.format(line))
                vim.command('normal! {}|'.format(col))
                return
