from collections import defaultdict
from django.contrib.auth.decorators import login_required
from django.shortcuts import render

from accounts.models import Team
from challenges.models import Challenge, ChallengeSolved, Category

import json


@login_required
def index(request):
    parameters = {
        'teams': Team.objects.all()
    }

    return render(request, 'accounts/teams.html', parameters)


@login_required
def team(request, pk=None):
    team = request.user.profile.team if pk is None else Team.objects.get(pk=pk)

    time_points = []
    points = 0
    for solved in ChallengeSolved.objects.filter(user__profile__team=team).distinct().order_by('datetime'):
        points += solved.challenge.points
        time_points.append([int(solved.datetime.timestamp())*1000, points])

    c_count = Category.objects.count()
    category_solved = {
        c.name: int(team.solved_challenges.filter(category=c).count() / c_count * 100)
        for c in Category.objects.all()
    }

    parameters = {
        'team': team,
        'total_points_count': Challenge.objects.total_points(),
        'teams_count': Team.objects.count(),

        'time_points': json.dumps(time_points),
        'category_solved': category_solved
    }

    return render(request, 'accounts/team.html', parameters)

