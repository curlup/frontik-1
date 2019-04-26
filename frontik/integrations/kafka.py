import asyncio
from asyncio import Future
from typing import Optional

from aiokafka import AIOKafkaProducer
from tornado import gen

from frontik.integrations import Integration
from frontik.options import options


class KafkaIntegration(Integration):
    def __init__(self):
        self.kafka_producers = {}

    def initialize_app(self, app) -> Optional[Future]:
        def get_kafka_producer(producer_name: str) -> AIOKafkaProducer:
            return self.kafka_producers.get(producer_name)

        app.get_kafka_producer = get_kafka_producer

        if options.kafka_clusters:
            init_futures = []

            for cluster_name, cluster_settings in options.kafka_clusters.items():
                if cluster_settings:
                    producer = AIOKafkaProducer(loop=asyncio.get_event_loop(), **cluster_settings)
                    self.kafka_producers[cluster_name] = producer
                    init_futures.append(asyncio.ensure_future(producer.start()))

            return gen.multi(init_futures)

        return None

    def initialize_handler(self, handler):
        handler.get_kafka_producer = handler.application.get_kafka_producer