from django.contrib.gis.db import models
from django.utils import timezone

from contrib.timescale.fields import TimescaleDateTimeField


class Event(models.Model):
    data = models.JSONField(blank=True, null=True)
    location = models.PointField(srid=4326, blank=True, null=True)
    created_at = TimescaleDateTimeField(interval='1 day', default=timezone.now)
