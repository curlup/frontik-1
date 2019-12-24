import importlib
import logging
import pkgutil
from asyncio import Future
from typing import List, Optional, Tuple

from frontik.options import options

integrations_logger = logging.getLogger('integrations')


def load_integrations(app) -> Tuple[List['Integration'], List[Future], List[Future]]:
    for importer, module_name, is_package in pkgutil.iter_modules(__path__):
        try:
            importlib.import_module(f'frontik.integrations.{module_name}')
        except Exception as e:
            integrations_logger.info('%s integration is not available: %s', module_name, e)

    available_integrations = []
    init_before_server_start_futures = []
    init_after_server_start_futures = []

    for integration_class in Integration.__subclasses__():
        integration = integration_class()
        if integration.run_on_master_process_only and not options.master_process:
            continue
        init_future = integration.initialize_app(app)
        if init_future is not None:
            if integration.is_server_required():
                init_after_server_start_futures.append(init_future)
            else:
                init_before_server_start_futures.append(init_future)

        available_integrations.append(integration)

    return available_integrations, init_before_server_start_futures, init_after_server_start_futures,


class Integration:
    def initialize_app(self, app) -> Optional[Future]:
        raise NotImplementedError()  # pragma: no cover

    def deinitialize_app(self, app) -> Optional[Future]:
        pass  # pragma: no cover

    def initialize_handler(self, handler):
        raise NotImplementedError()  # pragma: no cover

    def is_server_required(self) -> bool:
        return False

    def run_on_master_process_only(self) -> bool:
        return False
