#!/bin/bash

# Locations
#python manage.py loaddata locations.json


# Challenges Categories
#python manage.py loaddata categories.json


# Challenges
#python manage.py loadtestdata challenges.Challenge:50 -u challenges.fixtures.autofixtures.ChallengeAutoFixture



# Admin
echo "
from django.contrib.auth.models import User;
from accounts.models import UserProfile, Team;
from cities_light.models import Country;
from challenges.models import Challenge, ChallengeSolved;
from django.utils.timezone import now, timedelta;
import random;
import string;


# Admin
rand_pass = ''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(6));
admin_pass=input('Admin password [{}]:'.format(rand_pass)) or rand_pass;
admin=User.objects.create_superuser('admin', 'admin@admin.com', admin_pass);
team=Team.objects.create(name='admin');
UserProfile.objects.create(
    user=admin,
    job='job',
    gender='M',
    country=Country.objects.get_or_create(name='Italy')[0],
    team=team,
    skills='skill 1, skill 2, skill 3'
);


start = now() - timedelta(days=30)
admin.profile.created_at = start
admin.profile.save()

# User without solved challenges
user_no_solved=User.objects.create_user('demo', 'demo@demo.com', 'demo');
team_no_solved=Team.objects.create(name='Test Team');

UserProfile.objects.create(
    user=user_no_solved,
    job='job',
    gender='M',
    country=Country.objects.get_or_create(name='Italy')[0],
    team=team_no_solved,
    skills='skill 1, skill 2, skill 3'
);


start = now() - timedelta(days=30)
user_no_solved.profile.created_at = start
user_no_solved.profile.save()

for challenge in Challenge.objects.all():
    solved = ChallengeSolved.objects.create(
        user=admin.profile,
        challenge=challenge
    )
    solved.datetime = start + (now() - start) * random.random()
    print(solved.datetime)
    solved.save()

" | python manage.py shell



# Users Data
#python manage.py loadtestdata accounts.Team:10 -u accounts.fixtures.autofixtures.TeamAutoFixture
#python manage.py loadtestdata auth.User:50 -u accounts.fixtures.autofixtures.UserAutoFixture
#python manage.py loadtestdata accounts.UserProfile:50 -u accounts.fixtures.autofixtures.UserProfileAutoFixture
