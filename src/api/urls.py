from rest_framework import routers

from api.info.views import InfoViewSet

app_name = 'api'
router = routers.DefaultRouter()
router.register('info', InfoViewSet, basename='info')
urlpatterns = router.urls
