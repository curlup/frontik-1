from frontik.handler import HTTPError, PageHandler
from frontik.preprocessors import preprocessor


@preprocessor
def pp_before(handler):
    handler.run.append('before')


@preprocessor
def pp(handler):
    def _cb(_, __):
        handler.json.put({'put_request_finished': True})

    future = handler.put_url(handler.request.host, handler.request.path, callback=_cb)
    handler.run.append('pp')

    if handler.get_argument('raise_error', 'false') != 'false':
        raise HTTPError(400)
    elif handler.get_argument('raise_custom_error', 'false') != 'false':
        raise HTTPError(400, json={'custom_error': True})
    elif handler.get_argument('abort_page', 'false') != 'false':
        handler.abort_page(wait_finish_group=False)
    elif handler.get_argument('abort_page_nowait', 'false') != 'false':
        handler.abort_page(wait_finish_group=True)
    elif handler.get_argument('redirect', 'false') != 'false':
        handler.redirect(handler.request.host + handler.request.path + '?redirected=true')
    elif handler.get_argument('finish', 'false') != 'false':
        handler.finish('finished')
    else:
        yield future


@preprocessor
def pp_after(handler):
    handler.run.append('after')


class Page(PageHandler):
    def prepare(self):
        super(Page, self).prepare()

        self.run = []
        self.json.put({
            'run': self.run
        })

        self.add_postprocessor(lambda handler: handler.json.put({'postprocessor': True}))

    @pp_before
    @pp
    @pp_after
    def get_page(self):
        self.run.append('get_page')

    def put_page(self):
        pass
