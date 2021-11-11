from rest_framework import viewsets

from api.events.serializers import EventSerializer
from events.models import Event


class EventViewSet(viewsets.ModelViewSet):
    queryset = Event.objects.all()
    serializer_class = EventSerializer
