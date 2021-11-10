import logging

from rest_framework import viewsets
from rest_framework.response import Response

logger = logging.getLogger(__name__)

from time import sleep


class InfoViewSet(viewsets.ViewSet):
    def list(self, request, *args, **kwargs):
        data = dict(hello='world')
        logger.warn('test')
        return Response(data)
