from rest_framework import routers
from .views import TeamCreateViewSet

router = routers.SimpleRouter()
router.register(r'team-create', TeamCreateViewSet, 'team')

urlpatterns = router.urls