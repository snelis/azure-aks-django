from rest_framework import viewsets
from rest_framework.response import Response


class InfoViewSet(viewsets.ViewSet):
    def list(self, request, *args, **kwargs):
        data = dict(hello='world')
        return Response(data)
