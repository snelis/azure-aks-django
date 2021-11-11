from rest_framework import serializers
from rest_framework_gis.serializers import GeoModelSerializer

from events.models import Event


class EventSerializer(GeoModelSerializer):
    class Meta:
        model = Event
        geo_field = 'location'
        fields = ['pk', 'data', 'location', 'created_at']
