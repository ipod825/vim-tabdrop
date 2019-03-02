import vim

back_dict = {}


def tabdrop(path):
    for tab in vim.tabpages:
        for window in tab.windows:
            if window.buffer.name == path:
                back_dict[path] = vim.current.buffer.name
                vim.command("tabnext {}".format(tab.number))
                return
    back_dict[path] = vim.current.buffer.name
    vim.command("tabedit {}".format(path))


def back_to_last_tab():
    path = back_dict.pop(vim.current.buffer.name, None)
    if not path:
        return
    if vim.eval('g:tabdrop_close_on_back') == '1':
        print(vim.eval('g:tabdrop_close_on_back') == '1')
        vim.command('close')

    for tab in vim.tabpages:
        for window in tab.windows:
            if window.buffer.name == path:
                vim.command("tabnext {}".format(tab.number))
                return
