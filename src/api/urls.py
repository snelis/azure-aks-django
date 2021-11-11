from rest_framework import routers

from api.events.views import EventViewSet
from api.info.views import InfoViewSet

app_name = 'api'
router = routers.DefaultRouter()
router.register('info', InfoViewSet, basename='info')
router.register('events', EventViewSet, basename='events')
urlpatterns = router.urls
