from api.info.views import InfoViewSet
from rest_framework import routers

app_name = 'api'
router = routers.DefaultRouter()
router.register('info', InfoViewSet, basename='info')
urlpatterns = router.urls
